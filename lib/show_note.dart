import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'add_edit_note.dart';
import 'main_page.dart';

class ShowNotes extends StatefulWidget {
  @override
  _ShowNotesState createState() => _ShowNotesState();
}

class _ShowNotesState extends State<ShowNotes> {
  ScrollController scrollController = ScrollController();
  void updateList() {
    databaseHelper.getNoteList().then((onValue) {
      setState(() {
        notes = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
              //height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        'Your Notes',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
//                  Padding(
//                    padding: const EdgeInsets.only(left: 25),
//                    child: Align(
//                        alignment: Alignment.topLeft,
//                        child: Text('28 May',
//                            style: TextStyle(
//                                fontSize: 30, color: myTheme.mainAccentColor))),
//                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      controller: scrollController,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onLongPress: () {
                            showDialog(
                              barrierDismissible: true,
                              context: context,
                              builder: (_) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                title: Text('Delete Note?'),
                                actions: <Widget>[
                                  FlatButton(
                                      onPressed: () {
                                        databaseHelper.deleteNote(note.id);
                                        updateList();
                                        Navigator.pop(context);
                                      },
                                      child: Text('Yes')),
                                  FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'))
                                ],
                              ),
                            );
                          },
                          leading: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: myTheme.mainAccentColor,
                              ),
                              //color: myTheme.mainAccentColor,
                              child: Text((index + 1).toString(),
                                  style: TextStyle(
                                      fontSize: 25,
                                      color: myTheme.secondaryColor))),
                          onTap: () {
                            note = notes[index];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddEditNote()),
                            ).then((onValue) {
                              print(onValue);
                              if (note.title != '' && note.text != '') {
                                databaseHelper.updateNote(note);
                              }
                              updateList();
                            });
                          },
                          title: Text(
                            notes[index].title,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            notes[index].text,
                            style:
                                TextStyle(color: Colors.blueGrey, fontSize: 20),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '${notes[index].dateTime.hour > 12 ? notes[index].dateTime.hour - 12 : notes[index].dateTime.hour}:${notes[index].dateTime.minute} ${notes[index].dateTime.hour > 12 ? 'PM' : 'AM'}',
                                style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.bold),
                              ),
//                              Icon(
//                                Icons.label_outline,
//                                color: notes[index].category.color,
//                              )
                            ],
                          ),
                        );
                      },
                      itemCount: notes.length,
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider();
                      },
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
