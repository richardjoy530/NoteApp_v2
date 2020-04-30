import 'package:flutter/material.dart';
import 'package:noteappv2/main_page.dart';

class AddEditNote extends StatefulWidget {
  @override
  _AddEditNoteState createState() => _AddEditNoteState();
}

class _AddEditNoteState extends State<AddEditNote> {
  TextEditingController titleEditingController = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  Future<void> showCategories(context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: myTheme.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Select a Category',
            style:
                TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                categoryList.length,
                (index) {
                  return SimpleDialogOption(
                    child: ListTile(
                      leading: Icon(
                        Icons.label_outline,
                        color: categoryList[index].color,
                      ),
                      title: Text(categoryList[index].name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                    onPressed: () {
                      setState(() {
                        note.category.name = categoryList[index].name;
                        note.category.color = categoryList[index].color;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    titleEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    titleEditingController.text = note.title;
    textEditingController.text = note.text;
    return SafeArea(
      child: Scaffold(
        backgroundColor: myTheme.secondaryColor,
        body: Stack(
          children: <Widget>[
            ListView(
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
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: titleEditingController,
                    onSubmitted: (value) {
                      note.title = value;
                    },
                    onChanged: (value) {
                      note.title = value;
                    },
                    style: TextStyle(
                        fontFamily: "BalooTamma2",
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                        hintText: 'Add Title', border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    controller: textEditingController,
                    onSubmitted: (value) {
                      note.text = value;
                    },
                    onChanged: (value) {
                      note.text = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    style: TextStyle(fontSize: 20, color: Colors.blueGrey),
                    decoration: InputDecoration(
                        hintText: 'Add note', border: InputBorder.none),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                          note.starred == 0 ? Icons.star_border : Icons.star,
                          color: myTheme.mainAccentColor),
                      onPressed: () {
                        setState(() {
                          note.starred = note.starred == 0 ? 1 : 0;
                        });
                      },
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.label_outline, color: note.category.color),
                      onPressed: () {
                        showCategories(context);
                      },
                    ),
                    Icon(
                      Icons.share,
                      color: myTheme.mainAccentColor,
                    ),
                    Icon(
                      Icons.playlist_add_check,
                      color: myTheme.mainAccentColor,
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: myTheme.mainAccentColor),
                      onPressed: () {
                        databaseHelper.deleteNote(note.id);
                        note.title = '';
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
