import 'package:clay_containers/clay_containers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:noteappv2/add_edit_note.dart';
import 'package:noteappv2/backend.dart';
import 'package:noteappv2/new_category.dart';
import 'package:noteappv2/show_note.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cache_image/cache_image.dart';

import 'data.dart';

DatabaseHelper databaseHelper;
PinData pinData = PinData();
List<Note> notes = [];
List<Category> categoryList = [Category('Not Specified')];
List<String> categoryNameList = [];
List<Note> starredNotes = [];
Note note = Note('', '', Category('Not Specified'));
Category newCategory = Category('Not Specified');
String userName;
var downloadsDirectory;
var fileName;
var propic=null,Propic=null;
GoogleSignInAccount googleUser;

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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;



  Future<FirebaseUser> _handleSignIn() async
  {
    googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    setUserName(googleUser.displayName);
    updateUserName();
    var imageId = await ImageDownloader.downloadImage(googleUser.photoUrl);
    profilepic();
    getpropic();
    fileName = await ImageDownloader.findName(imageId);
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);

    return user;
  }

  PageController pageController;
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
        'All Notes',
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
    updateCategoryList();
    updateUserName();
    databaseHelper = DatabaseHelper();
    databaseHelper.getNoteList().then((onValue) {
      setState(() {
        notes = onValue;
      });
    });

    super.initState();
    pageController = PageController(initialPage: 1);
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mainTileNameList = [
          'All Notes',
          'Important',
        ] +
        categoryNameList;
    var height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: PageView(controller: pageController, children: <Widget>[
        menuPage(),
        dashBoard(context, height),
        teamPage()
      ]),
    );
  }

  Scaffold menuPage() {
    return Scaffold(
      body: menu(context),
    );
  }

  Scaffold teamPage() {
    return Scaffold(
      body: AppBar(),
    );
  }

  Scaffold dashBoard(BuildContext context, double height) {
    print('master');
    print('test master');
    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      pageController.animateToPage(0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                      //_onMenuPressed(context);
                    }),
                Text(
                  userName!=null?userName:'',
                  style: TextStyle(
                      fontFamily: "BalooTamma2",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                Expanded(child: SizedBox()),
                Container(
                  child: GFAvatar(
                      size: GFSize.SMALL,
                      backgroundImage: Propic==null
                          ?AssetImage('images/avatar.png')
                          :CacheImage(Propic),
                      shape: GFAvatarShape.standard),
                ),
                IconButton(
                    icon: Icon(Icons.arrow_forward_ios),
                    onPressed: () {
                      pageController.animateToPage(2,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    })
              ],
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
              physics: BouncingScrollPhysics(),
              controller: _tabController,
              children: <Widget>[
                Tab(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: myTheme.secondaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: ListTile(
                              onLongPress: () {
                                showDialog(
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    title: Text('Delete Note?'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            databaseHelper
                                                .deleteNote(notes[index].id);
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
                                    '${notes[index].dateTime.hour > 12 ? notes[index].dateTime.hour - 12 : notes[index].dateTime.hour}:${notes[index].dateTime.minute} ${notes[index].dateTime.hour > 12 ? 'PM' : 'AM'}',
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
                ).then((onValue) {
                  categoryList.add(newCategory);
                  categoryNameList.add(newCategory.name);
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setStringList('categoryNameList', categoryNameList);
                    addCategoryNameColor(newCategory.name, newCategory.color);
                  });

                  updateList();
                  updateCategoryList();
                });
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
    );
  }

  Column menu(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        ListTile(
          leading: Container(
            child: GFAvatar(
                size: GFSize.SMALL,
                backgroundImage: AssetImage('images/avatar.png'),
                shape: GFAvatarShape.standard),
          ),
          title:
              Text('Hello,', style: TextStyle(color: myTheme.mainAccentColor)),
          subtitle:
              Text('Humans', style: TextStyle(color: myTheme.mainAccentColor)),
          trailing: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                pageController.animateToPage(1,
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              }),
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: myTheme.mainAccentColor,
          ),
          title: Text('Settings'),
        ),
        ListTile(
          leading: Icon(
            Icons.cloud_upload,
            color: myTheme.mainAccentColor,
          ),
          title: Text('Cloud'),
          onTap: () {
            setState(() {
              _handleSignIn();
            });
          },
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

  void updateList() {
    databaseHelper.getNoteList().then((onValue) {
      setState(() {
        notes = onValue;
      });
    });
  }

  Future<void> addCategoryNameColor(String name, Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(name, getStringColor(color));
  }

  Future<void> setUserName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', name);
  }

  Future<void> updateUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userName = (prefs.getString('name') ?? 'Your Name');
  }
  Future<void> getpropic() async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Propic=(prefs.getString('propic') ?? null);
  }
  Future<void> profilepic() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('propic', propic);
  }

  updateCategoryList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    categoryNameList =
        (prefs.getStringList('categoryNameList') ?? ['Not Specified']);
    for (var name in categoryNameList) {
      var color = await getCategoryColor(name);
      setState(() {
        categoryList.add(Category(name, color: color));
      });
    }
  }

  String getStringColor(Color color) {
    if (color == Color(0xffe26e43)) {
      return 'red';
    }
    if (color == Color(0xff292e91)) {
      return 'blue';
    }
    if (color == Color(0xffa1ffb3)) {
      return 'yellow';
    }
    if (color == Color(0xffa82654)) {
      return 'green';
    }
    if (color == Color(0xfff9bfda)) {
      return 'lightgreen';
    }
    return 'black';
  }

  Future<Color> getCategoryColor(String name) async {
    var colorName;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      colorName = (prefs.getString(name) ?? 'black');
    });
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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShowNotes()),
            );
          },
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
