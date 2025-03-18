package com.example.proyecto

import android.content.Context
import android.database.sqlite.SQLiteDatabase
import android.database.sqlite.SQLiteOpenHelper

class DatabaseHelper(context: Context) : SQLiteOpenHelper(context, DATABASE_NAME, null, DATABASE_VERSION) {

    companion object {
        private const val DATABASE_NAME = "users.db"
        private const val DATABASE_VERSION = 2 // Incrementa la versión a 2
        const val TABLE_USERS = "users"
        const val COLUMN_ID = "_id"
        const val COLUMN_NAME = "name"
        const val COLUMN_AGE = "age"

        const val TABLE_SCORES = "scores"
        const val SCORE_ID = "_id"
        const val COLUMN_SCORE = "score"
        const val COLUMN_PLAYER_NAME = "player_name" // Agrega esta línea
    }

    override fun onCreate(db: SQLiteDatabase) {
        val createUsersTableQuery = "CREATE TABLE $TABLE_USERS (" +
                "$COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT," +
                "$COLUMN_NAME TEXT," +
                "$COLUMN_AGE INTEGER)"
        db.execSQL(createUsersTableQuery)

        val createScoresTableQuery = "CREATE TABLE $TABLE_SCORES (" +
                "$SCORE_ID INTEGER PRIMARY KEY AUTOINCREMENT," +
                "$COLUMN_SCORE INTEGER," +
                "$COLUMN_PLAYER_NAME TEXT)" // Modifica esta línea
        db.execSQL(createScoresTableQuery)
    }

    override fun onUpgrade(db: SQLiteDatabase, oldVersion: Int, newVersion: Int) {
        if (oldVersion < 2) {
            db.execSQL("ALTER TABLE $TABLE_SCORES ADD COLUMN $COLUMN_PLAYER_NAME TEXT");
        } else {
            db.execSQL("DROP TABLE IF EXISTS $TABLE_USERS")
            db.execSQL("DROP TABLE IF EXISTS $TABLE_SCORES")
            onCreate(db)
        }
    }
}