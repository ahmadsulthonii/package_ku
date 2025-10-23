import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:package_ku/package/ukuran.dart';
import 'package:path_provider/path_provider.dart';

class ImageCropPackage extends StatefulWidget {
  const ImageCropPackage({super.key});

  @override
  State<ImageCropPackage> createState() => _ImageCropPackageState();
}

class _ImageCropPackageState extends State<ImageCropPackage> {
  final ImagePicker _picker = ImagePicker();
  CroppedFile? _croppedFile;
  String? _savedPath;

  // Ambil gambar dari kamera atau galeri
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile == null) return;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      // Setting cropper
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 90,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Potong Gambar',
          toolbarColor: Colors.deepPurple,
          toolbarWidgetColor: Colors.white,
          activeControlsWidgetColor: Colors.deepPurple,
          lockAspectRatio: false,
          initAspectRatio: CropAspectRatioPreset.original,
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9,
          ],
          cropStyle: CropStyle.rectangle,
        ),
        IOSUiSettings(title: 'Potong Gambar', aspectRatioLockEnabled: false),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _croppedFile = croppedFile;
      });
      await _saveImage(File(croppedFile.path));
    }
  }

  // Simpan hasil crop ke folder aplikasi
  Future<void> _saveImage(File image) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = 'img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await image.copy('${dir.path}/$name');

    if (!mounted) return;

    setState(() => _savedPath = saved.path);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Gambar disimpan di: $_savedPath')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker + Crop + Save')),
      body: Center(
        child: _croppedFile != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    File(_croppedFile!.path),
                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Ukuran file: ${Ukuran.formatImageSizeMB(File(_croppedFile!.path))}',
                    style: const TextStyle(fontSize: 16),
                  ),

                  const SizedBox(height: 5),
                  FutureBuilder<String>(
                    future: Ukuran.getImagePixelSize(File(_croppedFile!.path)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Gagal membaca ukuran pixel');
                      } else if (snapshot.hasData) {
                        return Text(
                          'Ukuran pixel: ${snapshot.data}',
                          style: const TextStyle(fontSize: 16),
                        );
                      } else {
                        return const SizedBox.shrink();
                      }
                    },
                  ),
                ],
              )
            : const Text('Belum ada gambar yang dipilih'),
      ),

      floatingActionButton: Wrap(
        spacing: 10,
        children: [
          FloatingActionButton(
            heroTag: 'camera',
            tooltip: 'Kamera',
            child: const Icon(Icons.camera_alt),
            onPressed: () => _pickImage(ImageSource.camera),
          ),
          FloatingActionButton(
            heroTag: 'gallery',
            tooltip: 'Galeri',
            child: const Icon(Icons.photo),
            onPressed: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }
}
