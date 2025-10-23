import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePreferencePackage extends StatefulWidget {
  const SharePreferencePackage({super.key});

  @override
  State<SharePreferencePackage> createState() => _SharePreferencePackageState();
}

class _SharePreferencePackageState extends State<SharePreferencePackage> {
  final TextEditingController _nameController = TextEditingController();
  String? _savedName;
  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// 🔹 Ambil data dari SharedPreferences
  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedName = prefs.getString('username');
      _isDarkMode = prefs.getBool('darkmode') ?? false;
    });
  }

  /// 💾 Simpan data ke SharedPreferences
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _nameController.text);
    await prefs.setBool('darkmode', _isDarkMode);
    _loadData(); // refresh UI
  }

  /// ❌ Hapus data dari SharedPreferences
  Future<void> _clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('darkmode');
    setState(() {
      _savedName = null;
      _isDarkMode = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shared Preferences')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Masukkan Nama',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Mode Gelap'),
              value: _isDarkMode,
              onChanged: (value) {
                setState(() => _isDarkMode = value);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _saveData,
              icon: const Icon(Icons.save),
              label: const Text('Simpan Data'),
            ),
            ElevatedButton.icon(
              onPressed: _clearData,
              icon: const Icon(Icons.delete),
              label: const Text('Hapus Data'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
            const SizedBox(height: 20),
            Text(
              _savedName != null
                  ? 'Nama tersimpan: $_savedName\nMode Gelap: $_isDarkMode'
                  : 'Belum ada data tersimpan',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
