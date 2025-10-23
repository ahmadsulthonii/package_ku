import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeolocationPackage extends StatefulWidget {
  const GeolocationPackage({super.key});

  @override
  State<GeolocationPackage> createState() => _GeolocationPackageState();
}

class _GeolocationPackageState extends State<GeolocationPackage> {
  String locationMessage = "Tekan tombol untuk mendapatkan lokasi";

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Periksa apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationMessage = "Layanan lokasi tidak aktif";
      });
      return;
    }

    // 2. Periksa izin lokasi
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          locationMessage = "Izin lokasi ditolak";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        locationMessage =
            "Izin lokasi ditolak permanen. Aktifkan dari pengaturan.";
      });
      return;
    }

    // 3. Ambil lokasi sekarang

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // update setiap 10 meter
      ),
    ).listen((Position position) {
      if (!mounted) return;

      setState(() {
        locationMessage =
            "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
      });
    });

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // update setiap 10 meter
      ),
    ).listen((Position position) {
      ('${position.latitude}, ${position.longitude}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Geolocation")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(locationMessage, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getCurrentLocation,
              child: const Text("Dapatkan Lokasi Sekarang"),
            ),
            ElevatedButton(
              onPressed: () {
                Geolocator.openLocationSettings();
              },
              child: Text('Buka setting'),
            ),
          ],
        ),
      ),
    );
  }
}
