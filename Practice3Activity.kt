package com.example.proyecto

import android.os.Bundle
import android.os.Handler
import android.widget.Button
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity

class Practice3Activity : AppCompatActivity() {
    private var counter = 0
    private lateinit var tvCounter: TextView
    private lateinit var btnClick: Button
    private val handler = Handler()
    private lateinit var tvTimer: TextView
    private var timeLeft = 10
    private var timerStarted = false

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_practice3)

        tvCounter = findViewById(R.id.tvCounter)
        btnClick = findViewById(R.id.btnClick)
        tvTimer = findViewById(R.id.tvTimer)

        btnClick.setOnClickListener {
            counter++
            tvCounter.text = "Clicks: $counter"
            if (!timerStarted) {
                timerStarted = true
                startTimer()
            }
        }
    }

    private fun startTimer() {
        handler.postDelayed(object : Runnable {
            override fun run() {
                timeLeft--
                updateTimerText()
                if (timeLeft > 0) {
                    handler.postDelayed(this, 1000)
                } else {
                    AlertDialog.Builder(this@Practice3Activity)
                        .setTitle("Total Clicks")
                        .setMessage("Total Clicks: $counter")
                        .setPositiveButton("OK", null)
                        .show()
                    counter = 0
                    tvCounter.text = "Clicks: 0"
                    timeLeft = 10
                    updateTimerText()
                    timerStarted = false
                }
            }
        }, 1000)
    }

    private fun updateTimerText() {
        tvTimer.text = "Timer: $timeLeft"
    }
}