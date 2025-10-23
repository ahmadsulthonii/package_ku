import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermitionHandlerPackage extends StatefulWidget {
  const PermitionHandlerPackage({super.key});

  @override
  State<PermitionHandlerPackage> createState() =>
      _PermitionHandlerPackageState();
}

class _PermitionHandlerPackageState extends State<PermitionHandlerPackage> {
  String status = 'Belum ada izin diperiksa';

  /// Fungsi untuk meminta izin satu per satu
  Future<void> _requestCameraPermission() async {
    var result = await Permission.camera.request();
    setState(() => status = 'Camera: $result');
  }

  Future<void> _requestLocationPermission() async {
    var result = await Permission.location.request();
    setState(() => status = 'Location: $result');
  }

  Future<void> _requestStoragePermission() async {
    var result = await Permission.storage.request();
    setState(() => status = 'Storage: $result');
  }

  Future<void> _requestNotificationPermission() async {
    var result = await Permission.notification.request();
    setState(() => status = 'Notification: $result');
  }

  /// 🔄 Fungsi untuk meminta semua izin sekaligus
  Future<void> _requestAllPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.storage,
      Permission.location,
      Permission.notification,
    ].request();

    setState(() {
      status = statuses.entries.map((e) => '${e.key}: ${e.value}').join('\n');
    });
  }

  /// 🚪 Arahkan ke setting jika izin ditolak permanen
  Future<void> _openAppSettings() async {
    await openAppSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permission Handler')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              ElevatedButton.icon(
                onPressed: _requestCameraPermission,
                icon: const Icon(Icons.camera_alt),
                label: const Text('Izin Kamera'),
              ),
              ElevatedButton.icon(
                onPressed: _requestLocationPermission,
                icon: const Icon(Icons.location_on),
                label: const Text('Izin Lokasi'),
              ),
              ElevatedButton.icon(
                onPressed: _requestStoragePermission,
                icon: const Icon(Icons.folder),
                label: const Text('Izin Storage'),
              ),
              ElevatedButton.icon(
                onPressed: _requestNotificationPermission,
                icon: const Icon(Icons.notifications),
                label: const Text('Izin Notifikasi'),
              ),
              ElevatedButton.icon(
                onPressed: _requestAllPermissions,
                icon: const Icon(Icons.security),
                label: const Text('Minta Semua Izin'),
              ),
              ElevatedButton.icon(
                onPressed: _openAppSettings,
                icon: const Icon(Icons.settings),
                label: const Text('Buka Pengaturan Aplikasi'),
              ),
              const SizedBox(height: 20),
              Text('Status:\n$status', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}
