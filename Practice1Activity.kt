package com.example.proyecto

import android.os.Bundle
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class Practice1Activity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_practice1)
        findViewById<TextView>(R.id.tvMessage).text = "Hola Mundo"
    }
}