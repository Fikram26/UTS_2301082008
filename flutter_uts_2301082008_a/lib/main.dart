import 'package:flutter/material.dart';
import 'pelanggan.dart';
import 'warnet.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Warnet Billing System',
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/entry': (context) => PelangganEntryScreen(),
        '/warnet': (context) => WarnetScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Warnet Billing System")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu", style: TextStyle(color: Colors.white)),
            ),
            ListTile(
              title: Text("Pelanggan Entry"),
              onTap: () {
                Navigator.pushNamed(context, '/entry');
              },
            ),
            ListTile(
              title: Text("Warnet Transaction"),
              onTap: () {
                Navigator.pushNamed(context, '/warnet');
              },
            ),
          ],
        ),
      ),
      body: Center(child: Text("Welcome to Warnet Billing System")),
    );
  }
}
