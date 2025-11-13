import 'package:flutter/material.dart';
import 'package:lapor_balongmojo/services/api_service.dart';
import 'package:lapor_balongmojo/widgets/custom_textfield.dart';
import 'package:lapor_balongmojo/widgets/primary_button.dart';

class FormBeritaScreen extends StatefulWidget {
  const FormBeritaScreen({Key? key}) : super(key: key);

  @override
  State<FormBeritaScreen> createState() => _FormBeritaScreenState();
}

class _FormBeritaScreenState extends State<FormBeritaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _judulController = TextEditingController();
  final _isiController = TextEditingController();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  Future<void> _submitBerita() async {
     if (!_formKey.currentState!.validate()) return;
    
    setState(() { _isLoading = true; });

    try {
      await _apiService.postBerita(
        _judulController.text,
        _isiController.text,
      );
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berita berhasil dipublikasikan!'))
      );
      _judulController.clear();
      _isiController.clear();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal publikasi: $e'))
      );
    }
    
    setState(() { _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: _judulController,
              labelText: 'Judul Berita',
              icon: Icons.title,
              validator: (val) => val!.isEmpty ? 'Judul wajib diisi' : null,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextFormField(
                controller: _isiController,
                decoration: InputDecoration(
                  labelText: 'Isi Berita',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 10,
                validator: (val) => val!.isEmpty ? 'Isi wajib diisi' : null,
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              text: 'PUBLIKASIKAN BERITA',
              onPressed: _submitBerita,
              isLoading: _isLoading,
            )
          ],
        ),
      ),
    );
  }
}