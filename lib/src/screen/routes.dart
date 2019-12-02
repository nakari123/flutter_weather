import 'package:flutter/material.dart';
import 'package:flutter_weather/src/screen/home_screen.dart';
import 'package:flutter_weather/src/screen/splash_screen.dart';

class Routes {

  static final mainRoute = <String, WidgetBuilder>{
    '/': (context) => SplashScreenWidget(),
    '/home': (context) => HomeScreenWidget(),
    '/settings': (context) => HomeScreenWidget(),
  };
}
