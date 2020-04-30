import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Note {
  int id;
  int starred;
  String title;
  String text;
  DateTime dateTime;
  Category category;

  Note(this.title, this.text, this.category, {this.starred = 0}) {
    this.dateTime = DateTime.now();
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }
    map['starred'] = starred;
    map['title'] = title;
    map['text'] = text;
    map['category'] = category.name;
    map['date'] = dateTime.toIso8601String();
    return map;
  }
}

class Category {
  String name;
  Color color;
  Category(this.name, {this.color = Colors.black});
}
