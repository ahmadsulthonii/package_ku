import 'package:flutter/material.dart';

class DioPackage extends StatefulWidget {
  const DioPackage({super.key});

  @override
  State<DioPackage> createState() => _DioPackageState();
}

class _DioPackageState extends State<DioPackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Dio package')));
  }
}
