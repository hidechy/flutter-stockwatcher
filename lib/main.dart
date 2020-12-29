import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'calender.dart';

/**
* メイン関数
*/
void main() {
  WidgetsFlutterBinding.ensureInitialized();
//画面向き指定
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp, //縦固定
    ],
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
/**
* 画面描画
*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('ja'),
      ],
      title: 'stock watcher',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, fontFamily: "Yomogi"),
      home: Calender(),
    );
  }
}
