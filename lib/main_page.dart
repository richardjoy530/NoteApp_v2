import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/getflutter.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> carouselList = [
    'Notes',
    'Important',
    'Starred',
    'Notes',
    'Important',
    'Starred',
    'Notes',
    'Important',
    'Starred'
  ];

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
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                trailing: GFAvatar(
                    size: GFSize.SMALL,
                    backgroundImage: AssetImage('images/avatar.png'),
                    shape: GFAvatarShape.standard),
                title: Text(
                  "Richard Joy",
                  style: TextStyle(
                      fontFamily: "BalooTamma2",
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                leading: IconButton(icon: Icon(Icons.menu), onPressed: null),
              ),
            ),
            Container(
              constraints: BoxConstraints(maxHeight: 230),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return MainTile(
                    index: index,
                    mainTileText: carouselList[index],
                  );
                },
                itemCount: carouselList.length,
              ),
            ),
            TabBar(
              labelStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              labelColor: Colors.black,
              indicatorColor: Color(0xff3f79fe),
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
                          return Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Card(
                                color: Color(0xffeff3f8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: ListTile(
                                    onTap: null,
                                    title: Text(
                                      carouselList[index],
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      'This is my debut shot at dribbble and I\'m really glad I got here. This shot is dedicated to notes for your phone in bright blue tones.'
                                      'What do you think about it?',
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
                                          Icons.card_travel,
                                          color: Color(0xff3f79fe),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: carouselList.length,
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
                                color: Color(0xffeff3f8),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: ListTile(
                                    onTap: null,
                                    title: Text(
                                      carouselList[index],
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
                        itemCount: carouselList.length,
                      ),
                    ),
                  ),
                  //TODO Team Notes
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
                backgroundColor: Color(0xff3f79fe),
                heroTag: 'hero1',
                label: Text('Category'),
                icon: Icon(Icons.add),
                onPressed: () {},
              ),
              FloatingActionButton.extended(
                backgroundColor: Color(0xff3f79fe),
                label: Text('Note'),
                icon: Icon(Icons.add),
                onPressed: () {},
              )
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class MainTile extends StatelessWidget {
  final int index;
  final String mainTileText;

  const MainTile({Key key, this.index, this.mainTileText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: index == 0 ? Color(0xff3f79fe) : Color(0xffeff3f8),
          boxShadow: [
            BoxShadow(
                color: index == 0 ? Color(0xff3f79fe) : Color(0xfff5f7fb),
                blurRadius: 3)
          ],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      width: 155,
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
                '112',
                style: TextStyle(
                    color: index == 0 ? Colors.white : Colors.blueGrey,
                    fontSize: 25),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
