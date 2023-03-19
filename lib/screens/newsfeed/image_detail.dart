import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageDetailPage extends StatefulWidget {
  const ImageDetailPage({Key? key}) : super(key: key);

  @override
  State<ImageDetailPage> createState() => _ImageDetailPageState();
}

class _ImageDetailPageState extends State<ImageDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: const Key('key'),
      direction: DismissDirection.vertical,
      onDismissed: (_) => Navigator.of(context).pop(),
      child: Scaffold(
        body: Hero(
          tag: Object(),
          child: PhotoView(
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.contained * 5,
            imageProvider:
                NetworkImage('https://wallpapercave.com/wp/wp5921946.jpg'),
          ),
        ),
      ),
    );
  }
}
