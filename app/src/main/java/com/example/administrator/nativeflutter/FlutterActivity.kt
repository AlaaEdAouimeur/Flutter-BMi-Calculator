package com.example.administrator.nativeflutter

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.view.Window
import android.widget.FrameLayout
import io.flutter.facade.Flutter

class FlutterActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        requestWindowFeature(Window.FEATURE_NO_TITLE)

        val flutterView = Flutter.createView(
            this@FlutterActivity,
            lifecycle,
            "welcome"
        )
        val layout = FrameLayout.LayoutParams(
            FrameLayout.LayoutParams.MATCH_PARENT,
            FrameLayout.LayoutParams.MATCH_PARENT
        )
        addContentView(flutterView, layout)
    }
}
