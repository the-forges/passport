import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:passport/app/devices.dart';
import 'profile.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  final _pages = const [
    Profile(),
    Devices(),
  ];
  
  _onNavigationBarTap(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _scanQR = "";

  Future<void> scanQR() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      log(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanQR = barcodeScanRes;
    });
  }

  @override
  Widget build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Passport',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Passport'),
          centerTitle: true,
        ),
        body: _pages.elementAt(_selectedIndex),
        floatingActionButton: FloatingActionButton(
          onPressed: scanQR,
          child: const Icon(Icons.qr_code_scanner_rounded),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.computer_rounded), label: 'Devices'),
          ],
          onTap: _onNavigationBarTap,
        ),
      ),
    );
  }
}