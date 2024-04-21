import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> _fetchNotifications() async {
    final response = await http.get(
      Uri.parse('https://renegan-inc-backend.onrender.com/posts/title/desc'),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON.
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((notification) => {
                'title': notification['title'],
                'description': notification['description'],
              })
          .toList();
    } else {
      // If the server returns an unexpected response, return default data.
      return [
        {
          'title': 'Default Notification',
          'description': 'No notifications found.',
        }
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While fetching data, show a loading indicator
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If an error occurs during fetching, display an error message
            return Center(
              child: SizedBox(
                width: 362,
                height: 230, 
                child: NotificationCard(
                  title: 'Security Alert: Robbery Incident Reported',
                  description:
                      'Residents are advised to remain vigilant following a recent robbery incident. Please report any suspicious activity to local authorities immediately.',
                ),
              ),
            );
          } else if (snapshot.hasData) {
            // If data is fetched successfully, display the notifications
            final notifications = snapshot.data!;
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: notifications
                      .map(
                        (notification) => SizedBox(
                          width: 300, 
                          child: NotificationCard(
                            title: notification['title']!,
                            description: notification['description']!,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          } else {
            // Display default data when no notifications are available
            return Center(
              child: SizedBox(
                width: 300, 
                child: NotificationCard(
                  title: 'Default Notification',
                  description: 'No notifications found.',
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;

  const NotificationCard({
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }
}
