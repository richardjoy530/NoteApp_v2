import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Note {
  int id;
  int starred;
  String title;
  String text;
  Category category;

  Note(this.title, this.text, this.category, {this.starred = 0});

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

    return map;
  }
}

class Category {
  String name;
  Color color;
  Category(this.name, {this.color = Colors.blueAccent});
}
