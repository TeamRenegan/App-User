import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:my_form_app/camera_details.dart';

class CameraListPage extends StatefulWidget {
  const CameraListPage({Key? key});
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
      setState(() {
        _cameras = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to fetch cameras');
    }
  }

  void _redirectToStream(String camID) {
    // Navigate to a new page passing the streamingUrl as an argument
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CameraDetails(
                camId: camID,
              )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cameras List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: _cameras.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'No cameras found',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Image.network(
                    'https://img.freepik.com/free-vector/hand-drawn-no-data-concept_52683-127823.jpg?w=1800&t=st%3D1712379896~exp%3D1712380496~hmac%3Daf5da5c4d47899e8db1697268e26edc3339c98ee95faea31094734a6ae5741bc',
                    width: 200,
                    height: 200,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _cameras.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _redirectToStream(_cameras[index]['_id']);
                  },
                  child: Card(
                    elevation: 4,
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      title: Text(
                        _cameras[index]['cameraModel'],
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        _cameras[index]['streamingUrl'],
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// class StreamPage extends StatelessWidget {
//   final String streamingUrl;

//   StreamPage(this.streamingUrl);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Streaming'),
//       ),
//       body: Center(
//         child: Text(streamingUrl),
//       ),
//     );
//   }
// }
