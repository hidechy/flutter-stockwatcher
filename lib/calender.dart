import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:http/http.dart';
import 'screens/DateStockDisplayScreen.dart';
import 'screens/GradeStockDisplayScreen.dart';
import 'utilities/utility.dart';

class Calender extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalenderState();
  }
}

class _CalenderState extends State<Calender> {
  DateTime _currentDate = DateTime.now();

  Utility _utility = Utility();

  String _isStockDateStr = '';

  /**
   * 画面描画
   */
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: const Text("stock watcher"),
        centerTitle: true,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          Container(
            child: CalendarCarousel<Event>(
              locale: 'JA',

              todayBorderColor: Colors.amber[600],
              todayButtonColor: Colors.amber[900],

              selectedDayBorderColor: Colors.blue[600],
              selectedDayButtonColor: Colors.blue[900],

              thisMonthDayBorderColor: Colors.grey,

              weekendTextStyle: TextStyle(
                  fontSize: 16.0, color: Colors.red, fontFamily: 'Yomogi'),
              weekdayTextStyle: TextStyle(color: Colors.grey),
              dayButtonColor: Colors.black.withOpacity(0.3),

              onDayPressed: onDayPressed,
              weekFormat: false,
              selectedDateTime: _currentDate,
              daysHaveCircularBorder: false,
              customGridViewPhysics: NeverScrollableScrollPhysics(),
              daysTextStyle: TextStyle(
                  fontSize: 16.0, color: Colors.white, fontFamily: 'Yomogi'),
              todayTextStyle: TextStyle(
                fontSize: 16.0,
                color: Colors.white,
                fontFamily: 'Yomogi',
              ),

              headerTextStyle: TextStyle(fontSize: 18.0, fontFamily: 'Yomogi'),
              selectedDayTextStyle: TextStyle(fontFamily: 'Yomogi'),
              prevDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),
              nextDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),

//markedDateCustomTextStyle: TextStyle(fontFamily: 'Yomogi'),
//markedDateMoreCustomTextStyle: TextStyle(fontFamily: 'Yomogi'),

//inactiveDaysTextStyle: TextStyle(fontFamily: 'Yomogi'),
//inactiveWeekendTextStyle: TextStyle(fontFamily: 'Yomogi'),
            ),
          ),

          //////////////////////////////////
          Column(
            children: <Widget>[
              Expanded(child: Container()),
              Container(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${_isStockDateStr}',
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                ),
              ),
              Container(
                height: 100,
              ),
              Container(
                alignment: Alignment.topLeft,
                child: Text('Grade'),
                color: Colors.green[900].withOpacity(0.5),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: size.width / 5,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 100,
                      child: RaisedButton(
                        child: Text('A'),
                        onPressed: () => _goGradeStockDisplayScreen(grade: 'A'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.blueAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 5,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 100,
                      child: RaisedButton(
                        child: Text('B'),
                        onPressed: () => _goGradeStockDisplayScreen(grade: 'B'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.redAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 5,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 100,
                      child: RaisedButton(
                        child: Text('C'),
                        onPressed: () => _goGradeStockDisplayScreen(grade: 'C'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.purpleAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 5,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 100,
                      child: RaisedButton(
                        child: Text('D'),
                        onPressed: () => _goGradeStockDisplayScreen(grade: 'D'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.greenAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: size.width / 5,
                    child: Container(
                      margin: EdgeInsets.all(5),
                      height: 100,
                      child: RaisedButton(
                        child: Text('E'),
                        onPressed: () => _goGradeStockDisplayScreen(grade: 'E'),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        color: Colors.yellowAccent.withOpacity(0.3),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          //////////////////////////////////
        ],
      ),
    );
  }

  /**
   * カレンダー日付クリック
   */
  void onDayPressed(DateTime date, List<Event> events) async {
    this.setState(() => _currentDate = date);
    _isStockDate(date: date.toString());
  }

  /**
   *その日のデータがあるかどうかチェックする
   */
  void _isStockDate({String date}) async {
    _isStockDateStr = '';

    ////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/stockdataexists";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": date});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);
      if (data['data'] == 0) {
        _isStockDateStr = "no data";

        setState(() {});
      } else {
        _goDateStockDisplayScreen(date: date.toString());
      }
    }
    ////////////////////////////
  }

  ///////////////////////////// 画面遷移

  /**
   * （画面遷移）_goDateStockDisplayScreen
   */
  void _goDateStockDisplayScreen({String date}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DateStockDisplayScreen(date: date),
      ),
    );
  }

  /**
   * （画面遷移）_goGradeStockDisplayScreen
   */
  void _goGradeStockDisplayScreen({String grade}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GradeStockDisplayScreen(grade: grade),
      ),
    );
  }
}
