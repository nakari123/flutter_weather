import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_weather/src/model/weather.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'converters.dart';

class CurrentConditions extends StatelessWidget {
  final Weather weather;

  const CurrentConditions({Key key, this.weather}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 300,
        child: Swiper(
          itemCount: 2,
          index: 0,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return currentWidget(weather);
            } else if (index == 1) {
              return temperatureLineChart(weather.forecast, true);
            }
            return Container();
          },
          pagination: new SwiperPagination(
              builder: const DotSwiperPaginationBuilder(
                  color: Colors.black,
                  activeColor: Colors.grey,
                  size: 10.0,
                  activeSize: 10.0,
                  space: 10.0)),
        ));
  }
}

Widget currentWidget(weather) {
  return Column(children: <Widget>[
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          weather.getIconData(),
          size: 70,
        ),
        Text(
          weather.description.toUpperCase(),
          style: TextStyle(fontSize: 25),
        )
      ],
    ),
    SizedBox(
      height: 50,
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          '${weather.temperature.as(TemperatureUnit.celsius).round()}°c',
          style: TextStyle(fontSize: 70, fontWeight: FontWeight.bold),
        ),
        Column(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black))),
                child: Text(
                    '${weather.maxTemperature.as(TemperatureUnit.celsius).round()}°c',
                    style: TextStyle(fontSize: 25))),
            Text(
                '${weather.minTemperature.as(TemperatureUnit.celsius).round()}°c',
                style: TextStyle(fontSize: 25)),
          ],
        )
      ],
    )
  ]);
}

Widget temperatureLineChart(weathers, animated) {
  return Padding(
      padding: const EdgeInsets.all(40.0),
      child: charts.TimeSeriesChart([
        charts.Series<Weather, DateTime>(
          id: 'Temperature',
          colorFn: (_, __) => charts.MaterialPalette.black,
          domainFn: (Weather weather, _) =>
              DateTime.fromMillisecondsSinceEpoch(weather.time * 1000),
          measureFn: (Weather weather, _) =>
              weather.temperature.as(TemperatureUnit.celsius),
          data: weathers,
        )
      ],
          animate: animated,
          animationDuration: Duration(milliseconds: 500),
          primaryMeasureAxis: charts.NumericAxisSpec(
              tickProviderSpec:
                  charts.BasicNumericTickProviderSpec(zeroBound: false))));
}
