import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:noteappv2/add_edit_note.dart';
import 'package:noteappv2/backend.dart';
import 'package:noteappv2/new_category.dart';

import 'data.dart';

DatabaseHelper databaseHelper;
PinData pinData = PinData();
List<Note> notes = [];
List<Category> categoryList = [Category('Not Specified')];
List<String> categoryNameList = [];
List<Note> starredNotes = [];
Note note = Note('', '', Category('Not Specified'));

class MyTheme {
  Color mainAccentColor = Color(0xff3f79fe);
  Color secondaryColor = Color(0xffeff3f8);
}

MyTheme myTheme = MyTheme();

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
//  static List<String> categoryNameList = [
//    'Starred',
//    'Notes',
//    'Important',
//    'Starred',
//    'Notes',
//    'Important',
//    'Starred'
// ];
  List<String> mainTileNameList = [
        'Notes',
        'Important',
      ] +
      categoryNameList;

  List<Tab> myTabs = <Tab>[
    Tab(
      text: 'Notes',
    ),
    Tab(
      text: 'Important',
    ),
    Tab(
      text: 'Team',
    ),
  ];

  @override
  void initState() {
    databaseHelper = DatabaseHelper();
    databaseHelper.getNoteList().then((onValue) {
      setState(() {
        notes = onValue;
      });
    });
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onMenuPressed(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      backgroundColor: myTheme.secondaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      builder: (context) {
        return Menu();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
              child: ListTile(
                trailing: Container(
                  child: GFAvatar(
                      size: GFSize.SMALL,
                      backgroundImage: AssetImage('images/avatar.png'),
                      shape: GFAvatarShape.standard),
                ),
                title: Text(
                  "Bruce Wayne",
                  style: TextStyle(
                      fontFamily: "BalooTamma2",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _onMenuPressed(context);
                    }),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxHeight: height / 4),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return MainTile(
                    index: index,
                    mainTileText: mainTileNameList[index],
                  );
                },
                itemCount: mainTileNameList.length,
              ),
            ),
            TabBar(
              labelStyle: TextStyle(fontSize: 17),
              labelColor: Colors.black,
              indicatorColor: myTheme.mainAccentColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 2,
              unselectedLabelStyle: TextStyle(fontSize: 17),
              unselectedLabelColor: Colors.blueGrey,
              tabs: myTabs,
              controller: _tabController,
            ),
            Flexible(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Card(
                              color: myTheme.secondaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: ListTile(
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
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  notes[index].text,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      '8:45',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Icon(
                                      Icons.label_outline,
                                      color: notes[index].category.color,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: notes.length,
                      ),
                    ),
                  ),
                  Tab(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                              child: Card(
                                color: myTheme.secondaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: ListTile(
                                    onTap: null,
                                    title: Text(
                                      mainTileNameList[index],
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'This is my debut shot at dribbble and I\'m really glad I got here. This shot is dedicated to notes for your phone in bright blue tones.'
                                      'What do you think about it?',
                                      style: TextStyle(
                                        color: Colors.blueGrey,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: mainTileNameList.length,
                      ),
                    ),
                  ),
                  Tab(
                    child: ListTile(
                      title: Text('Buy Tickets'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(15, 8.0, 15, 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FloatingActionButton.extended(
                backgroundColor: myTheme.mainAccentColor,
                heroTag: 'AddEditCategory',
                label: Text('Category'),
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEditCategory()),
                  );
                },
              ),
              FloatingActionButton.extended(
                heroTag: 'AddEditNote',
                backgroundColor: myTheme.mainAccentColor,
                label: Text('Note'),
                icon: Icon(Icons.add),
                onPressed: () {
                  note = Note('', '', Category('Not Specified'));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddEditNote()),
                  ).then((onValue) {
                    if (note.title != '' && note.text != '') {
                      databaseHelper.insertNote(note);
                    }
                    updateList();
                  });
                },
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  void updateList() {
    databaseHelper.getNoteList().then((onValue) {
      setState(() {
        notes = onValue;
      });
    });
  }
}

class MainTile extends StatelessWidget {
  final int index;
  final String mainTileText;

  const MainTile({Key key, this.index, this.mainTileText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widthOfTile = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: index == 0 ? myTheme.mainAccentColor : myTheme.secondaryColor,
          borderRadius: BorderRadius.all(Radius.circular(15))),
      width: widthOfTile / 2.9,
      child: ClayContainer(
        color: index == 0 ? myTheme.mainAccentColor : myTheme.secondaryColor,
        depth: 10,
        spread: 10,
        borderRadius: 10,
        curveType: CurveType.concave,
        child: ListTile(
          onTap: null,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  mainTileText,
                  style: TextStyle(
                      color: index == 0 ? Colors.white : Colors.blueGrey,
                      fontSize: 25),
                ),
              ),
              SizedBox(),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  notes.length.toString(),
                  style: TextStyle(
                      color: index == 0 ? Colors.white : Colors.blueGrey,
                      fontSize: 25),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Future<void> showAccentColors(context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: myTheme.secondaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(
            'Select an Accent Color',
            style:
                TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Color(0xffe26e43),
                    ),
                    onPressed: () {
                      setState(() {
                        myTheme.mainAccentColor = Color(0xffe26e43);
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Color(0xff292e91),
                    ),
                    onPressed: () {
                      setState(() {
                        myTheme.mainAccentColor = Color(0xff292e91);
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Color(0xffa1ffb3),
                    ),
                    onPressed: () {
                      setState(() {
                        myTheme.mainAccentColor = Color(0xffa1ffb3);
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Color(0xffa82654),
                    ),
                    onPressed: () {
                      setState(() {
                        myTheme.mainAccentColor = Color(0xffa82654);
                      });
                    }),
                IconButton(
                    icon: Icon(
                      Icons.lens,
                      color: Color(0xfff9bfda),
                    ),
                    onPressed: () {
                      setState(() {
                        myTheme.mainAccentColor = Color(0xfff9bfda);
                      });
                    }),
              ],
            ),
          ],
        );
      },
    );
  }

  Future<void> showThemes(context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: myTheme.mainAccentColor,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          title: Text(
            'Select Theme',
            style: TextStyle(
                color: myTheme.secondaryColor, fontWeight: FontWeight.bold),
          ),
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(color: Colors.white, blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  //color: Colors.grey[700],
                  child: ListTile(
                    leading: Icon(
                      Icons.brightness_5,
                      color: Colors.black,
                    ),
                    title: Text(
                      'Light Mode',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(15, 8, 15, 8),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      boxShadow: [
                        BoxShadow(color: Colors.black, blurRadius: 5)
                      ],
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  //color: Colors.grey[700],
                  child: ListTile(
                    leading: Icon(
                      Icons.brightness_5,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Dark Mode',
                      style: TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.fromLTRB(200.0, 10, 200, 10),
            child: Divider(thickness: 2, color: myTheme.mainAccentColor)),
        ListTile(
            leading: Container(
              child: GFAvatar(
                  size: GFSize.SMALL,
                  backgroundImage: AssetImage('images/avatar.png'),
                  shape: GFAvatarShape.standard),
            ),
            title: Text('Hello,',
                style: TextStyle(color: myTheme.mainAccentColor)),
            subtitle: Text('Humans',
                style: TextStyle(color: myTheme.mainAccentColor))),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: myTheme.mainAccentColor,
          ),
          title: Text('Settings'),
        ),
        ListTile(
          leading: Icon(
            Icons.color_lens,
            color: myTheme.mainAccentColor,
          ),
          title: Text(
            'Switch Theme',
          ),
          onTap: () {
            showThemes(context);
          },
        ),
        ListTile(
          leading: Icon(
            Icons.colorize,
            color: myTheme.mainAccentColor,
          ),
          title: Text(
            'Change Accent Color',
          ),
          onTap: () {
            showAccentColors(context);
          },
        ),
//        ListTile(
//            leading: Icon(
//              Icons.g_translate,
//              color: myTheme.mainAccentColor,
//            ),
//            title: Text(
//              'Help Translate',
//            )),
        ListTile(
            leading: Icon(
              Icons.supervisor_account,
              color: myTheme.mainAccentColor,
            ),
            title: Text(
              'Support Us',
            )),
        ListTile(
            leading: Icon(
              Icons.rate_review,
              color: myTheme.mainAccentColor,
            ),
            title: Text(
              'Rate and Review',
            )),
        ListTile(
            leading: Icon(
              Icons.info_outline,
              color: myTheme.mainAccentColor,
            ),
            title: Text(
              'About',
            )),
      ],
    );
  }
}
