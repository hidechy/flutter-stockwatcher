import 'package:flutter/material.dart';
import 'package:stockwatcher/screens/PriceListScreen.dart';
import 'package:stockwatcher/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

class DateListScreen extends StatefulWidget {
  final String date;
  DateListScreen({@required this.date});

  @override
  _DateListScreenState createState() => _DateListScreenState();
}

class _DateListScreenState extends State<DateListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _dateHourData = List();

  String _selectedTime;

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    _utility.makeYMDYData(widget.date, 0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: Text(
            "${_utility.year}-${_utility.month}-${_utility.day}（${_utility.youbiStr}）"),
        centerTitle: true,

        //-------------------------//これを消すと「←」が出てくる（消さない）
        leading: Icon(
          Icons.check_box_outline_blank,
          color: Colors.black.withOpacity(0.1),
        ),
        //-------------------------//これを消すと「←」が出てくる（消さない）

        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            color: Colors.greenAccent,
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          _utility.getBackGround(),
          Container(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _getTimeBtn(time: '09'),
                    _getTimeBtn(time: '10'),
                    _getTimeBtn(time: '11'),
                    _getTimeBtn(time: '12'),
                    _getTimeBtn(time: '13'),
                    _getTimeBtn(time: '14'),
                    _getTimeBtn(time: '15'),
                  ],
                ),
                Expanded(
                  child: _dateHourList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   *
   */
  Widget _getTimeBtn({String time}) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width / 7,
      child: Container(
        height: 60,
        margin: EdgeInsets.all(5),
        child: RaisedButton(
          child: Text(
            '${time}',
            style: TextStyle(fontSize: 10.0),
          ),
          onPressed: () => _clickTimeBtn(time: time),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: _getBtnBgColor(btnName: time),
        ),
      ),
    );
  }

  /**
   *
   */
  Color _getBtnBgColor({String btnName}) {
    return (_selectedTime == btnName)
        ? Colors.orangeAccent.withOpacity(0.5)
        : Colors.orangeAccent.withOpacity(0.2);
  }

  /**
   *
   */
  void _clickTimeBtn({String time}) async {
    String url = "http://toyohide.work/BrainLog/api/stockdatedata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"date": widget.date, "time": time});
    Response response = await post(url, headers: headers, body: body);

    _dateHourData = List();
    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        var _map = Map();

        var ex_value = (data['data'][i]).split('|');
        _map['rank'] = ex_value[0].padLeft(2, '0');
        _map['code'] = ex_value[1];
        _map['company'] = ex_value[2];
        _map['grade'] = ex_value[3];
        _map['price'] = ex_value[4];
        _map['tangen'] = ex_value[5];
        _map['market'] = ex_value[6];
        _map['isCountOverTwo'] = ex_value[7];
        _map['isUpper'] = ex_value[8];

        _dateHourData.add(_map);
      }
    }

    _selectedTime = time;

    setState(() {});
  }

  /**
   *
   */
  Widget _dateHourList() {
    return ListView.builder(
      itemCount: _dateHourData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    var _codeLine = "";
    _codeLine += _dateHourData[position]['code'] + "　";

    if (_dateHourData[position]['price'] != "") {
      _codeLine +=
          _utility.makeCurrencyDisplay(_dateHourData[position]['price']);
    } else {
      _codeLine += "";
    }

    _codeLine += "（" + _dateHourData[position]['tangen'] + "）　";
    _codeLine += _dateHourData[position]['market'];

    var _leading = "";
    _leading += _dateHourData[position]['rank'];
    _leading += "：";
    _leading += _dateHourData[position]['grade'];

    return Card(
      color: _getBgColor(grade: _dateHourData[position]['grade']),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Text('${_leading}'),
        trailing: (_dateHourData[position]['isUpper'] == '1')
            ? Icon(Icons.arrow_upward, color: Colors.white)
            : Icon(Icons.check_box_outline_blank,
                color: Colors.black.withOpacity(0.1)),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_dateHourData[position]['company']}'),
              SizedBox(
                height: 10,
              ),
              Text('${_codeLine}'),
            ],
          ),
        ),
        onTap: () => _goPriceListScreen(code: _dateHourData[position]['code']),
      ),
    );
  }

  /**
   *
   */
  Color _getBgColor({String grade}) {
    switch (grade) {
      case 'E':
        return Colors.yellowAccent.withOpacity(0.3);
        break;
      default:
        return Colors.black.withOpacity(0.3);
        break;
    }
  }

  /**
   *
   */
  void _goPriceListScreen({String code}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PriceListScreen(
          code: code,
          date: DateTime.now().toString(),
        ),
      ),
    );
  }
}
