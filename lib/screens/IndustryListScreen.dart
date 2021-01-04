import 'package:flutter/material.dart';
import 'package:stockwatcher/utilities/utility.dart';

import 'dart:convert';
import 'package:http/http.dart';

import 'IndustryDetailListScreen.dart';

class IndustryListScreen extends StatefulWidget {
  @override
  _IndustryListScreenState createState() => _IndustryListScreenState();
}

class _IndustryListScreenState extends State<IndustryListScreen> {
  Utility _utility = Utility();

  List<Map<dynamic, dynamic>> _industryData = List();

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
    String url = "http://toyohide.work/BrainLog/api/stockindustrylistdata";
    Map<String, String> headers = {'content-type': 'application/json'};
    String body = json.encode({});
    Response response = await post(url, headers: headers, body: body);

    if (response != null) {
      Map data = jsonDecode(response.body);
      for (var i = 0; i < data['data'].length; i++) {
        _industryData.add(data['data'][i]);
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
        title: Text("Industry Ranking"),
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
                  child: _industryList(),
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
  Widget _industryList() {
    return ListView.builder(
      itemCount: _industryData.length,
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
        title: Table(
          children: [
            TableRow(children: [
              Align(
                alignment: Alignment.topLeft,
                child: Text('${_industryData[position]['industry']}'),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Text(
                    '${_utility.makeCurrencyDisplay(_industryData[position]['sum'])} pt'),
              ),
            ]),
          ],
        ),
        onTap: () => _goIndustryDetailListScreen(
            industry: _industryData[position]['industry']),
      ),
    );
  }

  /**
   *
   */
  void _goIndustryDetailListScreen({String industry}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndustryDetailListScreen(
          industry: industry,
          grade: '',
        ),
      ),
    );
  }
}
