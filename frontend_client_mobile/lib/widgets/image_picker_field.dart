import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerField extends StatelessWidget {
  final String? currentImage;
  final XFile? selectedImage;
  final VoidCallback onPickImage;

  const ImagePickerField({
    super.key,
    required this.currentImage,
    required this.selectedImage,
    required this.onPickImage,
  });
  String _fixImageUrl(String url) {
    if (kIsWeb && url.contains("10.0.2.2")) {
      return url.replaceAll("10.0.2.2", "localhost");
    }
    print('Fixed image URL: $url');
    return url;
  }

  @override
  Widget build(BuildContext context) {
    ImageProvider? bgImage;
    if (selectedImage != null) {
      if (kIsWeb) {
        // 🌐 WEB: XFile.path trên Web là một Blob URL -> Dùng NetworkImage
        bgImage = NetworkImage(_fixImageUrl(selectedImage!.path));
      } else {
        // 📱 MOBILE: XFile.path là đường dẫn thật -> Dùng FileImage
        bgImage = FileImage(File(selectedImage!.path));
      }
    } else if (currentImage != null && currentImage!.isNotEmpty) {
      // Ảnh cũ từ server
      bgImage = NetworkImage(_fixImageUrl(currentImage!));
    } else {
      // Ảnh mặc định
      bgImage = const AssetImage('assets/placeholder.png');
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product image',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(image: bgImage, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onPickImage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.upload),
              label: const Text('Choose an image'),
            ),
          ],
        ),
      ],
    );
  }
}
