import 'package:flutter/material.dart';

class CameraGalleryPopup extends StatelessWidget {
  final VoidCallback onTapCamera;
  final VoidCallback onTapGallery;

  const CameraGalleryPopup({
    super.key,
    required this.onTapCamera,
    required this.onTapGallery,
  });

  @override
  Widget build(BuildContext context) {
    // Common styles for text
    const TextStyle optionTextStyle = TextStyle(
      color: Color(0xff263238),
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
    );

    // Reusable widget for options
    Widget buildOption({
      required IconData icon,
      required String text,
      required VoidCallback onTap,
    }) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            children: [
              Icon(icon, size: 28.0),
              const SizedBox(width: 12.0),
              Text(text, style: optionTextStyle),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20.0),
          const Text(
            'Choose From:',
            style: TextStyle(
              fontSize: 20.0,
              color: Color(0xff263238),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20.0),
          buildOption(
            icon: Icons.camera_alt,
            text: 'Camera',
            onTap: onTapCamera,
          ),
          const SizedBox(height: 16.0),
          buildOption(
            icon: Icons.photo_library,
            text: 'Gallery',
            onTap: onTapGallery,
          ),
        ],
      ),
    );
  }
}
