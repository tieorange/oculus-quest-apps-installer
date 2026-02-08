package com.questgamemanager.quest_game_manager

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.apache.commons.compress.archivers.sevenz.SevenZFile
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val ARCHIVE_CHANNEL = "com.questgamemanager.quest_game_manager/archive"
    private lateinit var installerChannel: PackageInstallerChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Archive extraction channel
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, ARCHIVE_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "extract7z") {
                val filePath = call.argument<String>("filePath")
                val outDir = call.argument<String>("outDir")
                val password = call.argument<String>("password")

                if (filePath != null && outDir != null) {
                    Thread {
                        try {
                            extract7z(filePath, outDir, password)
                            runOnUiThread { result.success(true) }
                        } catch (e: Exception) {
                            runOnUiThread { result.error("ExtractionError", e.message, null) }
                        }
                    }.start()
                } else {
                    result.error("InvalidArgs", "File path or output directory is null", null)
                }
            } else {
                result.notImplemented()
            }
        }

        // Package installer channel (APK install, package queries, launch)
        installerChannel = PackageInstallerChannel(this)
        installerChannel.register()
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            PackageInstallerChannel.CHANNEL_NAME
        ).setMethodCallHandler(installerChannel)
    }

    override fun onDestroy() {
        installerChannel.unregister()
        super.onDestroy()
    }

    private fun extract7z(filePath: String, outDir: String, password: String?) {
        val file = File(filePath)
        if (!file.exists()) {
            throw Exception("File not found: $filePath")
        }

        val sevenZFile = if (password != null) {
            SevenZFile(file, password.toCharArray())
        } else {
            SevenZFile(file)
        }

        try {
            var entry = sevenZFile.nextEntry
            while (entry != null) {
                if (entry.isDirectory) {
                    File(outDir, entry.name).mkdirs()
                } else {
                    val outFile = File(outDir, entry.name)
                    outFile.parentFile?.mkdirs()
                    val out = FileOutputStream(outFile)
                    val buffer = ByteArray(8192)
                    var len: Int
                    while (sevenZFile.read(buffer).also { len = it } > 0) {
                        out.write(buffer, 0, len)
                    }
                    out.close()
                }
                entry = sevenZFile.nextEntry
            }
        } finally {
            sevenZFile.close()
        }
    }
}
