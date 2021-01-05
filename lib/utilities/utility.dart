import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utility {
  /**
   * 背景取得
   */
  Widget getBackGround() {
    return Image.asset(
      'assets/image/bg.jpg',
      fit: BoxFit.cover,
      color: Colors.black.withOpacity(0.6),
      colorBlendMode: BlendMode.darken,
    );
  }

  /**
   * 日付データ作成
   */
  String year;
  String month;
  String day;
  String youbi;
  String youbiStr;
  int youbiNo;

  void makeYMDYData(String date, int noneDay) {
    List explodedDate = date.split(' ');
    List explodedSelectedDate = explodedDate[0].split('-');
    year = explodedSelectedDate[0];
    month = explodedSelectedDate[1];

    if (noneDay == 1) {
      var f = new NumberFormat("00");
      day = f.format(1);
    } else {
      day = explodedSelectedDate[2];
    }

    DateTime youbiDate =
        DateTime(int.parse(year), int.parse(month), int.parse(day));
    youbi = DateFormat('EEEE').format(youbiDate);
    switch (youbi) {
      case "Sunday":
        youbiStr = "日";
        youbiNo = 0;
        break;
      case "Monday":
        youbiStr = "月";
        youbiNo = 1;
        break;
      case "Tuesday":
        youbiStr = "火";
        youbiNo = 2;
        break;
      case "Wednesday":
        youbiStr = "水";
        youbiNo = 3;
        break;
      case "Thursday":
        youbiStr = "木";
        youbiNo = 4;
        break;
      case "Friday":
        youbiStr = "金";
        youbiNo = 5;
        break;
      case "Saturday":
        youbiStr = "土";
        youbiNo = 6;
        break;
    }
  }

  /**
   * 金額を3桁区切りで表示する
   */
  final formatter = NumberFormat("#,###");
  String makeCurrencyDisplay(String text) {
    return formatter.format(int.parse(text));
  }
}
