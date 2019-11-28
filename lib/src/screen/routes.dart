import 'package:flutter/material.dart';
import 'package:flutter_weather/src/screen/home_screen.dart';

class Routes {

  static final mainRoute = <String, WidgetBuilder>{
    '/home': (context) => HomeScreenWidget(),
    '/settings': (context) => HomeScreenWidget(),
  };
}
