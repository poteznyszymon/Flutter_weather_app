import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weatherapp/util/colors.dart';
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _cityInput = TextEditingController();
  String valueCity = "Torun";
  int _valueTemp = 11;
  String _valueDesc = "snow";
  int _valueWind = 15;
  int _valueHum = 55;

  @override
  void initState() {
    super.initState();
    _cityInput.text = 'Torun';
    fetchWeather(_cityInput.toString()).then((data) {
      setState(() {
        _valueTemp = data['main']['temp'].round();
        _valueDesc = data['weather'][0]['main'];
        _valueWind = data['wind']['speed'].round();
        _valueHum = data['main']['humidity'];
      });
    });
  }

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final apiKey = '21e43e00a0ae81883781a43d1cd853d4';
    final apiUrl =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric'; // Update with the correct API endpoint

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = json.decode(response.body);
      return data;
    } else {
      // Handle errors
      throw Exception('Failed to load weather data');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CustomColors.background,
      body: Column(
        children: [
          const SizedBox(height: 60),
          TextField(
            style:
                GoogleFonts.bebasNeue(fontSize: 60, color: CustomColors.title),
            controller: _cityInput,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(
                Icons.location_on_outlined,
                size: 60,
                color: CustomColors.title,
              ),
            ),
          ),
          Lottie.asset(_valueDesc == "Thunderstorm"
              ? 'images/thunder.json'
              : _valueDesc == "Drizzle"
                  ? 'images/sun_rain.json'
                  : _valueDesc == 'Rain'
                      ? 'images/sun_rain.json'
                      : _valueDesc == 'Snow'
                          ? 'images/snow_cloud.json'
                          : _valueDesc == 'Clear'
                              ? 'images/sun.json'
                              : _valueDesc == 'Clouds'
                                  ? 'images/cloud_full.json'
                                  : 'images/sun_rain.json'),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 400,
              decoration: BoxDecoration(
                color: CustomColors.tile,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Today, ${DateTime.now().day}${DateTime.now().month}",
                      style: GoogleFonts.bebasNeue(
                          fontSize: 30, color: CustomColors.title),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$_valueTemp°",
                    style: GoogleFonts.bebasNeue(
                        fontSize: 100, color: CustomColors.title),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$_valueDesc",
                    style: GoogleFonts.bebasNeue(
                        fontSize: 30, color: CustomColors.title),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Wind | $_valueWind km/h",
                    style: GoogleFonts.bebasNeue(
                        fontSize: 20, color: CustomColors.title),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "hum | $_valueHum %",
                    style: GoogleFonts.bebasNeue(
                        fontSize: 20, color: CustomColors.title),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Call the fetchWeather function with the current value of _cityInput
          fetchWeather(_cityInput.text).then((data) {
            setState(() {
              _valueTemp = data['main']['temp'].round();
              _valueDesc = data['weather'][0]['main'];
              _valueWind = data['wind']['speed'].round();
              _valueHum = data['main']['humidity'];
            });
          });
        },
        backgroundColor: CustomColors.title,
        elevation: 0,
        child: Icon(
          Icons.refresh,
          color: CustomColors.background,
        ),
      ),
    );
  }
}
