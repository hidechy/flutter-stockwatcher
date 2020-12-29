import 'package:flutter/material.dart';
import 'package:stockwatcher/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'CodeStockDisplayScreen.dart';

class GradeStockDisplayScreen extends StatefulWidget {
  final String grade;
  GradeStockDisplayScreen({@required this.grade});

  @override
  _GradeStockDisplayScreenState createState() =>
      _GradeStockDisplayScreenState();
}

class _GradeStockDisplayScreenState extends State<GradeStockDisplayScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _gradeData = List();

  /**
   * 初期動作
   */
  @override
  void initState() {
    super.initState();

    _makeDefaultDisplayData();
  }

  /**
   * 初期データ作成
   */
  void _makeDefaultDisplayData() async {
    String url = "http://toyohide.work/BrainLog/api/stockgradedata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"grade": widget.grade});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        var _map = Map();

        var ex_value = (data['data'][i]).split('|');

        _map['code'] = ex_value[0];
        _map['company'] = ex_value[1];
        _map['industry'] = ex_value[2];
        _map['date'] = ex_value[3];
        _map['price'] = ex_value[4];
        _map['tangen'] = ex_value[5];
        _map['market'] = ex_value[6];
        _map['isCountOverTwo'] = ex_value[7];
        _map['isUpper'] = ex_value[8];

        _gradeData.add(_map);
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: Text("${widget.grade}"),
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
                Expanded(
                  child: _gradeList(),
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
  Widget _gradeList() {
    return ListView.builder(
      itemCount: _gradeData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    var _codeLine = "";
    _codeLine += _gradeData[position]['code'] + "　";
    _codeLine += _utility.makeCurrencyDisplay(_gradeData[position]['price']);
    _codeLine += "（" + _gradeData[position]['tangen'] + "）　";
    _codeLine += _gradeData[position]['market'];

    var _dateLine = "";
    _dateLine += _gradeData[position]['date'] + "　";
    _dateLine += _gradeData[position]['industry'];

    return Card(
      color: _getBgColor(grade: widget.grade),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        trailing: (_gradeData[position]['isUpper'] == '1')
            ? Icon(Icons.arrow_upward, color: Colors.white)
            : Icon(Icons.check_box_outline_blank,
                color: Colors.black.withOpacity(0.1)),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_gradeData[position]['company']}'),
              SizedBox(
                height: 10,
              ),
              Text('${_codeLine}'),
              SizedBox(
                height: 10,
              ),
              Text('${_dateLine}'),
            ],
          ),
        ),
        onTap: () =>
            _goCodeStockDisplayScreen(code: _gradeData[position]['code']),
      ),
    );
  }

  /**
   *
   */
  Color _getBgColor({String grade}) {
    switch (grade) {
      case 'A':
        return Colors.blueAccent.withOpacity(0.3);
        break;
      case 'B':
        return Colors.redAccent.withOpacity(0.3);
        break;
      case 'C':
        return Colors.purpleAccent.withOpacity(0.3);
        break;
      case 'D':
        return Colors.greenAccent.withOpacity(0.3);
        break;
      case 'E':
        return Colors.yellowAccent.withOpacity(0.3);
        break;
    }
  }

  /**
   *
   */
  void _goCodeStockDisplayScreen({String code}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CodeStockDisplayScreen(
          code: code,
          date: DateTime.now().toString(),
        ),
      ),
    );
  }
}
