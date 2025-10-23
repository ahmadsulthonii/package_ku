import 'package:flutter/material.dart';
import 'package:package_ku/image_display.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

// ini komentar baru
class _MainPageState extends State<MainPage> {
  final List<Map<String, dynamic>> package = [
    {
      'title': 'Date time',
      'image': 'assets/images/date_time.png',
      'route': '/dateTime',
    },
    {
      'title': 'Flutter webview',
      'image': 'assets/images/flutter_webview.png',
      'route': '/webview',
    },
    {
      'title': 'Geolocation',
      'image': 'assets/images/geolocation.png',
      'route': '/geolocation',
    },
    {
      'title': 'Share Preference',
      'image': 'assets/images/shared_preference.png',
      'route': '/sharePreference',
    },
    {
      'title': 'Permition Handler',
      'image': 'assets/images/permition.png',
      'route': '/permitionHandler',
    },
    {
      'title': 'Qr code scaner',
      'image': 'assets/images/qr_code_scaner.png',
      'route': '/qrCode',
    },
    {
      'title': 'Image picker',
      'image': 'assets/images/image_picker.png',
      'route': '/imagePicker',
    },
    {
      'title': 'Image Resize',
      'image': 'assets/images/image_resize.png',
      'route': '/imageResize',
    },
    {
      'title': 'Image crop',
      'image': 'assets/images/image_crop.png',
      'route': '/imageCrop',
    },
    {
      'title': 'Image to Base 64',
      'image': 'assets/images/image_to_base64.png',
      'route': '/imageToBase64',
    },
    {
      'title': 'Convert to excel',
      'image': 'assets/images/export_excel.jpg',
      'route': '/excel',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text('Packageku')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Action
                const SizedBox(height: 10),
                GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 10,
                    childAspectRatio: screenWidth / (screenHight * 0.4),
                  ),
                  itemCount: package.length,
                  itemBuilder: (context, index) {
                    final item = package[index];
                    return InkWell(
                      // Tap → pindah halaman
                      onTap: () {
                        Navigator.pushNamed(context, item['route']!);
                      },

                      // Child tetap ActionCard, dibungkus Hero
                      child: ImageDisplay(
                        title: item['title']!,
                        imagepath: item['image']!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
