import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather/src/api/api_key.dart';
import 'package:flutter_weather/src/api/weather_api.dart';
import 'package:flutter_weather/src/bloc/weather_event.dart';
import 'package:flutter_weather/src/bloc/weather_state.dart';
import 'package:flutter_weather/src/repository/weather_repository.dart';
import 'package:flutter_weather/src/utils/weather_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_weather/src/bloc/weather_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_google_places/flutter_google_places.dart';

class HomeScreenWidget extends StatefulWidget {
  final WeatherRepository weatherRepository = WeatherRepository(
      weatherApiClient: WeatherApiClient(
          httpClient: http.Client(), apiKey: ApiKey.OPEN_WEATHER_MAP));

  @override
  _HomeScreenWidgetState createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  WeatherBloc _weatherBloc;
  String _cityName = 'Hanoi';

  @override
  void initState() {
    super.initState();
    _weatherBloc = WeatherBloc(weatherRepository: widget.weatherRepository);
    _fetchWeatherWithLocation().catchError((error) {
      _fetchWeatherWithCity();
    });
  }

  _fetchWeatherWithCity() {
    _weatherBloc.dispatch(FetchWeather(cityName: _cityName));
  }

  _fetchWeatherWithLocation() async {
    var permissionHandler = PermissionHandler();
    var permissionResult = await permissionHandler
        .requestPermissions([PermissionGroup.locationWhenInUse]);

    switch (permissionResult[PermissionGroup.locationWhenInUse]) {
      case PermissionStatus.denied:
      case PermissionStatus.unknown:
        print('location permission denied');
        _showLocationDeniedDialog(permissionHandler);
        throw Error();
    }

    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    _weatherBloc.dispatch(FetchWeather(
        longitude: position.longitude, latitude: position.latitude));
  }

  void _showLocationDeniedDialog(PermissionHandler permissionHandler) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text('Location is disabled :(',
                style: TextStyle(color: Colors.black)),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'Enable!',
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                onPressed: () {
                  permissionHandler.openAppSettings();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: BlocBuilder(
            bloc: _weatherBloc,
            builder: (BuildContext context, WeatherState weatherState) {
              if (weatherState is WeatherLoaded) {
                this._cityName = weatherState.weather.cityName;
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: TextField(
                        onChanged: (text) {
                          _cityName =
                              text.replaceAll(new RegExp(r"\s+\b|\b\s"), "");
                        },
                        decoration: InputDecoration(
                            hintText: 'Name of your city',
                            hintStyle: TextStyle(color: Colors.black),
                            suffixIcon: GestureDetector(
                              onTap: () {
                                _fetchWeatherWithCity();
                              },
                              child: Icon(
                                Icons.search,
                                color: Colors.black,
                                size: 16,
                              ),
                            )),
                      ),
                    ),
                    WeatherWidget(
                      weather: weatherState.weather,
                    )
                  ],
                );
              } else if (weatherState is WeatherLoading) {
                return CircularProgressIndicator();
              } else {
                String errorText = 'There was an error fetching weather data';
                if (weatherState is WeatherError) {
                  if (weatherState.errorCode == 404) {
                    errorText =
                        'We have trouble fetching weather for $_cityName';
                  }
                }
                return Column(
                  children: <Widget>[
                    Text(errorText),
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/home');
                      },
                    )
                  ],
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
