package com.example.proyecto

import android.content.Context
import android.os.Bundle
import android.os.CountDownTimer
import android.os.Parcel
import android.os.Parcelable
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.appcompat.app.AppCompatActivity
import java.io.BufferedReader
import java.io.FileInputStream
import java.io.FileOutputStream
import java.io.IOException
import java.io.InputStreamReader

class Practice4Activity() : AppCompatActivity(), Parcelable {

    private lateinit var textTimeRemaining: TextView
    private lateinit var textCounter: TextView
    private lateinit var buttonStart: Button
    private lateinit var buttonPress: Button
    private lateinit var buttonShowScores: Button
    private lateinit var buttonClearScores: Button // Botón para eliminar scores
    private lateinit var textScores: TextView

    private var counter = 0
    private var timeLeftInMillis: Long = 10000 // 10 segundos

    private var countDownTimer: CountDownTimer? = null

    constructor(parcel: Parcel) : this() {
        counter = parcel.readInt()
        timeLeftInMillis = parcel.readLong()
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_practice4)

        textTimeRemaining = findViewById(R.id.text_time_remaining)
        textCounter = findViewById(R.id.text_counter)
        buttonStart = findViewById(R.id.button_start)
        buttonPress = findViewById(R.id.button_press)
        buttonShowScores = findViewById(R.id.button_show_scores)
        buttonClearScores = findViewById(R.id.button_clear_scores) // Inicializar el botón
        textScores = findViewById(R.id.text_scores)

        buttonPress.isEnabled = false // Deshabilitar el botón "Presionar" al inicio

        buttonStart.setOnClickListener {
            startTimer()
        }

        buttonPress.setOnClickListener {
            counter++
            textCounter.text = "Contador: $counter"
        }

        buttonShowScores.setOnClickListener {
            showScores()
        }

        buttonClearScores.setOnClickListener {
            clearScores()
        }
    }

    private fun startTimer() {
        buttonStart.isEnabled = false
        buttonPress.isEnabled = true
        counter = 0
        textCounter.text = "Contador: 0"
        timeLeftInMillis = 10000 // 10 segundos

        countDownTimer = object : CountDownTimer(timeLeftInMillis, 1000) {
            override fun onTick(millisUntilFinished: Long) {
                timeLeftInMillis = millisUntilFinished
                updateCountDownText()
            }

            override fun onFinish() {
                buttonPress.isEnabled = false
                buttonStart.isEnabled = true
                textTimeRemaining.text = "¡Tiempo terminado!"
                saveScore(counter) // Guardar el score al finalizar el tiempo
            }
        }.start()
    }

    private fun updateCountDownText() {
        val seconds = (timeLeftInMillis / 1000).toInt()
        textTimeRemaining.text = "Tiempo restante: $seconds segundos"
    }

    private fun saveScore(score: Int) {
        val filename = "scores.txt"
        val fileContents = "$score\n" // Cada score en una nueva línea

        try {
            val fileOutputStream: FileOutputStream = openFileOutput(filename, Context.MODE_APPEND)
            fileOutputStream.write(fileContents.toByteArray())
            fileOutputStream.close()
            Toast.makeText(this, "Score guardado", Toast.LENGTH_SHORT).show()
        } catch (e: IOException) {
            e.printStackTrace()
            Toast.makeText(this, "Error al guardar el score", Toast.LENGTH_SHORT).show()
        }
    }

    private fun showScores() {
        val filename = "scores.txt"
        val stringBuilder = StringBuilder()

        try {
            val fileInputStream: FileInputStream = openFileInput(filename)
            val inputStreamReader = InputStreamReader(fileInputStream)
            val bufferedReader = BufferedReader(inputStreamReader)
            var line: String? = bufferedReader.readLine()

            while (line != null) {
                stringBuilder.append(line).append("\n")
                line = bufferedReader.readLine()
            }

            fileInputStream.close()
            textScores.text = stringBuilder.toString()
        } catch (e: IOException) {
            e.printStackTrace()
            textScores.text = "No hay scores guardados."
        }
    }

    private fun clearScores() {
        val filename = "scores.txt"
        try {
            val fileOutputStream: FileOutputStream = openFileOutput(filename, Context.MODE_PRIVATE)
            fileOutputStream.write("".toByteArray()) // Escribir una cadena vacía para limpiar el archivo
            fileOutputStream.close()
            Toast.makeText(this, "Scores eliminados", Toast.LENGTH_SHORT).show()
            textScores.text = "" // Limpiar el TextView de scores
        } catch (e: IOException) {
            e.printStackTrace()
            Toast.makeText(this, "Error al eliminar los scores", Toast.LENGTH_SHORT).show()
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        countDownTimer?.cancel() // Cancelar el timer si la actividad se destruye
    }

    override fun writeToParcel(parcel: Parcel, flags: Int) {
        parcel.writeInt(counter)
        parcel.writeLong(timeLeftInMillis)
    }

    override fun describeContents(): Int {
        return 0
    }

    companion object CREATOR : Parcelable.Creator<Practice4Activity> {
        override fun createFromParcel(parcel: Parcel): Practice4Activity {
            return Practice4Activity(parcel)
        }

        override fun newArray(size: Int): Array<Practice4Activity?> {
            return arrayOfNulls(size)
        }
    }
}