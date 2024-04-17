import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_form_app/camera_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyForm extends StatefulWidget {
  const MyForm({super.key});

  @override
  MyFormState createState() {
    return MyFormState();
  }
}

class MyFormState extends State<MyForm> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cameraNameController = TextEditingController();
  final _streamingUrlController = TextEditingController();
  String _cameraDirection = 'East';

  final _formKey = GlobalKey<FormState>();
  final _directions = [
    'East',
    'West',
    'North-East',
    'North-West',
    'South-East',
    'South-West',
    'North',
    'South'
  ];
  String _location = '';
  final TextEditingController _locationController = TextEditingController();

  Future<void> _submitForm() async {
    List<String> coordinates = _locationController.text.split(',');
    double latitude = double.parse(coordinates[0]);
    double longitude = double.parse(coordinates[1]);
    print('Latitude: $latitude');
    print('Longitude: $longitude');

    final response = await http.post(
      Uri.parse('https://renegan-inc-backend.onrender.com/cameras'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'latitude': latitude,
        'longitude': longitude,
        'ownerName': _nameController.text,
        'contactNumber': _phoneController.text,
        'address': _addressController.text,
        'cameraModel': _cameraNameController.text,
        'streamingUrl': _streamingUrlController.text,
        'cameraDirection': _cameraDirection,
        'email': 'dd.10.2002@gma.com',
        'cameraId': '7631283129gds1324dj',
      }),
    );

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraListPage()),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CameraListPage()),
      );
      throw Exception('Failed to submit data');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLocation();
    });
  }

  void _fetchLocation() async {
    // Request location permission
    PermissionStatus permissionStatus = await Permission.location.request();

    // Only fetch the location if permission was granted
    if (permissionStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _location = '${position.latitude}, ${position.longitude}';
        _locationController.text = _location;
      });
    } else {
      // Handle the case when permission is not granted
      print('Location permission not granted');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera Registration Form',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
            textAlign: TextAlign.center),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: _nameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Phone'),
                  controller: _phoneController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  controller: _addressController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Location'),

                  // initialValue: _location,
                  enabled: false,
                  controller: _locationController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Camera Name'),
                  controller: _cameraNameController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the camera name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Streaming URL'),
                  controller: _streamingUrlController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the streaming URL';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField(
                  onChanged: (value) {
                    setState(() {
                      _cameraDirection = value.toString();
                    });
                  },
                  decoration:
                      const InputDecoration(labelText: 'Camera Direction'),
                  value: _cameraDirection,
                  items: _directions.map((direction) {
                    return DropdownMenuItem(
                      value: direction,
                      child: Text(direction),
                    );
                  }).toList(),
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a direction';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _submitForm();
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')));
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
