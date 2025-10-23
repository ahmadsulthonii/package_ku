import 'package:flutter/material.dart';

class NotificationLocalPackage extends StatefulWidget {
  const NotificationLocalPackage({super.key});

  @override
  State<NotificationLocalPackage> createState() =>
      _NotificationLocalPackageState();
}

class _NotificationLocalPackageState extends State<NotificationLocalPackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Local Notofication')));
  }
}
