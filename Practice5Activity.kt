package com.example.proyecto

import android.content.ContentValues
import android.database.Cursor
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import androidx.appcompat.app.AppCompatActivity

class Practice5Activity : AppCompatActivity() {
    private lateinit var dbHelper: DatabaseHelper
    private lateinit var etName: EditText
    private lateinit var etAge: EditText
    private lateinit var tvData: TextView
    private lateinit var etIdToDelete: EditText

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_practice5)

        dbHelper = DatabaseHelper(this)
        etName = findViewById(R.id.etName)
        etAge = findViewById(R.id.etAge)
        tvData = findViewById(R.id.tvData)
        etIdToDelete = findViewById(R.id.etIdToDelete)

        findViewById<Button>(R.id.btnSave).setOnClickListener {
            saveData()
            showData()
        }

        findViewById<Button>(R.id.btnDelete).setOnClickListener {
            deleteData()
            showData()
        }

        showData()
    }

    private fun saveData() {
        val db = dbHelper.writableDatabase
        val values = ContentValues().apply {
            put(DatabaseHelper.COLUMN_NAME, etName.text.toString())
            put(DatabaseHelper.COLUMN_AGE, etAge.text.toString().toInt())
        }
        db.insert(DatabaseHelper.TABLE_USERS, null, values)
        db.close()
        etName.text.clear()
        etAge.text.clear()
    }

    private fun deleteData() {
        val db = dbHelper.writableDatabase
        val idToDelete = etIdToDelete.text.toString().toIntOrNull()
        if (idToDelete != null) {
            db.delete(DatabaseHelper.TABLE_USERS, "${DatabaseHelper.COLUMN_ID} = ?", arrayOf(idToDelete.toString()))
            etIdToDelete.text.clear()
        }
        db.close()
    }

    private fun showData() {
        val db = dbHelper.readableDatabase
        val cursor: Cursor = db.query(
            DatabaseHelper.TABLE_USERS,
            null,
            null,
            null,
            null,
            null,
            null
        )
        val data = StringBuilder()
        with(cursor) {
            while (moveToNext()) {
                val id = getInt(getColumnIndexOrThrow(DatabaseHelper.COLUMN_ID))
                val name = getString(getColumnIndexOrThrow(DatabaseHelper.COLUMN_NAME))
                val age = getInt(getColumnIndexOrThrow(DatabaseHelper.COLUMN_AGE))
                data.append("ID: $id, Name: $name, Age: $age\n")
            }
        }
        cursor.close()
        db.close()
        tvData.text = data.toString()
    }
}