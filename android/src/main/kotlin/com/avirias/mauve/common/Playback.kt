package com.avirias.mauve.common

import android.content.ComponentName
import android.content.Context
import android.net.Uri
import android.util.Log
import com.avirias.mauve.media.MusicService
import com.avirias.mauve.media.extensions.isPlayEnabled
import com.avirias.mauve.media.extensions.isPlaying
import com.avirias.mauve.media.extensions.isPrepared
import java.io.File

class Playback(context: Context) {

    private val TAG: String = "Playback"

    companion object {
        @Volatile
        var instance: Playback? = null

        fun getInstance(context: Context) = instance ?: synchronized(this) {
            instance ?: Playback(context).also { instance = it }
        }

    }

    init {
        Log.d(TAG, "Playback Initialized")
    }

    private var service: MusicServiceConnection = MusicServiceConnection.getInstance(context, ComponentName(context, MusicService::class.java))

    fun play(url: String): Boolean {
//        val nowPlaying = service.nowPlaying.value
        val transportControls = service.transportControls

        val isPrepared = service.playbackState.value?.isPrepared ?: false
        return if (isPrepared) {
            service.playbackState.value?.let { playbackStateCompat ->
                when {
                    playbackStateCompat.isPlaying -> transportControls.pause()
                    playbackStateCompat.isPlayEnabled -> transportControls.play()
                    else -> print("Can't play")
                }
            }
            true
        } else {
            val uri: Uri = Uri.fromFile(File(url))
            transportControls.playFromUri(uri, null)
            true
        }

    }

    fun pause() {
        val controls = service.transportControls

        service.playbackState.value?.let {
            when {
                it.isPlaying -> {
                    controls.pause()
                }
                else -> {
                    print("Already paused")

                }
            }
        }
    }

    fun seek(seconds: Double) {
        val controls = service.transportControls
        service.playbackState.value?.let {
            when {
                it.isPlaying -> {
                    controls.seekTo(seconds.toLong())
                }
                else -> {
                    print("Can't seek")
                }
            }
        }
    }

    fun mute(): Boolean {
        TODO("Will implement")
    }

    fun stop(): Boolean {
        val controls = service.transportControls
        controls.stop()
        return true
    }

    fun resume(): Boolean {
        TODO()
    }

}