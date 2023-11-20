import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/additonal_information_item_widget.dart';
import 'package:weather_app/hourly_forecast_item_widget.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/secrets.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<Map<String, dynamic>> weather;

  Future<Map<String, dynamic>> getCurrentWeather() async {
    const city = 'chennai';
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$openWeatherApiKey'),
      );
      final data = jsonDecode(res.body);
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  void initState() {
    super.initState();
    weather = getCurrentWeather();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.primary,
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                weather = getCurrentWeather();
              });
            },
            icon: Icon(
              Icons.refresh,
              color: colorScheme.onPrimary,
            ),
          )
        ],
        title: Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: colorScheme.onPrimary,
          ),
        ),
      ),
      body: FutureBuilder(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator.adaptive(
                  backgroundColor: colorScheme.onPrimary,
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            }

            final weatherForecast = snapshot.data!['list'] as List;
            final currentWeather = weatherForecast[0];
            final currentTemp = currentWeather['main']['temp'] - 273.15;
            final currentSky = currentWeather['weather'][0]['main'];
            final currentPressure = currentWeather['main']['pressure'];
            final currentHumidity = currentWeather['main']['humidity'];
            final currentWindSpeed = currentWeather['wind']['speed'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Main Card
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      color: colorScheme.primaryContainer,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '${currentTemp.toStringAsFixed(2)}\u00B0C',
                                  style: TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onPrimaryContainer),
                                ),
                                Icon(
                                  currentSky == 'Clouds' || currentSky == 'Rain'
                                      ? Icons.cloud
                                      : Icons.sunny,
                                  size: 64,
                                  color: colorScheme.onPrimaryContainer,
                                ),
                                Text(
                                  '$currentSky',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimary,
                    ),
                  ),

                  const SizedBox(
                    height: 3,
                  ),

                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final weather = weatherForecast[index + 1];
                        final temperature = weather['main']['temp'] - 273.15;
                        final displayIcon = weather['weather'][0]['main'];
                        final time = DateTime.parse(weather['dt_txt']);
                        return HourlyForecastItem(
                          icon: displayIcon == 'Clouds' || displayIcon == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                          time: DateFormat.j().format(time),
                          temperature:
                              '${temperature.toStringAsFixed(2)}\u00B0C',
                        );
                      },
                      itemCount: weatherForecast.length - 1,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  //additional details
                  Text(
                    'Additonal Information',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditonalInformationItem(
                        iconData: Icons.water_drop,
                        itemType: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditonalInformationItem(
                        iconData: Icons.wind_power,
                        itemType: 'Wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditonalInformationItem(
                        iconData: Icons.umbrella,
                        itemType: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
}
