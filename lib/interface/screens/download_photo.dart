import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sci_space_x/core/constants/constants.dart';

import '../widgets/mybutton.dart';
import 'chat_image_view.dart';

class DownloadPhoto extends StatefulWidget {
  const DownloadPhoto({Key? key, required this.img, required User user})
      : _user = user,
        super(key: key);
  final User _user;
  final String img;

  @override
  _DownloadPhotoState createState() => _DownloadPhotoState();
}

class _DownloadPhotoState extends State<DownloadPhoto> {
  late User _user;

  @override
  void initState() {
    _user = widget._user;
    super.initState();
  }

  Future<void> _saveImage(BuildContext context, String imgUrl) async {
    String? message;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    try {
      // Check permission status
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        // Permission not granted, request it
        status = await Permission.storage.request();
        if (!status.isGranted) {
          // Permission denied, show a message or handle the error
          print('Storage permission denied');
          return;
        }
      }

      // Download image
      final http.Response response = await http.get(Uri.parse(imgUrl));

      // Get the download directory
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        throw Exception('Could not access storage directory');
      }

      // Create the image file path
      final filePath = '${directory.path}/image.jpg';

      // Save image to file
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      message = 'Image saved to disk: $filePath';
    } catch (e) {
      message = 'An error occurred while saving the image: $e';
    }

    scaffoldMessenger
        .showSnackBar(SnackBar(content: Text(message ?? 'Unknown error')));
  }

  Route _routeToUserScreenFromr() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ChatImageView(
        user: _user,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.firebaseNavy,
        title: const Text('Images Generator'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(_routeToUserScreenFromr());
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: widget.img,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CustomButton(
                color: CustomColors.firebaseNavy,
                textColor: CustomColors.firebaseOrange,
                text: "Downlad",
                onPressed: () async {
                  await _saveImage(context, widget.img);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
