import 'package:flutter/material.dart';
import 'package:horizontal_card_pager/card_item.dart';
import 'package:horizontal_card_pager/horizontal_card_pager.dart';
import 'package:intl/intl.dart';
import 'package:nurtureland/main.dart';
import 'package:nurtureland/screens/signin_screen.dart';
import 'package:nurtureland/screens/timer_screen.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:nurtureland/Models/minutes.dart';
import 'package:nurtureland/widgets/tasks_list.dart';
import 'package:flutter_cube/flutter_cube.dart';
import 'package:nurtureland/data/wealth_list.dart';
import 'package:nurtureland/data/wisdom_list.dart';
import 'package:nurtureland/data/love_list.dart';
import 'package:nurtureland/data/health_list.dart';
import 'package:nurtureland/data/happiness_list.dart';
import 'package:provider/provider.dart';
import 'package:nurtureland/models/task_data.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:io';

class MyHomePage extends StatefulWidget {
  int index;
  MyHomePage(this.index);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<CardItem> buckets = [
    IconTitleCardItem(
      text: "Wealth Land",
      iconData: Icons.attach_money_rounded,
      selectedBgColor: Colors.green,
    ),
    IconTitleCardItem(
      text: "Wisdom Land",
      iconData: FontAwesome5.brain,
      selectedBgColor: Colors.green,
    ),
    IconTitleCardItem(
      text: "Love Land",
      iconData: FontAwesome5.heart,
      selectedBgColor: Colors.green,
    ),
    IconTitleCardItem(
      text: "Health Land",
      iconData: FontAwesome5.weight,
      selectedBgColor: Colors.green,
    ),
    IconTitleCardItem(
      text: "Happiness Land",
      iconData: FontAwesome5.smile,
      selectedBgColor: Colors.green,
    ),
  ];

  Color gradientStart = Colors.green[300];
  Color gradientEnd = Colors.yellow[200];
  int _seconds = 00;
  int _minutes = 25;
  Minutes selectedMinute;
  int _selectedIndex;
  var f = NumberFormat("00");
  final _textEditingController = TextEditingController();
  int currentPage;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Vector3 showCurrentAxis(Object currentObject) {
    return currentObject.position;
  }

  void addTodo() {
    //  Add Todo list
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('What do I need to get done?'),
        content: TextField(
          controller: _textEditingController,
          decoration: InputDecoration(labelText: 'Enter your todo here'),
        ),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                print(_textEditingController.text);
                // TODO: Add NEW TASK
                Provider.of<TaskData>(context, listen: false)
                    .addTask(_textEditingController.text, currentPage);
                Navigator.pop(context, 'Add');
              },
              child: const Text('Add')),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    selectedMinute = Minutes(_minutes);
    _selectedIndex = widget.index;
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/header.png"),
                  fit: BoxFit.cover,
                  opacity: 0.75,
                ),
              ),
              child: Text(
                'Hello there!',
                //: TODO
                // Add username after the greeting.
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            ListTile(
              title: const Text('Stats'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sign out'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignInScreen()),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75, right: 5),
        child: (_selectedIndex == 0)
            ? FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: addTodo,
                backgroundColor: Colors.green,
              )
            : Container(),
      ),
      body: Stack(children: [
        (_selectedIndex == 0)
            ? taskTab(context)
            : (_selectedIndex == 1)
                ? timerTab(context)
                : landTab(context),
        Align(
          alignment: Alignment.bottomCenter,
          child: BottomNavigationBar(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.timer,
                    size: 40,
                  ),
                  label: 'Timer',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.landscape),
                  label: 'Land',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Colors.green[800],
              onTap: _onItemTapped),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 20),
          child: Align(
            alignment: Alignment.topLeft,
            child: IconButton(
              icon: Icon(Icons.menu),
              color: Colors.black,
              iconSize: 30,
              onPressed: () {
                _globalKey.currentState.openDrawer();
              },
            ),
          ),
        ),
      ]),
    );
  }

  Container taskTab(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(children: [
            Container(
              decoration: BoxDecoration(
                color: gradientStart,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                ),
              ),
              padding: EdgeInsets.only(left: 15, top: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon(Icons.format_list_bulleted),
                  SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 30),
                    child: Text(
                      "Great Things Will Come.",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
          Expanded(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, right: 10),
                    child: HorizontalCardPager(
                        onPageChanged: (page) {
                          setState(() {
                            currentPage = page.toInt();
                          });
                        },
                        onSelectedItem: (page) {
                          print(page);
                        },
                        initialPage: 2,
                        items: buckets),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10, bottom: 100),
                    child: (currentPage == 0)
                        ? WealthList()
                        : (currentPage == 1)
                            ? WisdomList()
                            : (currentPage == 2)
                                ? LoveList()
                                : (currentPage == 3)
                                    ? HealthList()
                                    : (currentPage == 4)
                                        ? HappinessList()
                                        : Text(
                                            "Tap the bucket to show your todos"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container landTab(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [Colors.black, Colors.blueGrey[900]],
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Center(
        child: WebView(
          initialUrl: 'https://demos.littleworkshop.fr/infinitown',
          javascriptMode:
              JavascriptMode.unrestricted, // Made the web work with this
        ),
        // child: Cube(
        //   onSceneCreated: (Scene scene) {
        //     Object land = Object(
        //       fileName: 'images/Cube/test.obj',
        //       scale: Vector3(
        //         5.0,
        //         5.0,
        //         5.0,
        //       ),
        //     );
        //     Object desert_tree = Object(
        //       fileName: 'images/Cube/pine_tree.obj',
        //       scale: Vector3(
        //         1,
        //         1,
        //         1,
        //       ),
        //       position: Vector3(
        //         2.2,
        //         -1.3,
        //         1.0,
        //       ),
        //       rotation: Vector3(
        //           -10.0,
        //           2.0, // Position
        //           2.0),
        //     );
        //     Object tree2 = Object(
        //       fileName: 'images/Cube/pine_tree.obj',
        //       scale: Vector3(
        //         1.0,
        //         1.0,
        //         1.0,
        //       ),
        //       position: Vector3(
        //         2.2,
        //         0.8,
        //         1.4,
        //       ),
        //       rotation: Vector3(
        //           -15.0,
        //           2.0, // Position
        //           2.0),
        //     );
        //     Object snow_tree = Object(
        //       fileName: 'images/Cube/pine_tree.obj',
        //       scale: Vector3(
        //         1.0,
        //         1.0,
        //         1.0,
        //       ),
        //       position: Vector3(
        //         1.2,
        //         1.7,
        //         1.4,
        //       ),
        //       rotation: Vector3(
        //           -15.0,
        //           2.0, // Position
        //           2.0),
        //     );
        //     Object land_tree = Object(
        //       fileName: 'images/Cube/pine_tree.obj',
        //       scale: Vector3(
        //         1.0,
        //         1.0,
        //         1.0,
        //       ),
        //       position: Vector3(
        //         1.6,
        //         0.8,
        //         1.9,
        //       ),
        //       rotation: Vector3(
        //           -15.0,
        //           2.0, // Position
        //           2.0),
        //     );
        //     Object new_tree = Object(
        //       fileName: 'images/Cube/tree_tinted.obj',
        //       scale: Vector3(
        //         5.0,
        //         5.0,
        //         5.0,
        //       ),
        //       position: Vector3(
        //         -3.1,
        //         -2.3,
        //         -1.75,
        //       ),
        //       rotation: Vector3(
        //           -30.0,
        //           3.0, // Position
        //           10.0),
        //     );
        //
        //     Object palm_tree = Object(
        //       fileName: 'images/Cube/palm_tree.obj',
        //       scale: Vector3(
        //         1.0,
        //         1.0,
        //         1.0,
        //       ),
        //       rotation: Vector3(
        //         -100,
        //         10,
        //         10,
        //       ),
        //       position: Vector3(
        //         0,
        //         0,
        //         -3.8, // How Close (z)
        //       ),
        //     );
        //
        //     Object palm_tree_dessert = Object(
        //       fileName: 'images/Cube/palm_tree.obj',
        //       scale: Vector3(
        //         1.0,
        //         1.0,
        //         1.0,
        //       ),
        //       rotation: Vector3(
        //         -80, // Up and Down
        //         30, //  + Left, - Right
        //         10,
        //       ),
        //       position: Vector3(
        //         -3.0, //  - Right, + Left
        //         0,
        //         -2.2, // - Out, + In
        //       ),
        //     );
        //     Object crooked_tree = Object(
        //       fileName: 'images/Cube/crooked_tree.obj',
        //       scale: Vector3(
        //         0.75,
        //         0.75,
        //         0.75,
        //       ),
        //       rotation: Vector3(
        //         -80, // Up and Down
        //         30, //  + Left, - Right
        //         50, // Bending left and right
        //       ),
        //       position: Vector3(
        //         -2.4, //  - Out, + In
        //         0,
        //         -0.2, // + Right, - Left
        //       ),
        //     );
        //     List<Object> trees = [
        //       desert_tree,
        //       tree2,
        //       snow_tree,
        //       land_tree,
        //       new_tree,
        //       palm_tree,
        //       palm_tree_dessert,
        //       crooked_tree,
        //     ];
        //     scene.world.children = trees;
        //     scene.world.add(land);
        //   },
        // ),
      ),
    );
  }

  Container timerTab(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        gradient: new LinearGradient(
            colors: [gradientStart, gradientEnd],
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SingleCircularSlider(
            120,
            25,
            width: MediaQuery.of(context).size.width / 2,
            height: MediaQuery.of(context).size.height / 3,
            child: Center(
              child: Text(
                "${f.format(_minutes)} : ${f.format(_seconds)}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                ),
              ),
            ),
            baseColor: Color.fromRGBO(255, 255, 255, .2),
            selectionColor: Colors.white,
            onSelectionEnd: (init, end, laps) {
              setState(() {
                if (end % 5 == 0 && end > 0) {
                  _minutes = end;
                  selectedMinute = Minutes(_minutes);
                }
              });
            },
            onSelectionChange: (init, end, laps) {
              setState(() {
                if (end % 5 == 0 && end > 0) {
                  _minutes = end;
                  selectedMinute = Minutes(_minutes);
                }
              });
            },
          ),
          SizedBox(
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RaisedButton(
                onPressed: () {
//                    Navigate to next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TimerScreen(selectedMinute)),
                  );
                },
                color: Colors.green[400],
                shape: CircleBorder(),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 40, bottom: 40, left: 10, right: 10),
                  child: Text(
                    "Start",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
