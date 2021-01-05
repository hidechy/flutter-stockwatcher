import 'package:flutter/material.dart';
import 'package:stockwatcher/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

class RecordAllListScreen extends StatefulWidget {
  final String code;
  RecordAllListScreen({@required this.code});

  @override
  _RecordAllListScreenState createState() => _RecordAllListScreenState();
}

class _RecordAllListScreenState extends State<RecordAllListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _priceData = List();

  String market;
  String company;
  String industry;
  String tangen;
  String grade;

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
    ////////////////////////////
    String url = "http://toyohide.work/BrainLog/api/stockalldata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"code": widget.code});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      market = data['data']['market'];
      company = data['data']['company'];
      industry = data['data']['industry'];
      tangen = data['data']['tangen'];
      grade = data['data']['grade'];

      for (var i = 0; i < data['data']['price'].length; i++) {
        var _map = Map();

        var ex_value = (data['data']['price'][i]).split('|');
        _map['date'] = ex_value[0];
        _map['price'] = ex_value[1];
        _map['isUpper'] = ex_value[2];

        _priceData.add(_map);
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
        title: Text("all record"),
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
                  leading: Text(
                    '${grade}',
                    style: TextStyle(fontSize: 20),
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
                        Text('${market}')
                      ],
                    ),
                  ),
                ),
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
      color: Colors.black.withOpacity(0.3),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        trailing: (_priceData[position]['isUpper'] == '1')
            ? Icon(Icons.arrow_upward, color: Colors.white)
            : Icon(Icons.check_box_outline_blank,
                color: Colors.black.withOpacity(0.1)),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  '${_priceData[position]['date']}　${_priceData[position]['price']}'),
            ],
          ),
        ),
//        onTap: () => _goRecordListScreen(code: _priceData[position]['code']),
      ),
    );
  }
}
