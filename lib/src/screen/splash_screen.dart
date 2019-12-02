import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_weather/src/utils/WeatherIconMapper.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  @override
  void initState() {
    super.initState();
    timerSplash();
  }
  Future<Timer> timerSplash() async {
    return new Timer(Duration(seconds: 2), onDoneLoading);
  }
  onDoneLoading() async {
    Navigator.pushNamed(context, '/home');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            WeatherIcons.clear_day,
            size: 70,
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            'NK Weather',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
          )
        ],
      ),
    ));
  }
}
