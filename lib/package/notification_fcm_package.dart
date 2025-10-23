import 'package:flutter/material.dart';

class NotificationFcmPackage extends StatefulWidget {
  const NotificationFcmPackage({super.key});

  @override
  State<NotificationFcmPackage> createState() => _NotificationFcmPackageState();
}

class _NotificationFcmPackageState extends State<NotificationFcmPackage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Notification fcm package')));
  }
}
