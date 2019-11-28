import 'package:flutter/material.dart';
import 'package:flutter_weather/src/model/weather.dart';
import 'package:flutter_weather/src/utils/converters.dart';
import 'package:intl/intl.dart';

import 'current_conditions.dart';

class WeatherWidget extends StatelessWidget {
  final Weather weather;
  WeatherWidget({this.weather}) : assert(weather != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            this.weather.cityName.toUpperCase(),
            style: TextStyle(
                fontWeight: FontWeight.w900, letterSpacing: 5, fontSize: 25),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            DateFormat('EEEE, d MMMM yyyy').format(DateTime.now()),
          ),
          SizedBox(
            height: 20,
          ),
          Column(
            children: <Widget>[
              CurrentConditions(
                weather: weather,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20.0),
                height: 120.0,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: weather.forecast.length,
                    itemBuilder: (BuildContext context, int idx) {
                      return Container(
                          width: 100.0,
                          child: Column(
                            children: <Widget>[
                              Text(DateFormat('E, ha').format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      weather.forecast[idx].time * 1000))),
                              SizedBox(
                                height: 5,
                              ),
                              Icon(
                                weather.forecast[idx].getIconData(),
                                size: 30,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                  '${weather.forecast[idx].temperature.as(TemperatureUnit.celsius).round()}° C')
                            ],
                          ));
                    }),
              )
            ],
          )
        ],
      ),
    );
  }
}
