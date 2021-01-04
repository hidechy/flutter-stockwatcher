import 'package:flutter/material.dart';
import 'package:stockwatcher/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'PriceListScreen.dart';

class IndustryDetailListScreen extends StatefulWidget {
  final String industry;
  final String grade;
  IndustryDetailListScreen({@required this.industry, @required this.grade});

  @override
  _IndustryDetailListScreenState createState() =>
      _IndustryDetailListScreenState();
}

class _IndustryDetailListScreenState extends State<IndustryDetailListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _industryDetailData = List();

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
    String url = "http://toyohide.work/BrainLog/api/stockindustrydata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({"industry": widget.industry});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);

      for (var i = 0; i < data['data'].length; i++) {
        _industryDetailData.add(data['data'][i]);
      }
    }

    setState(() {});
  }

  /**
   *
   */
  @override
  Widget build(BuildContext context) {
    var _appTitle = widget.industry;
    if (widget.grade != "") {
      _appTitle += "（" + widget.grade + "）";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.6),
        title: Text("${_appTitle}"),
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
                  child: _industryDetailList(),
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
  Widget _industryDetailList() {
    return ListView.builder(
      itemCount: _industryDetailData.length,
      itemBuilder: (context, int position) => _listItem(position: position),
    );
  }

  /**
   *
   */
  Widget _listItem({int position}) {
    var _codeLine = "";
    _codeLine += _industryDetailData[position]['code'].toString() + "　";

    if (_industryDetailData[position]['price'] != "") {
      _codeLine +=
          _utility.makeCurrencyDisplay(_industryDetailData[position]['price']);
    } else {}

    _codeLine += "（" + _industryDetailData[position]['tangen'] + "）　";
    _codeLine += _industryDetailData[position]['market'];

    var _dateLine = "";
    _dateLine += _industryDetailData[position]['date'] + "　";

    if (_industryDetailData[position]['sum'] != "") {
      _dateLine +=
          _utility.makeCurrencyDisplay(_industryDetailData[position]['sum']) +
              " pt";
    }

    return Card(
      color: _getBgColor(grade: _industryDetailData[position]['grade']),
      elevation: 10.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListTile(
        leading: Text('${_industryDetailData[position]['grade']}'),
        trailing: (_industryDetailData[position]['isUpper'] == '1')
            ? Icon(Icons.arrow_upward, color: Colors.white)
            : Icon(Icons.check_box_outline_blank,
                color: Colors.black.withOpacity(0.1)),
        title: DefaultTextStyle(
          style: TextStyle(fontSize: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${_industryDetailData[position]['company']}'),
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
        onTap: () => _goPriceListScreen(
            code: _industryDetailData[position]['code'].toString()),
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
