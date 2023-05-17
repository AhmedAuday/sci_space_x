import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:http/http.dart' as http;

class DownloadPhoto extends StatefulWidget {
  const DownloadPhoto({Key? key, required this.img}) : super(key: key);

  final String img;

  @override
  _DownloadPhotoState createState() => _DownloadPhotoState();
}

class _DownloadPhotoState extends State<DownloadPhoto> {
  Future<void> downloadAndSaveImage(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final filePath = await GallerySaver.saveImage(imageUrl);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image downloaded and saved to gallery.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.img,
              imageBuilder: (context, imageProvider) {
                return Image(
                  image: imageProvider,
                  height: 200, // Set a custom size for the image
                );
              },
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            ElevatedButton(
              onPressed: () async {
                await downloadAndSaveImage(widget.img);
              },
              child: const Text("Download"),
            )
          ],
        ),
      ),
    );
  }
}
