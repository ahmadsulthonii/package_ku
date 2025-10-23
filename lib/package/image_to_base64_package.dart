import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageToBase64Package extends StatefulWidget {
  const ImageToBase64Package({super.key});

  @override
  State<ImageToBase64Package> createState() => _ImageToBase64PackageState();
}

class _ImageToBase64PackageState extends State<ImageToBase64Package> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _base64String;

  // 📸 Ambil gambar dari galeri atau kamera
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    setState(() {
      _imageFile = File(pickedFile.path);
    });

    // 📤 Convert ke Base64
    final bytes = await File(pickedFile.path).readAsBytes();
    final base64 = base64Encode(bytes);

    setState(() {
      _base64String = base64;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image to Base64')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_imageFile != null)
                Image.file(
                  _imageFile!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: const Icon(Icons.photo),
                label: const Text('Pilih dari Galeri'),
                onPressed: () => _pickImage(ImageSource.gallery),
              ),
              const SizedBox(height: 10),
              ElevatedButton.icon(
                icon: const Icon(Icons.camera_alt),
                label: const Text('Ambil dari Kamera'),
                onPressed: () => _pickImage(ImageSource.camera),
              ),
              const SizedBox(height: 20),
              if (_base64String != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      _base64String!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
