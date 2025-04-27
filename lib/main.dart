import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:navigation_practice/api_key.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  State<WeatherApp> createState() => _WeatherAppState();
}

class _WeatherAppState extends State<WeatherApp> {
  TextEditingController usersCountry = TextEditingController();
  String userCountry = 'London';
  Future<Map<String, dynamic>?> fetchData() async {
    var url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$userCountry&appid=$apiKey');
    try {
      final response = await http.get(url);
      final data = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw Exception('Fail to fetch');
      }
      return data;
    } catch (e) {
      return throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    usersCountry.text;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Weather App',
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  userCountry = 'London';
                  fetchData();
                });
              },
              icon: const Icon(
                Icons.refresh,
                size: 30,
              ),
            ),
          ],
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              //final error = snapshot.error;
              return const Center(
                child: Text('cant fetch'),
              );
            }

            final data = snapshot.data!;
            final currentSky = data['weather'][0]['main'];

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 23),
                  Row(
                    children: [
                      SizedBox(
                        width: 290,
                        child: TextField(
                          controller: usersCountry,
                          decoration: const InputDecoration(
                            hintText: 'Enter Country Name...',
                            filled: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            userCountry = usersCountry.text;
                          });
                        },
                        icon: const Icon(Icons.search),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: [
                            Text(
                              '${data['name']}',
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${data['main']['temp']}k',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 56,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '$currentSky',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
