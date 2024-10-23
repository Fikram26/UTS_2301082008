import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pelanggan.dart';

class Warnet {
  final String kodeTransaksi;
  final String namaPelanggan;
  final String jenisPelanggan;
  final DateTime jamMasuk;
  final DateTime jamKeluar;
  final double tarif;

  Warnet({
    required this.kodeTransaksi,
    required this.namaPelanggan,
    required this.jenisPelanggan,
    required this.jamMasuk,
    required this.jamKeluar,
    required this.tarif,
  });

  // Calculate the duration
  Duration get lama => jamKeluar.difference(jamMasuk);

  // Calculate the discount
  double get diskon {
    if (lama.inHours > 2) {
      if (jenisPelanggan == "VIP") {
        return 0.02 * tarif * lama.inHours;
      } else if (jenisPelanggan == "GOLD") {
        return 0.05 * tarif * lama.inHours;
      }
    }
    return 0;
  }

  // Calculate the total payment
  double get totalBayar => (lama.inHours * tarif) - diskon;
}

class WarnetScreen extends StatefulWidget {
  @override
  _WarnetScreenState createState() => _WarnetScreenState();
}

class _WarnetScreenState extends State<WarnetScreen> {
  final _formKey = GlobalKey<FormState>();
  String _jenisPelanggan = "VIP";
  final TextEditingController _jamMasukController = TextEditingController();
  final TextEditingController _jamKeluarController = TextEditingController();
  final double _tarif = 10000; // Fixed tarif

  @override
  void dispose() {
    _jamMasukController.dispose();
    _jamKeluarController.dispose();
    super.dispose();
  }

  // This function will help to validate and format time input as HH:mm
  DateTime? _parseTime(String input) {
    try {
      if (input.length != 4) return null;
      final hour = int.parse(input.substring(0, 2));
      final minute = int.parse(input.substring(2));
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, hour, minute);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Pelanggan pelanggan = ModalRoute.of(context)!.settings.arguments as Pelanggan;

    return Scaffold(
      appBar: AppBar(title: Text("Warnet Transaction")),
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
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Text("Kode Pelanggan: ${pelanggan.kode}"),
              Text("Nama Pelanggan: ${pelanggan.nama}"),
              DropdownButtonFormField(
                value: _jenisPelanggan,
                items: ['VIP', 'GOLD']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _jenisPelanggan = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Jenis Pelanggan"),
              ),
              TextFormField(
                controller: _jamMasukController,
                decoration: InputDecoration(labelText: "Jam Masuk (HHmm)"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only allow digits
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Jam Masuk';
                  }
                  if (_parseTime(value) == null) {
                    return 'Please enter a valid time in HHmm format';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _jamKeluarController,
                decoration: InputDecoration(labelText: "Jam Keluar (HHmm)"),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Only allow digits
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Jam Keluar';
                  }
                  if (_parseTime(value) == null) {
                    return 'Please enter a valid time in HHmm format';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final jamMasuk = _parseTime(_jamMasukController.text);
                    final jamKeluar = _parseTime(_jamKeluarController.text);

                    if (jamKeluar != null && jamMasuk != null && jamKeluar.isBefore(jamMasuk)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Jam Keluar must be after Jam Masuk')),
                      );
                      return;
                    }

                    Warnet warnet = Warnet(
                      kodeTransaksi: 'T001',
                      namaPelanggan: pelanggan.nama,
                      jenisPelanggan: _jenisPelanggan,
                      jamMasuk: jamMasuk!,
                      jamKeluar: jamKeluar!,
                      tarif: _tarif,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HasilScreen(warnet: warnet),
                      ),
                    );
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HasilScreen extends StatelessWidget {
  final Warnet warnet;

  HasilScreen({required this.warnet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Transaction Result")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Kode Transaksi: ${warnet.kodeTransaksi}"),
            Text("Nama Pelanggan: ${warnet.namaPelanggan}"),
            Text("Jenis Pelanggan: ${warnet.jenisPelanggan}"),
            Text("Jam Masuk: ${warnet.jamMasuk.hour}:${warnet.jamMasuk.minute.toString().padLeft(2, '0')}"),
            Text("Jam Keluar: ${warnet.jamKeluar.hour}:${warnet.jamKeluar.minute.toString().padLeft(2, '0')}"),
            Text("Lama: ${warnet.lama.inHours} Hours"),
            Text("Tarif: Rp. ${warnet.tarif}"),
            Text("Diskon: Rp. ${warnet.diskon.toStringAsFixed(2)}"),
            Text("Total Bayar: Rp. ${warnet.totalBayar.toStringAsFixed(2)}"),
          ],
        ),
      ),
    );
  }
}
