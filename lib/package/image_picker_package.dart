import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_ku/package/ukuran.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

class ImagePickerPackage extends StatefulWidget {
  const ImagePickerPackage({super.key});

  @override
  State<ImagePickerPackage> createState() => _ImagePickerPackageState();
}

class _ImagePickerPackageState extends State<ImagePickerPackage> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _savedPath;

  // Fungsi untuk memilih gambar
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });

      await _saveImage(File(pickedFile.path));
    }
  }

  // Fungsi untuk menyimpan gambar ke folder aplikasi
  Future<void> _saveImage(File image) async {
    try {
      // Ambil direktori penyimpanan aplikasi
      final directory = await getApplicationDocumentsDirectory();

      // Buat nama file baru berdasarkan waktu
      final fileName = 'image_${DateTime.now().millisecondsSinceEpoch}.jpg';

      // Path lengkap file tujuan
      final savedImage = await image.copy('${directory.path}/$fileName');

      if (!mounted) return;

      setState(() {
        _savedPath = savedImage.path;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gambar berhasil disimpan di: $_savedPath')),
      );
    } catch (e) {
      debugPrint("Gagal menyimpan gambar: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker & Save')),
      body: Center(
        child: _imageFile != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    _imageFile!,

                    width: 250,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 10),

                  /// Gunakan FutureBuilder untuk menampilkan ukuran pixel gambar
                  FutureBuilder<String>(
                    future: Ukuran.getImagePixelSize(_imageFile!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Text('Gagal membaca ukuran pixel');
                      } else {
                        return Column(
                          children: [
                            Text('Ukuran pixel gambar: ${snapshot.data}'),
                            Text(
                              'Ukuran file: ${Ukuran.formatImageSizeMB(_imageFile!)}',
                            ),
                            Text(
                              _savedPath ?? '',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  if (_savedPath != null)
                    ElevatedButton.icon(
                      icon: const Icon(Icons.folder_open),
                      label: const Text('Buka File'),
                      onPressed: () async {
                        final result = await OpenFilex.open(_savedPath!);
                        if (result.type != ResultType.done && context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Gagal membuka file: ${result.message}',
                              ),
                            ),
                          );
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
