package com.franek.tempo

import android.app.AppOpsManager
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Process
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Most do `UsageStatsManager`.
 *
 * Android nie pozwala pytać „co jest teraz na wierzchu" bez usług
 * dostępności, ale pozwala odczytać historię zdarzeń wstecz. To wystarcza
 * i jest wyraźnie tańsze: żadnej usługi w tle, żadnego wyjątku od
 * optymalizacji baterii, żadnej stałej notyfikacji.
 */
class MainActivity : FlutterActivity() {

    private companion object {
        const val CHANNEL = "tempo/usage"
        const val INSTALLER_CHANNEL = "tempo/installer"

        /** Przerwa, przy której dwa odcinki tej samej aplikacji zostają sklejone. */
        const val MERGE_GAP_MS = 30_000L

        /** Krótsze przebłyski to przypadkowe przełączenia, nie używanie aplikacji. */
        const val MIN_INTERVAL_MS = 3_000L
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "hasPermission" -> result.success(hasUsagePermission())

                    "requestPermission" -> {
                        openUsageAccessSettings()
                        result.success(null)
                    }

                    "queryIntervals" -> {
                        if (!hasUsagePermission()) {
                            result.success(emptyList<Map<String, Any>>())
                            return@setMethodCallHandler
                        }
                        val from = call.argument<Number>("from")?.toLong() ?: 0L
                        val to = call.argument<Number>("to")?.toLong()
                            ?: System.currentTimeMillis()
                        result.success(queryIntervals(from, to))
                    }

                    else -> result.notImplemented()
                }
            }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, INSTALLER_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "canInstall" -> result.success(canRequestInstalls())

                    "requestInstallPermission" -> {
                        openUnknownSourcesSettings()
                        result.success(null)
                    }

                    "install" -> {
                        val path = call.argument<String>("path")
                        if (path == null) {
                            result.error("NO_PATH", "Nie podano ścieżki do pliku APK", null)
                        } else {
                            try {
                                installApk(path)
                                result.success(null)
                            } catch (e: Exception) {
                                result.error("INSTALL_FAILED", e.message, null)
                            }
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }

    private fun canRequestInstalls(): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            packageManager.canRequestPackageInstalls()
        } else {
            // Przed Androidem 8 zgoda była globalna, a nie per aplikacja,
            // więc nie ma czego sprawdzać.
            true
        }
    }

    private fun openUnknownSourcesSettings() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val intent = Intent(
            Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
            Uri.parse("package:$packageName")
        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        try {
            startActivity(intent)
        } catch (_: Exception) {
            startActivity(
                Intent(Settings.ACTION_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            )
        }
    }

    /**
     * Oddaje plik APK systemowemu instalatorowi.
     *
     * Plik musi trafić do instalatora jako `content://` przez [FileProvider] —
     * od Androida 7 przekazanie `file://` innej aplikacji rzuca
     * `FileUriExposedException`. Nadanie [Intent.FLAG_GRANT_READ_URI_PERMISSION]
     * jest równie konieczne: bez tego instalator dostanie adres, którego
     * nie ma prawa odczytać.
     *
     * Instalacji po cichu tu nie ma i być nie może — użytkownik zawsze
     * zobaczy systemowy ekran potwierdzenia.
     */
    private fun installApk(path: String) {
        val file = File(path)
        if (!file.exists()) throw IllegalStateException("Plik $path nie istnieje")

        val uri: Uri = FileProvider.getUriForFile(
            this,
            "$packageName.fileprovider",
            file
        )

        val intent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(uri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        startActivity(intent)
    }

    /**
     * `PACKAGE_USAGE_STATS` to uprawnienie specjalne — nie da się go przyznać
     * zwykłym dialogiem, a jego stan sprawdza się przez [AppOpsManager],
     * nie przez `checkSelfPermission`.
     */
    private fun hasUsagePermission(): Boolean {
        val appOps = getSystemService(Context.APP_OPS_SERVICE) as? AppOpsManager
            ?: return false

        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                packageName
            )
        } else {
            @Suppress("DEPRECATION")
            appOps.checkOpNoThrow(
                AppOpsManager.OPSTR_GET_USAGE_STATS,
                Process.myUid(),
                packageName
            )
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun openUsageAccessSettings() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        // Część nakładek producenta nie ma tego ekranu — wtedy lądujemy
        // w ustawieniach ogólnych, zamiast wywalać aplikację.
        try {
            startActivity(intent)
        } catch (_: Exception) {
            startActivity(
                Intent(Settings.ACTION_SETTINGS).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            )
        }
    }

    /**
     * Buduje przedziały użycia ze strumienia zdarzeń.
     *
     * System nie oddaje gotowych odcinków — daje osobne zdarzenia wejścia
     * i wyjścia z pierwszego planu, które trzeba sparować. Nietrywialne są
     * dwa przypadki brzegowe:
     *  * aplikacja weszła na wierzch przed początkiem okna i nadal tam jest,
     *  * ostatnie zdarzenie to wejście bez pary (aplikacja jest na wierzchu
     *    w tej chwili) — taki odcinek domykamy końcem okna.
     */
    private fun queryIntervals(from: Long, to: Long): List<Map<String, Any>> {
        val manager = getSystemService(Context.USAGE_STATS_SERVICE) as? UsageStatsManager
            ?: return emptyList()

        val resumed = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            UsageEvents.Event.ACTIVITY_RESUMED
        } else {
            @Suppress("DEPRECATION")
            UsageEvents.Event.MOVE_TO_FOREGROUND
        }
        val paused = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            UsageEvents.Event.ACTIVITY_PAUSED
        } else {
            @Suppress("DEPRECATION")
            UsageEvents.Event.MOVE_TO_BACKGROUND
        }

        val events = manager.queryEvents(from, to)
        val event = UsageEvents.Event()

        val out = mutableListOf<Triple<String, Long, Long>>()
        var openPackage: String? = null
        var openStart = 0L

        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            val pkg = event.packageName ?: continue

            when (event.eventType) {
                resumed -> {
                    // Wejście bez domknięcia poprzedniego: system bywa
                    // niekompletny. Zamykamy poprzedni odcinek tu i teraz.
                    if (openPackage != null && openPackage != pkg) {
                        out.add(Triple(openPackage, openStart, event.timeStamp))
                    }
                    openPackage = pkg
                    openStart = event.timeStamp
                }

                paused -> {
                    if (openPackage == pkg) {
                        out.add(Triple(pkg, openStart, event.timeStamp))
                        openPackage = null
                    }
                }
            }
        }

        // Aplikacja wciąż na pierwszym planie w chwili odpytania.
        openPackage?.let { out.add(Triple(it, openStart, to)) }

        return merge(out).mapNotNull { (pkg, start, end) ->
            if (end - start < MIN_INTERVAL_MS) return@mapNotNull null
            mapOf(
                "packageId" to pkg,
                "label" to labelFor(pkg),
                "start" to start,
                "end" to end
            )
        }
    }

    /** Skleja sąsiadujące odcinki tej samej aplikacji rozdzielone krótką przerwą. */
    private fun merge(raw: List<Triple<String, Long, Long>>): List<Triple<String, Long, Long>> {
        if (raw.isEmpty()) return raw
        val sorted = raw.sortedBy { it.second }
        val out = mutableListOf(sorted.first())

        for (i in 1 until sorted.size) {
            val current = sorted[i]
            val last = out.last()
            if (current.first == last.first && current.second - last.third <= MERGE_GAP_MS) {
                out[out.lastIndex] = Triple(last.first, last.second, maxOf(last.third, current.third))
            } else {
                out.add(current)
            }
        }
        return out
    }

    private val labelCache = mutableMapOf<String, String>()

    /**
     * Nazwa aplikacji widoczna dla człowieka.
     *
     * Od Androida 11 widoczność pakietów jest ograniczona i dla części
     * z nich odczyt się nie uda — wtedy zostaje nazwa pakietu, co i tak
     * wystarcza do klasyfikacji, bo reguły dopasowują się właśnie do niej.
     */
    private fun labelFor(pkg: String): String = labelCache.getOrPut(pkg) {
        try {
            val info = packageManager.getApplicationInfo(pkg, 0)
            packageManager.getApplicationLabel(info).toString()
        } catch (_: PackageManager.NameNotFoundException) {
            pkg
        } catch (_: Exception) {
            pkg
        }
    }
}
