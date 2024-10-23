import 'package:flutter/material.dart';

class Pelanggan {
  final String kode;
  final String nama;

  Pelanggan({required this.kode, required this.nama});
}

class PelangganEntryScreen extends StatefulWidget {
  @override
  _PelangganEntryScreenState createState() => _PelangganEntryScreenState();
}

class _PelangganEntryScreenState extends State<PelangganEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _kodeController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();

  @override
  void dispose() {
    _kodeController.dispose();
    _namaController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      Pelanggan pelanggan = Pelanggan(
        kode: _kodeController.text,
        nama: _namaController.text,
      );

      // Navigate to the WarnetScreen, passing Pelanggan object
      Navigator.pushNamed(context, '/warnet', arguments: pelanggan);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Entry Pelanggan")),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu", style: TextStyle(color: Colors.white)),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _kodeController,
                decoration: InputDecoration(labelText: "Kode Pelanggan"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Kode Pelanggan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(labelText: "Nama Pelanggan"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Nama Pelanggan';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
