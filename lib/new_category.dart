import 'package:flutter/material.dart';

import 'main_page.dart';

class AddEditCategory extends StatefulWidget {
  @override
  _AddEditCategoryState createState() => _AddEditCategoryState();
}

class _AddEditCategoryState extends State<AddEditCategory> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: myTheme.secondaryColor,
        body: ListView(
          children: <Widget>[
            ListTile(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: myTheme.mainAccentColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: myTheme.mainAccentColor,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                style: TextStyle(
                    fontFamily: "BalooTamma2",
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                    hintText: 'Add Category', border: InputBorder.none),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
              child: TextField(
                style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                decoration: InputDecoration(
                    hintText: 'Category Description', border: InputBorder.none),
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xffe26e43),
                      ),
                      onPressed: null),
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xff292e91),
                      ),
                      onPressed: null),
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xffa1ffb3),
                      ),
                      onPressed: null),
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xffa82654),
                      ),
                      onPressed: null),
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xfff9bfda),
                      ),
                      onPressed: null),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
