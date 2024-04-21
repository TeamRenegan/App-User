import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

// Models
class Post {
  final String title;
  final String description;
  final File image;
  final String userName;

  Post({
    required this.title,
    required this.description,
    required this.image,
    required this.userName,
  });

  // Method to convert Post object to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'name': userName,
      'image': image
    };
  }
}

// Widgets
class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
              // children: [
              //   CircleAvatar(
              //     backgroundImage: NetworkImage(post.userProfilePicUrl),
              //   ),
              //   const SizedBox(width: 8.0),
              //   Text(post.userName),
              // ],
              ),
          // const SizedBox(height: 8.0),
          // Text(
          //   post.title,
          //   style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          // ),
          // const SizedBox(height: 4.0),
          // Text(post.description),
          // const SizedBox(height: 8.0),
          // Image.network(post.image),
        ],
      ),
    );
  }
}

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({Key? key}) : super(key: key);

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();

  String title = "";
  String description = "";
  File? image;
  String userName = "";

  // Endpoint to send the post data
  final String postEndpoint = 'https://renegan-inc-backend.onrender.com/posts';


  Future<void> sendPostData(Post post) async {
    var postUri = Uri.parse(postEndpoint);
    var request = http.MultipartRequest("POST", postUri);

    var file = await http.MultipartFile.fromPath(
      'image',
      post.image.path,
      filename: path.basename(post.image.path),
      contentType: MediaType.parse(lookupMimeType(post.image.path)!),
    );

    request.fields['title'] = post.title;
    request.fields['description'] = post.description;
    request.fields['name'] = post.userName;
    request.files.add(file);

    request.send().then((response) {
      if (response.statusCode == 200)
        print("Uploaded!");
      else {
        print('Upload failed with status: ${response.statusCode}.');
        response.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });
      }
    });
  }

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (newValue) => userName = newValue!,
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (newValue) => title = newValue!,
                ),
                const SizedBox(height: 16.0), 
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                  onSaved: (newValue) => description = newValue!,
                ),
                const SizedBox(height: 16.0), 
                ElevatedButton(
                  onPressed: () => _pickImage(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    image == null ? 'Pick Image' : 'Image Picked',
                    style: TextStyle(
                        color: Colors.white), 
                  ),
                ),
                const SizedBox(height: 32.0), 
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Create Post object
                      final newPost = Post(
                        title: title,
                        description: description,
                        image: image!, // Image URL will be updated after upload
                        userName: userName,
                      );
                      // Send post data
                      sendPostData(newPost);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(8.0), 
                    ),
                  ),
                  child: const Text(
                    'Create Post',
                    style: TextStyle(
                        color: Colors.white), 
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
