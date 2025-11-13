import 'package:flutter/material.dart';
import 'package:lapor_balongmojo/providers/auth_provider.dart';
import 'package:lapor_balongmojo/screens/masyarakat/form_laporan_screen.dart';
import 'package:lapor_balongmojo/screens/masyarakat/riwayat_laporan_screen.dart';
import 'package:lapor_balongmojo/services/api_service.dart'; 
import 'package:lapor_balongmojo/models/berita_model.dart'; 
import 'package:provider/provider.dart';

class HomeScreenMasyarakat extends StatefulWidget {
  static const routeName = '/home-masyarakat';
  const HomeScreenMasyarakat({Key? key}) : super(key: key);

  @override
  State<HomeScreenMasyarakat> createState() => _HomeScreenMasyarakatState();
}

class _HomeScreenMasyarakatState extends State<HomeScreenMasyarakat> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const BeritaPage(),
    RiwayatLaporanScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lapor Balongmojo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Provider.of<AuthProvider>(context, listen: false).logout();
            },
          )
        ],
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => FormLaporanScreen()),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Riwayat Laporan',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

class BeritaPage extends StatefulWidget {
  const BeritaPage({Key? key}) : super(key: key);

  @override
  State<BeritaPage> createState() => _BeritaPageState();
}

class _BeritaPageState extends State<BeritaPage> {
  late Future<List<BeritaModel>> _beritaFuture;
  final ApiService _apiService = ApiService(); 

  @override
  void initState() {
    super.initState();
    _beritaFuture = _apiService.getBerita();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BeritaModel>>(
      future: _beritaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Belum ada berita.'));
        }

        final beritaList = snapshot.data!;
        return ListView.builder(
          itemCount: beritaList.length,
          itemBuilder: (ctx, index) {
            final berita = beritaList[index];
            final String isiSingkat = berita.isi.length > 50
                ? '${berita.isi.substring(0, 50)}...'
                : berita.isi;
            return Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                title: Text(berita.judul, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('Oleh: ${berita.authorName ?? 'Admin'}\n$isiSingkat'),
                isThreeLine: true,
                onTap: () {
                  // TODO: Buat halaman detail berita
                },
              ),
            );
          },
        );
      },
    );
  }
}