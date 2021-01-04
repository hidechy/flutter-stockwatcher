import 'package:flutter/material.dart';
import 'package:stockwatcher/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

class PriceListScreen extends StatefulWidget {
  final String code;
  final String date;
  PriceListScreen({@required this.code, @required this.date});

  @override
  _PriceListScreenState createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _priceData = List();

  String company;
  String industry;
  String tangen;
  String market;
  String isCountOverTwo;
  String isUpper;
  String grade;

  String _yearmonth;

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
    _utility.makeYMDYData(widget.date, 0);
    _yearmonth = _utility.year + "-" + _utility.month;

    ////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/stockcodedata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({
      "code": widget.code,
      "date": _utility.year + "-" + _utility.month,
    });
    Response response = await post(url, headers: headers, body: body);

    _priceData = List();
    if (response != null) {
      Map data = jsonDecode(response.body);

      company = data['data']['company'];
      industry = data['data']['industry'];
      tangen = data['data']['tangen'];
      market = data['data']['market'];
      isCountOverTwo = data['data']['isCountOverTwo'];
      isUpper = data['data']['isUpper'];
      grade = data['data']['grade'];

      for (var i = 0; i < data['data']['price'].length; i++) {
        var _map = Map();

        var ex_value = (data['data']['price'][i]).split('|');
        _map['date'] = ex_value[0];
        _map['hour_09'] = ex_value[1];
        _map['hour_10'] = ex_value[2];
        _map['hour_11'] = ex_value[3];
        _map['hour_12'] = ex_value[4];
        _map['hour_13'] = ex_value[5];
        _map['hour_14'] = ex_value[6];
        _map['hour_15'] = ex_value[7];

        _priceData.add(_map);
      }
    }
    ////////////////////////////

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
        title: Text("stock detail"),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ListTile(
                  leading: Column(
                    children: <Widget>[
                      Text(
                        '${grade}',
                        style: TextStyle(fontSize: 20),
                      ),
                      (isUpper == '1')
                          ? Icon(Icons.arrow_upward, color: Colors.white)
                          : Icon(Icons.check_box_outline_blank,
                              color: Colors.black.withOpacity(0.1)),
                    ],
                  ),
                  title: DefaultTextStyle(
                    style: TextStyle(fontSize: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('${company}'),
                        Text('${widget.code}'),
                        Text('${industry}'),
                        Text('${tangen}'),
                        Text('${market}'),
                      ],
                    ),
                  ),
                ),

                //--------------------//
                Container(
                  child: Wrap(
                    children: _makeMonthBtn(),
                  ),
                ),
                //--------------------//

                Expanded(
                  child: _priceList(),
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
  Widget _priceList() {
    return ListView.builder(
      itemCount: _priceData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    return Card(
      color: _getBgColor(date: _priceData[position]['date']),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Row(
            children: <Widget>[
              Text('${_priceData[position]['date']}'),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Table(
                      children: [
                        TableRow(children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Text('${_priceData[position]['hour_09']}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text('${_priceData[position]['hour_10']}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text('${_priceData[position]['hour_11']}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text('${_priceData[position]['hour_12']}'),
                          ),
                        ]),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Table(
                      children: [
                        TableRow(children: [
                          Container(
                            alignment: Alignment.topRight,
                            child: Text('${_priceData[position]['hour_13']}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text('${_priceData[position]['hour_14']}'),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text('${_priceData[position]['hour_15']}'),
                          ),
                          Container(),
                        ]),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /**
   *
   */
  Color _getBgColor({String date}) {
    _utility.makeYMDYData(date, 0);

    switch (_utility.youbiNo) {
      case 0:
      case 6:
        return Colors.black.withOpacity(0.3);
        break;
      default:
        return Colors.orangeAccent.withOpacity(0.3);
        break;
    }
  }

  /**
   *
   */
  List _makeMonthBtn() {
    List<Widget> _btnList = List();

    var _ym = _getYm();

    for (var i = 0; i < _ym.length; i++) {
      _btnList.add(
        (_ym[i] == _yearmonth)
            ? Container(
                color: Colors.green[900],
                margin: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                padding: EdgeInsets.all(8),
                child: Text('${_ym[i]}'),
              )
            : GestureDetector(
                onTap: () => _goPriceListScreen(date: _ym[i]),
                child: Container(
                  color: Colors.green[300],
                  margin: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                  padding: EdgeInsets.all(8),
                  child: Text('${_ym[i]}'),
                ),
              ),
      );
    }

    return _btnList;
  }

  /**
   *
   */
  List _getYm() {
    List _ym = List();

    final start = DateTime(2020, 9, 29);
    final today = DateTime.now();

    int diffDays = today.difference(start).inDays;

    _utility.makeYMDYData(start.toString(), 0);
    var baseYear = _utility.year;
    var baseMonth = _utility.month;
    var baseDay = _utility.day;

    for (int i = 0; i <= diffDays; i++) {
      var genDate = new DateTime(
          int.parse(baseYear), int.parse(baseMonth), (int.parse(baseDay) + i));
      _utility.makeYMDYData(genDate.toString(), 0);

      if (!_ym.contains(_utility.year + "-" + _utility.month)) {
        _ym.add(_utility.year + "-" + _utility.month);
      }
    }

    return _ym;
  }

  /**
   *
   */
  void _goPriceListScreen({String date}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PriceListScreen(
          code: widget.code,
          date: date + '-01 00:00:00',
        ),
      ),
    );
  }
}
