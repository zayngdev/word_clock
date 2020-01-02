import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
          backgroundColor: Color(0xFF212121),
          body: SafeArea(child: ClockPage()),
        ));
  }
}

class ClockPage extends StatefulWidget {
  @override
  _ClockPageState createState() => _ClockPageState();
}

class _ClockPageState extends State<ClockPage> {
  Timer _timer;
  //DateTime _dateTime = DateTime.parse("2019-12-09 06:10:04Z");
  DateTime _dateTime = DateTime.now();
  List<bool> colors;
  List<String> words = [
    "IT", // 0
    "IS", // 1
    "HALF", // 2
    "TEN", // 3
    "QUARTER", // 4
    "TWENTY", // 5
    "FIVE", // 6
    "", // Minutes        // 7
    "TO", // 8
    "PAST", // 9
    "ONE", // 10
    "THREE", // 11
    "TWO", // 12
    "FOUR", // 13
    "FIVE", // 14
    "SIX", // 15
    "SEVEN", // 16
    "EIGHT", // 17
    "NINE", // 18
    "TEN", // 19
    "ELEVEN", // 20
    "TWELVE", // 21
    "O'CLOCK" // 22
  ];

  double fontSize = 33.0;
  Color offColor = Color(0xff333333);
  Color onColor = Color(0xFFFFFFFF);
  int lastMinute = -1;

  @override
  void initState() {
    colors = List<bool>(23);
    updateColor();
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool hourBound(int hour) {
    return (getHour() == hour && colors[22]) ||
        (getHour() == hour && colors[9]) ||
        ((getHour() < 12 ? getHour() + 1 : 1) == hour && colors[8]);
  }

  int getMinute() {
    return _dateTime.minute;
  }

  int getHour() {
    int hour = _dateTime.hour;
    return (hour == 0) ? 12 : hour;
  }

  bool minuteBound(int min, int max) {
    return getMinute() <= max && getMinute() >= min;
  }

  Color getColor(bool on) {
    return on ? onColor : offColor;
  }

  FontWeight getFontWeight(bool on) {
    return on ? FontWeight.bold : FontWeight.w200;
  }

  void updateColor() {
    setState(() {
      colors[0] = true;
      colors[1] = true;
      colors[2] = minuteBound(30, 34);
      colors[3] = minuteBound(10, 14) || minuteBound(50, 54);
      colors[4] = minuteBound(15, 19) || minuteBound(45, 49);
      colors[5] = minuteBound(20, 29) || minuteBound(35, 44);
      colors[6] = minuteBound(5, 9) ||
          minuteBound(55, 59) ||
          minuteBound(25, 29) ||
          minuteBound(35, 39);

      colors[7] = !colors[2] && !colors[4] && !minuteBound(0, 4);
      colors[8] = minuteBound(35, 59);
      colors[9] = minuteBound(5, 34);
      colors[22] = minuteBound(0, 4);
      colors[10] = hourBound(1);
      colors[11] = hourBound(3);
      colors[12] = hourBound(2);
      colors[13] = hourBound(4);
      colors[14] = hourBound(5);
      colors[15] = hourBound(6);
      colors[16] = hourBound(7);
      colors[17] = hourBound(8);
      colors[18] = hourBound(9);
      colors[19] = hourBound(10);
      colors[20] = hourBound(11);
      colors[21] = hourBound(12);

      _dateTime = DateTime.now();

      _timer = Timer.periodic(const Duration(minutes: 1), (Timer t) {
        updateColor();
      });
    });
  }

  Color getColorForWord(int i) {
    if (colors[i] == null) {
      return offColor;
    }
    return getColor(colors[i]);
  }

  FontWeight getFontWeightForWord(int i) {
    if (colors[i] == null) {
      return FontWeight.w200;
    }
    return getFontWeight(colors[i]);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: 5.0,
          runSpacing: 10.0,
          children: <Widget>[
            for (int i = 0; i < words.length; ++i)
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Text(
                  words[i],
                  style: TextStyle(
                      fontFamily: "JosefinSans",
                      fontSize: fontSize,
                      color: getColorForWord(i),
                      fontWeight: getFontWeightForWord(i)),
                ),
              ),
          ]..add(Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                DateFormat('hhmm').format(_dateTime),
                style: TextStyle(
                    fontFamily: "Monserrat",
                    fontSize: fontSize,
                    color: onColor.withOpacity(0.4),
                    height: 1,
                    fontWeight: FontWeight.w300),
              ),
            )),
        ),
      ),
    );
  }
}
