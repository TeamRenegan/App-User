// Add this import to use the http package
import 'package:http/http.dart' as http;

// Add this import to use the jsonDecode function
import 'dart:convert';
import 'package:flutter/material.dart';

// ...

class CameraListPage extends StatefulWidget {
  @override
  _CameraListPageState createState() => _CameraListPageState();
}

class _CameraListPageState extends State<CameraListPage> {
  List<dynamic> _cameras = [];

  @override
  void initState() {
    super.initState();
    _fetchCameras();
  }

  Future<void> _fetchCameras() async {
    final response = await http.get(
      Uri.parse('https://rh20bk9g-3001.inc1.devtunnels.ms/cameras'), // Replace with your API endpoint
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      setState(() {
        _cameras = jsonDecode(response.body);
      });
    } else {
      // If the server returns an unexpected response, throw an error.
      throw Exception('Failed to fetch cameras');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cameras List'),
      ),
      body: _cameras.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('No cameras found'),
                  Image.network('https://images.pexels.com/photos/45201/kitty-cat-kitten-pet-45201.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500'), // Replace with your sample image URL
                ],
              ),
            )
          : ListView.builder(
              itemCount: _cameras.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_cameras[index]['cameraModel']),
                  subtitle: Text(_cameras[index]['streamingUrl']),
                );
              },
            ),
    );
  }
}