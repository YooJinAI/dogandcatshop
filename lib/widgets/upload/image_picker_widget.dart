import 'package:flutter/material.dart';
import 'dart:io';

class ImagePickerWidget extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;

  const ImagePickerWidget({
    super.key,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.add_photo_alternate,
                  size: 50,
                  color: Colors.grey,
                ),
        ),
      ),
    );
  }
}
