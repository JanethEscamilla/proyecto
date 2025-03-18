package com.example.proyecto

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class Practice2Activity : AppCompatActivity() {
    private var counter = 0
    private lateinit var tvCounter: TextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_practice2)

        tvCounter = findViewById(R.id.tvCounter)
        findViewById<Button>(R.id.btnClick).setOnClickListener {
            counter++
            tvCounter.text = "Clicks: $counter"
        }
    }
}