import 'package:flutter/material.dart';

import 'main_page.dart';

class AddEditCategory extends StatefulWidget {
  @override
  _AddEditCategoryState createState() => _AddEditCategoryState();
}

class _AddEditCategoryState extends State<AddEditCategory> {
  Color dividerColor;
  TextEditingController categoryTextController = TextEditingController();
  TextEditingController categoryDescriptionController = TextEditingController();

  @override
  void dispose() {
    categoryTextController.dispose();
    categoryDescriptionController.dispose();
    super.dispose();
  }

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
                  Icons.check,
                  color: myTheme.mainAccentColor,
                ),
                onPressed: () {
                  if (categoryTextController.text != '') {
                    newCategory.name = categoryTextController.text;
                    newCategory.color = dividerColor;
                    Navigator.pop(context);
                  }
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
                controller: categoryTextController,
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
              color: dividerColor,
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
                      onPressed: () {
                        setState(() {
                          dividerColor = Color(0xffe26e43);
                        });
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xff292e91),
                      ),
                      onPressed: () {
                        setState(() {
                          dividerColor = Color(0xff292e91);
                        });
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xffa1ffb3),
                      ),
                      onPressed: () {
                        setState(() {
                          dividerColor = Color(0xffa1ffb3);
                        });
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xffa82654),
                      ),
                      onPressed: () {
                        setState(() {
                          dividerColor = Color(0xffa82654);
                        });
                      }),
                  IconButton(
                      icon: Icon(
                        Icons.lens,
                        color: Color(0xfff9bfda),
                      ),
                      onPressed: () {
                        setState(() {
                          dividerColor = Color(0xfff9bfda);
                        });
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
