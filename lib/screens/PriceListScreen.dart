import 'package:flutter/material.dart';
import 'package:stockwatcher/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'RecordListScreen.dart';

class PriceListScreen extends StatefulWidget {
  final int price;

  PriceListScreen({@required this.price});

  @override
  _PriceListScreenState createState() => _PriceListScreenState();
}

class _PriceListScreenState extends State<PriceListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _priceData = List();

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
    String url = "http://toyohide.work/BrainLog/api/stockpricedata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"price": widget.price});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        var _map = Map();

        var ex_value = (data['data'][i]).split('|');

        _map['code'] = ex_value[0];
        _map['market'] = ex_value[1];
        _map['company'] = ex_value[2];
        _map['price'] = ex_value[3];
        _map['grade'] = ex_value[4];
        _map['industry'] = ex_value[5];
        _map['tangen'] = ex_value[6];
        _map['isCountOverTwo'] = ex_value[7];
        _map['isUpper'] = ex_value[8];
        _map['created_at'] = ex_value[9];

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
        title: Text("～${widget.price}"),
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
  _listItem({int position}) {
    var _codeLine = "";
    _codeLine += _priceData[position]['code'] + "　";
    _codeLine += _priceData[position]['industry'] + "　";
    _codeLine += _priceData[position]['market'];

    var _priceLine = "";
    _priceLine += _priceData[position]['price'];
    _priceLine += "（" + _priceData[position]['tangen'] + "）　";
    _priceLine += _priceData[position]['price'];

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
              Text('${_priceData[position]['company']}'),
              SizedBox(
                height: 10,
              ),
              Text('${_codeLine}'),
              SizedBox(
                height: 10,
              ),
              Text('${_priceLine}'),
            ],
          ),
        ),
        onTap: () => _goRecordListScreen(code: _priceData[position]['code']),
      ),
    );
  }

  /**
   *
   */
  void _goRecordListScreen({String code}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecordListScreen(
          code: code,
          date: DateTime.now().toString(),
        ),
      ),
    );
  }
}
