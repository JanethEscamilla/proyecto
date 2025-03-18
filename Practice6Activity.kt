package com.example.proyecto

import android.content.ContentValues
import android.database.Cursor
import android.os.Bundle
import android.os.Handler
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AlertDialog
import androidx.appcompat.app.AppCompatActivity

class Practice6Activity : AppCompatActivity() {
    private var counter = 0
    private lateinit var tvCounter: TextView
    private lateinit var btnClick: Button
    private val handler = Handler()
    private lateinit var tvHistory: TextView
    private lateinit var tvTimer: TextView
    private var timeLeft = 10
    private var timerStarted = false
    private lateinit var dbHelper: DatabaseHelper
    private lateinit var etPlayerName: EditText
    private lateinit var btnClearScores: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_practice6)

        dbHelper = DatabaseHelper(this)
        tvCounter = findViewById(R.id.tvCounter)
        btnClick = findViewById(R.id.btnClick)
        tvHistory = findViewById(R.id.tvHistory)
        tvTimer = findViewById(R.id.tvTimer)
        etPlayerName = findViewById(R.id.etPlayerName)
        btnClearScores = findViewById(R.id.btnClearScores)

        btnClick.setOnClickListener {
            counter++
            tvCounter.text = "Clicks: $counter"
            if (!timerStarted) {
                timerStarted = true
                startTimer()
            }
        }

        btnClearScores.setOnClickListener {
            clearScores()
        }

        showHistory()
    }

    private fun startTimer() {
        handler.postDelayed(object : Runnable {
            override fun run() {
                timeLeft--
                updateTimerText()
                if (timeLeft > 0) {
                    handler.postDelayed(this, 1000)
                } else {
                    val playerName = etPlayerName.text.toString()
                    saveScoreToDatabase(counter, playerName)
                    showHistory()
                    AlertDialog.Builder(this@Practice6Activity)
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
        tvTimer.text = "Tiempo: $timeLeft"
    }

    private fun saveScoreToDatabase(score: Int, playerName: String) {
        val db = dbHelper.writableDatabase
        val values = ContentValues().apply {
            put(DatabaseHelper.COLUMN_SCORE, score)
            put(DatabaseHelper.COLUMN_PLAYER_NAME, playerName)
        }
        db.insert(DatabaseHelper.TABLE_SCORES, null, values)
        db.close()
    }

    private fun showHistory() {
        val db = dbHelper.readableDatabase
        val cursor: Cursor = db.query(DatabaseHelper.TABLE_SCORES, null, null, null, null, null, null)
        val data = StringBuilder()
        with(cursor) {
            while (moveToNext()) {
                val score = getInt(getColumnIndexOrThrow(DatabaseHelper.COLUMN_SCORE))
                val playerName = getString(getColumnIndexOrThrow(DatabaseHelper.COLUMN_PLAYER_NAME))
                data.append("Jugador: $playerName, Score: $score\n")
            }
        }
        cursor.close()
        db.close()
        tvHistory.text = data.toString()
    }

    private fun clearScores() {
        val db = dbHelper.writableDatabase
        db.delete(DatabaseHelper.TABLE_SCORES, null, null)
        db.close()
        tvHistory.text = ""
        showHistory()
    }
}