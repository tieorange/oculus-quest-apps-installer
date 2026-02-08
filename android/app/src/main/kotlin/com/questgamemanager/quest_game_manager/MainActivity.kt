package com.questgamemanager.quest_game_manager

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import org.apache.commons.compress.archivers.sevenz.SevenZFile
import java.io.File
import java.io.FileOutputStream

class MainActivity : FlutterActivity() {
    private val ARCHIVE_CHANNEL = "com.questgamemanager.quest_game_manager/archive"
    private val PROGRESS_CHANNEL = "com.questgamemanager.quest_game_manager/archive_progress"
    private lateinit var installerChannel: PackageInstallerChannel
    private var progressEventSink: io.flutter.plugin.common.EventChannel.EventSink? = null

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

        // Progress event channel
        io.flutter.plugin.common.EventChannel(flutterEngine.dartExecutor.binaryMessenger, PROGRESS_CHANNEL).setStreamHandler(
            object : io.flutter.plugin.common.EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: io.flutter.plugin.common.EventChannel.EventSink?) {
                    progressEventSink = events
                }

                override fun onCancel(arguments: Any?) {
                    progressEventSink = null
                }
            }
        )

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
        val firstFile = File(filePath)
        if (!firstFile.exists()) {
            throw Exception("File not found: $filePath")
        }

        // Check for multi-part archive
        val parts = ArrayList<File>()
        parts.add(firstFile)
        
        if (filePath.endsWith(".001")) {
            var partIndex = 2
            var nextPart = File(filePath.replace(".001", ".%03d".format(partIndex)))
            while (nextPart.exists()) {
                parts.add(nextPart)
                partIndex++
                nextPart = File(filePath.replace(".001", ".%03d".format(partIndex)))
            }
        }

        // Helper to open channel
        fun openChannel(): java.nio.channels.SeekableByteChannel {
            return if (parts.size > 1) {
                 org.apache.commons.compress.utils.MultiReadOnlySeekableByteChannel(
                    parts.map { java.nio.channels.FileChannel.open(it.toPath(), java.nio.file.StandardOpenOption.READ) }
                )
            } else {
                 java.nio.channels.FileChannel.open(firstFile.toPath(), java.nio.file.StandardOpenOption.READ)
            }
        }

        // 1. Calculate total size
        var totalSize: Long = 0
        var channel = openChannel()
        var builder = SevenZFile.builder().setSeekableByteChannel(channel)
        if (password != null) builder.setPassword(password.toCharArray())
        var sevenZFile = builder.get()
        
        try {
            var entry = sevenZFile.nextEntry
            while (entry != null) {
                if (!entry.isDirectory) {
                    totalSize += entry.size
                }
                entry = sevenZFile.nextEntry
            }
        } finally {
            sevenZFile.close()
            channel.close()
        }

        // 2. Extract
        channel = openChannel()
        builder = SevenZFile.builder().setSeekableByteChannel(channel)
        if (password != null) builder.setPassword(password.toCharArray())
        sevenZFile = builder.get()

        var extractedSize: Long = 0
        var lastProgress = 0.0

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
                        extractedSize += len
                        
                        if (totalSize > 0) {
                            val progress = extractedSize.toDouble() / totalSize.toDouble()
                            if (progress - lastProgress >= 0.01) { // Emit every 1%
                                lastProgress = progress
                                runOnUiThread { progressEventSink?.success(progress) }
                            }
                        }
                    }
                    out.close()
                }
                entry = sevenZFile.nextEntry
            }
            runOnUiThread { progressEventSink?.success(1.0) }
        } finally {
            sevenZFile.close()
            channel.close()
        }
    }
}
