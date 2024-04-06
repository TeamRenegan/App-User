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
      Uri.parse('https://renegan-inc-backend.onrender.com/cameras'),
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
                  Image.network(
                      'https://img.freepik.com/free-vector/hand-drawn-no-data-concept_52683-127823.jpg?w=1800&t=st%3D1712379896~exp%3D1712380496~hmac%3Daf5da5c4d47899e8db1697268e26edc3339c98ee95faea31094734a6ae5741bc'),
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
