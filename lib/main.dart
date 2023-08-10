import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class WeatherData {
  final String cityName;
  final double temperature;
  final String description;

  WeatherData({
    required this.cityName,
    required this.temperature,
    required this.description,
  });
}

class WeatherApi {
  static const apiKey = 'b91c13842acf540d4c3089f6bc747ec2';
  static const baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  static Future<WeatherData> fetchWeather(String city) async {
    final url = '$baseUrl?q=$city&appid=$apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return WeatherData(
        cityName: data['name'],
        temperature: data['main']['temp'],
        description: data['weather'][0]['description'],
      );
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WeatherData? _weatherData;
  final TextEditingController _cityController = TextEditingController();

  void _fetchWeatherData() async {
    final cityName = _cityController.text;
    final weatherData = await WeatherApi.fetchWeather(cityName);
    setState(() {
      _weatherData = weatherData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aplikasi Cuaca',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Aplikasi Cuaca'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'Masukkan Kota'),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchWeatherData,
                child: Text('Cek Cuaca'),
              ),
              SizedBox(height: 20),
              if (_weatherData != null)
                Column(
                  children: <Widget>[
                    Text('Kota: ${_weatherData!.cityName}'),
                    Text('Temperatur: ${_weatherData!.temperature}°C'),
                    Text('Deskripsi: ${_weatherData!.description}'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
