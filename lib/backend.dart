import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'data.dart';

class PinData {
  static SharedPreferences _prefs;
  static PinData _pinData;
  static int pinEnable;
  static String pin;

  PinData._createInstance();

  factory PinData() {
    if (_pinData == null) {
      _pinData = PinData._createInstance();
    }
    return _pinData;
  }
  Future<SharedPreferences> get prefs async {
    if (_prefs == null) {
      _prefs = await initialise();
    }
    return _prefs;
  }

  Future<SharedPreferences> initialise() async {
    return _prefs = await SharedPreferences.getInstance();
  }

  Future<int> getPinEnable() async {
    pinEnable = (_prefs.getInt('pinEnable') ?? 0);
    return pinEnable;
  }

  Future<String> getPin() async {
    pin = (_prefs.getString('pin') ?? '');
    return pin;
  }

  void setPinEnable(int value) async {
    _prefs.setInt('pinEnable', value);
  }

  void setPin(String value) async {
    _prefs.setString('pin', value);
  }
}

class DatabaseHelper {
  static DatabaseHelper _databaseHelper; // Singleton DatabaseHelper
  static Database _database; // Singleton Database

  String noteTable = 'note_table';
  String colId = 'id';
  String colStarred = 'starred';
  String colTitle = 'title';
  String colText = 'text';
  String dateTime = 'date';
  String colCategory = 'category';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper
          ._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notesv2.db';

    // Open/create the database at a given path
    var notesDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $noteTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colStarred INTEGER, $colCategory TEXT , $colTitle TEXT, $colText TEXT, $dateTime TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable, orderBy: '$colId ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(noteTable, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    var db = await this.database;
    var result = await db.update(noteTable, note.toMap(),
        where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    var db = await this.database;
    int result =
        await db.rawDelete('DELETE FROM $noteTable WHERE $colId = $id');
    return result;
  }

  Future<int> deleteAllNote() async {
    var db = await this.database;
    return await db.rawDelete('DELETE FROM $noteTable');
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT (*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList(); // Get 'Map List' from database
    int count =
        noteMapList.length; // Count the number of map entries in db table
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Note> noteList = List<Note>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      Note temp = Note('', '', Category('Not Specified'));
      temp.id = noteMapList[i]['id'];
      temp.starred = noteMapList[i]['starred'];
      temp.title = noteMapList[i]['title'];
      temp.text = noteMapList[i]['text'];
      temp.dateTime = DateTime.parse(noteMapList[i]['date']);
      temp.category.name = noteMapList[i]['category'];
      temp.category.color = getCategoryColor(temp.category.name, prefs);
      noteList.add(temp);
    }

    return noteList;
  }

  Color getCategoryColor(String name, SharedPreferences prefs) {
    var colorName;
    colorName = (prefs.getString(name) ?? 'black');
    switch (colorName) {
      case 'red':
        return Color(0xffe26e43);
      case 'blue':
        return Color(0xff292e91);
      case 'yellow':
        return Color(0xffa1ffb3);
      case 'green':
        return Color(0xffa82654);
      case 'lightgreen':
        return Color(0xfff9bfda);
    }
    return Colors.black;
  }
}
