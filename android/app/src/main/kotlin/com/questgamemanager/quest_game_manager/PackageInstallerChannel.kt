package com.questgamemanager.quest_game_manager

import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageInstaller
import android.content.pm.PackageManager
import android.os.Build
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileInputStream

class PackageInstallerChannel(private val context: Context) : MethodChannel.MethodCallHandler {

    companion object {
        const val CHANNEL_NAME = "com.questgamemanager.quest_game_manager/installer"
        private const val ACTION_INSTALL_RESULT = "com.questgamemanager.INSTALL_RESULT"
    }

    private var pendingResult: MethodChannel.Result? = null

    private val installReceiver = object : BroadcastReceiver() {
        override fun onReceive(ctx: Context, intent: Intent) {
            val status = intent.getIntExtra(
                PackageInstaller.EXTRA_STATUS,
                PackageInstaller.STATUS_FAILURE
            )
            val message = intent.getStringExtra(PackageInstaller.EXTRA_STATUS_MESSAGE) ?: ""

            when (status) {
                PackageInstaller.STATUS_PENDING_USER_ACTION -> {
                    @Suppress("DEPRECATION")
                    val confirmIntent = intent.getParcelableExtra<Intent>(Intent.EXTRA_INTENT)
                    confirmIntent?.let {
                        it.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        ctx.startActivity(it)
                    }
                }
                PackageInstaller.STATUS_SUCCESS -> {
                    pendingResult?.success(mapOf("success" to true, "message" to "Installed successfully"))
                    pendingResult = null
                }
                else -> {
                    pendingResult?.success(mapOf("success" to false, "message" to "Install error $status: $message"))
                    pendingResult = null
                }
            }
        }
    }

    fun register() {
        val filter = IntentFilter(ACTION_INSTALL_RESULT)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.registerReceiver(installReceiver, filter, Context.RECEIVER_NOT_EXPORTED)
        } else {
            context.registerReceiver(installReceiver, filter)
        }
    }

    fun unregister() {
        try {
            context.unregisterReceiver(installReceiver)
        } catch (_: Exception) {
        }
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "installApk" -> {
                val apkPath = call.argument<String>("apkPath")
                    ?: return result.error("INVALID_ARG", "apkPath required", null)
                val apkFile = File(apkPath)
                if (!apkFile.exists()) {
                    return result.error("FILE_NOT_FOUND", "APK file not found: $apkPath", null)
                }
                pendingResult = result
                installApk(apkFile, result)
            }
            "canInstallPackages" -> {
                result.success(context.packageManager.canRequestPackageInstalls())
            }
            "getInstalledPackages" -> {
                val packages = getInstalledPackages()
                result.success(packages)
            }
            "isPackageInstalled" -> {
                val packageName = call.argument<String>("packageName")
                    ?: return result.error("INVALID_ARG", "packageName required", null)
                result.success(isPackageInstalled(packageName))
            }
            "getInstalledVersion" -> {
                val packageName = call.argument<String>("packageName")
                    ?: return result.error("INVALID_ARG", "packageName required", null)
                result.success(getInstalledVersion(packageName))
            }
            "uninstallPackage" -> {
                val packageName = call.argument<String>("packageName")
                    ?: return result.error("INVALID_ARG", "packageName required", null)
                uninstallPackage(packageName)
                result.success(true)
            }
            "launchPackage" -> {
                val packageName = call.argument<String>("packageName")
                    ?: return result.error("INVALID_ARG", "packageName required", null)
                val launched = launchPackage(packageName)
                result.success(launched)
            }
            else -> result.notImplemented()
        }
    }

    private fun installApk(apkFile: File, result: MethodChannel.Result) {
        try {
            val installer = context.packageManager.packageInstaller
            val params = PackageInstaller.SessionParams(
                PackageInstaller.SessionParams.MODE_FULL_INSTALL
            )
            params.setSize(apkFile.length())

            val sessionId = installer.createSession(params)
            val session = installer.openSession(sessionId)

            session.openWrite("app.apk", 0, apkFile.length()).use { out ->
                FileInputStream(apkFile).use { input ->
                    input.copyTo(out)
                }
                session.fsync(out)
            }

            val intent = Intent(ACTION_INSTALL_RESULT).setPackage(context.packageName)
            val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S)
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_MUTABLE
            else PendingIntent.FLAG_UPDATE_CURRENT

            val pi = PendingIntent.getBroadcast(context, sessionId, intent, flags)
            session.commit(pi.intentSender)
        } catch (e: Exception) {
            pendingResult = null
            result.error("INSTALL_ERROR", e.message, null)
        }
    }

    private fun getInstalledPackages(): List<Map<String, Any?>> {
        val flags = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            PackageManager.PackageInfoFlags.of(0)
        } else {
            @Suppress("DEPRECATION")
            null
        }

        val packages = if (flags != null && Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            context.packageManager.getInstalledPackages(PackageManager.PackageInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            context.packageManager.getInstalledPackages(0)
        }

        return packages.map { info ->
            mapOf(
                "packageName" to info.packageName,
                "versionName" to (info.versionName ?: ""),
                "versionCode" to if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)
                    info.longVersionCode
                else
                    @Suppress("DEPRECATION")
                    info.versionCode.toLong()
            )
        }
    }

    private fun isPackageInstalled(packageName: String): Boolean {
        return try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                context.packageManager.getPackageInfo(
                    packageName,
                    PackageManager.PackageInfoFlags.of(0)
                )
            } else {
                @Suppress("DEPRECATION")
                context.packageManager.getPackageInfo(packageName, 0)
            }
            true
        } catch (_: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun getInstalledVersion(packageName: String): Long {
        return try {
            val info = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                context.packageManager.getPackageInfo(
                    packageName,
                    PackageManager.PackageInfoFlags.of(0)
                )
            } else {
                @Suppress("DEPRECATION")
                context.packageManager.getPackageInfo(packageName, 0)
            }
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P)
                info.longVersionCode
            else
                @Suppress("DEPRECATION")
                info.versionCode.toLong()
        } catch (_: PackageManager.NameNotFoundException) {
            -1L
        }
    }

    private fun uninstallPackage(packageName: String) {
        val intent = Intent(Intent.ACTION_DELETE).apply {
            data = android.net.Uri.parse("package:$packageName")
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    }

    private fun launchPackage(packageName: String): Boolean {
        val intent = context.packageManager.getLaunchIntentForPackage(packageName)
        return if (intent != null) {
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            context.startActivity(intent)
            true
        } else {
            false
        }
    }
}
