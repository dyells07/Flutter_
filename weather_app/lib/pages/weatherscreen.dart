import 'dart:convert';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/pages/additional_info_item.dart';
import 'package:weather_app/utilis/apikey.dart';
import 'package:weather_app/pages/hourly_forecast_item.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';


class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  Future<Map<String, dynamic>>? weather;
  late LatLng _currentLocation;
  MapController _mapController = MapController();

  String cityName = 'Searching...';

  @override
  void initState() {
    super.initState();
    _initWeather();
  }

  Future<void> _initWeather() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      bool isLocationServiceEnabled =
          await Geolocator.isLocationServiceEnabled();
      if (!isLocationServiceEnabled) {
        _showServiceDisabledDialog();
        return;
      }
      _updateWeather();
    } else {
      _showPermissionDialog(permission == LocationPermission.deniedForever);
    }
  }

  Future<void> _updateWeather() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          cityName = placemarks.first.locality ?? 'Unknown Location';
           _currentLocation = LatLng(position.latitude, position.longitude);
        });
      }
      weather = getCurrentWeather();
    } catch (e) {
      log('Failed to get location: ${e.toString()}');
      setState(() {
        cityName = 'Location Unavailable';
      });
    }
  }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final response = await http.get(Uri.parse(
        // 'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$openWeatherAPIKey&units=metric'),
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&appid=$openWeatherAPIKey&units=metric',
      ));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            'Failed to load weather data with status code: ${response.statusCode}');
      }
    } catch (e) {
      log('Error fetching weather data: ${e.toString()}');
      throw Exception('Failed to load weather data: ${e.toString()}');
    }
  }

  void _showServiceDisabledDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Location Service Disabled"),
        content: const Text(
            "Location services are turned off. Please enable them in your device settings to allow the app to access your location."),
        actions: <Widget>[
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () {
              // Open location settings for the user to enable location services
              Geolocator.openLocationSettings();
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog(bool deniedForever) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("Location Permission Needed"),
        content: Text(deniedForever
            ? "Location permission was denied forever. Please open app settings to grant permission."
            : "This app needs location permission to function properly. Please grant it."),
        actions: <Widget>[
          TextButton(
            child: const Text("Open Settings"),
            onPressed: () {
              Geolocator.openAppSettings();
              Navigator.of(context).pop();
            },
          ),
          if (!deniedForever)
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/transparent.png',
          height: 80,
          width: 80,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _initWeather,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: weather,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final currentWeather = snapshot.data!;
            final currentWeatherData = currentWeather['list'][0];

            final currentTemp = currentWeatherData['main']['temp'].toString();
            String fullDescription =
                currentWeatherData['weather'][0]['description'].toString();
            String firstLetter = fullDescription.substring(0, 1).toUpperCase();
            String restOfDescription = fullDescription.substring(1);
            String description = firstLetter + restOfDescription;

            final currentSky =
                currentWeatherData['weather'][0]['main'].toString();
            final currentPressure =
                currentWeatherData['main']['pressure'].toString();
            final currentWindSpeed =
                currentWeatherData['wind']['speed'].toString();
            final currentHumidity =
                currentWeatherData['main']['humidity'].toString();

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 10,
                            sigmaY: 10,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  '$currentTemp °C',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Icon(
                                  currentSky == 'Clear'
                                      ? Icons.wb_sunny
                                      : currentSky == 'Clouds'
                                          ? Icons.cloud
                                          : currentSky == 'Rain'
                                              ? Icons.grain
                                              : currentSky == 'Thunderstorm'
                                                  ? Icons.flash_on
                                                  : currentSky == 'Snow'
                                                      ? Icons.ac_unit
                                                      : currentSky == 'Mist' ||
                                                              currentSky ==
                                                                  'Smoke' ||
                                                              currentSky ==
                                                                  'Haze' ||
                                                              currentSky ==
                                                                  'Dust' ||
                                                              currentSky ==
                                                                  'Fog' ||
                                                              currentSky ==
                                                                  'Sand' ||
                                                              currentSky ==
                                                                  'Ash'
                                                          ? Icons.filter_drama
                                                          : currentSky ==
                                                                      'Squall' ||
                                                                  currentSky ==
                                                                      'Tornado'
                                                              ? Icons.cyclone
                                                              : Icons.error,
                                  size: 64,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  description,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Hourly Forecast',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast =
                            currentWeather['list'][index + 1];
                        final hourlySky = currentWeather['list'][index + 1]
                            ['weather'][0]['main'];
                        final hourlyTemp =
                            hourlyForecast['main']['temp'].toString();
                        final time = DateTime.parse(hourlyForecast['dt_txt']);
                        return HourlyForecastItem(
                          time: DateFormat.j().format(time),
                          temperature: '$hourlyTemp °C',
                          icon: hourlySky == 'Clouds' || hourlySky == 'Rain'
                              ? Icons.cloud
                              : Icons.sunny,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      AdditionalInfoItem(
                        icon: Icons.water_drop,
                        label: 'Humidity',
                        value: currentHumidity.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.air,
                        label: 'Wind Speed',
                        value: currentWindSpeed.toString(),
                      ),
                      AdditionalInfoItem(
                        icon: Icons.beach_access,
                        label: 'Pressure',
                        value: currentPressure.toString(),
                      ),
                    ],
                  ),
                  const Text(
                    'Additional Information',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 30, // Specify the desired height
                        width: 30, // Specify the desired width
                        child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: _currentLocation ?? LatLng(28.2333, 83.9833),
          zoom: 14.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: _currentLocation != null
                ? [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentLocation,
                      builder: (ctx) => Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 50.0,
                      ),
                    ),
                  ]
                : [],
          ),
        ],
      ),
    ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }

          return const Center(child: Text('No weather data available'));
        },
      ),
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Weather in $cityName',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
