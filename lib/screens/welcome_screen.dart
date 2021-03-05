import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nurtureland/screens/timer_screen.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:nurtureland/Models/minutes.dart';
import 'package:nurtureland/widgets/tasks_list.dart';
import 'package:flutter_cube/flutter_cube.dart' as cube;
import 'package:scroll_snap_list/scroll_snap_list.dart';



class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> data = [];
  int _focusedIndex = 0;
  GlobalKey<ScrollSnapListState> sslKey = GlobalKey();

  Color gradientStart = Colors.green[300];
  Color gradientEnd = Colors.yellow[200];
  int _seconds = 00;
  int _minutes = 25;
  Minutes selectedMinute;
  int _selectedIndex = 0;
  var f = NumberFormat("00");

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedMinute = Minutes(_minutes);
    for (int i = 0; i < 30; i++) {
      data.add(Random().nextInt(100) + 1);
    }
  }
  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }
  Widget _buildItemDetail() {
    if (data.length > _focusedIndex)
      return Container(
        height: 350,
        child: Text("index $_focusedIndex: ${data[_focusedIndex]}"),
      );

    return Container(
      height: 350,
      child: Text("No Data"),
    );
  }
  Widget _buildListItem(BuildContext context, int index) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      width: 350,
      height: 100,
      child: Material(
        child: InkWell(
            onTap: (){
              sslKey.currentState.focusToItem(index);
            },
            focusColor: Colors.green,
            child: Text("Child index $index"),
          ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            (_selectedIndex == 0) ? taskTab(context) :
            (_selectedIndex == 1) ? timerTab(context) :
            landTab(context),
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
          ]
      ),

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
                  Icon(Icons.format_list_bulleted),
                  SizedBox(
                    height: 10,
                    width: double.infinity,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30, bottom: 30),
                    child: Text(
                      "Goal: Get Good Grade.",
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
          SizedBox(
            height: 150,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
              child: ScrollSnapList(
                margin: EdgeInsets.symmetric(vertical: 10),
                onItemFocus: _onItemFocus,
                itemSize: 360,
                itemBuilder: _buildListItem,
                itemCount: data.length,
                key: sslKey,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TasksList(),
            ),
          )
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
            colors: [gradientStart, gradientEnd],
            begin: const FractionalOffset(0.5, 0.0),
            end: const FractionalOffset(0.0, 0.5),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Center(
        child: cube.Cube(
          onSceneCreated: (cube.Scene scene) {
            Object forest = cube.Object(fileName:'images/PUSHILIN_pine_tree.obj', scale: cube.Vector3(5.0, 5.0, 5.0));
            scene.world.add(forest);


          },
        ),
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
            width: MediaQuery
                .of(context)
                .size
                .width / 2,
            height: MediaQuery
                .of(context)
                .size
                .height / 3,
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
