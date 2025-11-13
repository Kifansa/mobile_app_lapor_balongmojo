import 'package:flutter/material.dart';
import 'package:lapor_balongmojo/providers/laporan_provider.dart';
import 'package:lapor_balongmojo/widgets/custom_textfield.dart';
import 'package:lapor_balongmojo/widgets/primary_button.dart';
import 'package:provider/provider.dart';

class FormLaporanScreen extends StatefulWidget {
  const FormLaporanScreen({Key? key}) : super(key: key);

  @override
  State<FormLaporanScreen> createState() => _FormLaporanScreenState();
}

class _FormLaporanScreenState extends State<FormLaporanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitLaporan() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() { _isLoading = true; });

    try {
      await Provider.of<LaporanProvider>(context, listen: false)
          .addLaporan(_judulController.text, _deskripsiController.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Laporan berhasil dikirim!'))
      );
      Navigator.of(context).pop(); 

    } catch (e) {
       ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengirim laporan: $e'))
      );
    }
    
    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Laporan Baru')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _judulController,
                labelText: 'Judul Laporan',
                icon: Icons.title,
                validator: (val) => val!.isEmpty ? 'Judul wajib diisi' : null,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: _deskripsiController,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi Lengkap',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 5,
                  validator: (val) => val!.isEmpty ? 'Deskripsi wajib diisi' : null,
                ),
              ),
              // TODO: Tambahkan field untuk upload foto di sini
              const SizedBox(height: 24),
              PrimaryButton(
                text: 'KIRIM LAPORAN',
                onPressed: _submitLaporan,
                isLoading: _isLoading,
              )
            ],
          ),
        ),
      ),
    );
  }
}