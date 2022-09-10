import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PostImageScreen extends StatelessWidget {
   String? image;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Hero(
        tag: image!,
        child: PhotoView(
            imageProvider: NetworkImage(image!),

        ),
      ),
    );
  }

   PostImageScreen({
    this.image,
  });
}
