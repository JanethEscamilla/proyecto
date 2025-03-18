package com.example.proyecto

import android.content.Intent
import android.os.Bundle
import android.widget.Button
import androidx.appcompat.app.AppCompatActivity

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        findViewById<Button>(R.id.btnPractice1).setOnClickListener { startActivity(Intent(this, Practice1Activity::class.java)) }
        findViewById<Button>(R.id.btnPractice2).setOnClickListener { startActivity(Intent(this, Practice2Activity::class.java)) }
        findViewById<Button>(R.id.btnPractice3).setOnClickListener { startActivity(Intent(this, Practice3Activity::class.java)) }
        findViewById<Button>(R.id.btnPractice4).setOnClickListener { startActivity(Intent(this, Practice4Activity::class.java)) }
        findViewById<Button>(R.id.btnPractice5).setOnClickListener { startActivity(Intent(this, Practice5Activity::class.java)) }
        findViewById<Button>(R.id.btnPractice6).setOnClickListener { startActivity(Intent(this, Practice6Activity::class.java)) }
    }
}