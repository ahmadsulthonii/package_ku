import 'package:flutter/material.dart';
import 'package:package_ku/main_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:package_ku/package/date_time_package.dart';
import 'package:package_ku/package/dio_package.dart';
import 'package:package_ku/package/export_excel_package.dart';
import 'package:package_ku/package/flutter_webview_package.dart';
import 'package:package_ku/package/geolocation_package.dart';
import 'package:package_ku/package/image_crop_package.dart';
import 'package:package_ku/package/image_picker_package.dart';
import 'package:package_ku/package/image_resize_package.dart';
import 'package:package_ku/package/image_to_base64_package.dart';
import 'package:package_ku/package/notification_fcm_package.dart';
import 'package:package_ku/package/notification_local_package.dart';
import 'package:package_ku/package/permition_handler_package.dart';
import 'package:package_ku/package/qr_code_scanner_package.dart';
import 'package:package_ku/package/share_preference_package.dart';
import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  tz.initializeTimeZones();

  runApp(const MyApp());
}

// ini komentar saja

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Package ku',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MainPage(),
      initialRoute: '/',
      routes: {
        '/dateTime': (context) => DateTimePackage(),
        '/dio': (context) => DioPackage(),
        '/excel': (context) => ExportExcelPackage(),
        '/webview': (context) => const FlutterWebviewPackage(
          url: 'https://flutter.dev',
          title: 'Flutter Website',
        ),
        '/geolocation': (context) => GeolocationPackage(),
        '/imageCrop': (context) => ImageCropPackage(),
        '/imagePicker': (context) => ImagePickerPackage(),
        '/imageResize': (context) => ImageResizePackage(),
        '/imageToBase64': (context) => ImageToBase64Package(),
        '/notificationFcm': (context) => NotificationFcmPackage(),
        '/notificationLocal': (context) => NotificationLocalPackage(),
        '/permitionHandler': (context) => PermitionHandlerPackage(),
        '/qrCode': (context) => QrCodeScannerPackage(),
        '/sharePreference': (context) => SharePreferencePackage(),
      },
    );
  }
}
