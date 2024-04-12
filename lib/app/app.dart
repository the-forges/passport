import 'package:flutter/material.dart';
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
          onPressed: () {},
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