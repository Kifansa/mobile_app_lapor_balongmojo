import 'package:flutter/material.dart';
import 'package:lapor_balongmojo/models/laporan_model.dart';
import 'package:lapor_balongmojo/services/api_service.dart';

enum LaporanStatus { initial, loading, loaded, error }

class LaporanProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<LaporanModel> _laporanList = [];
  LaporanStatus _status = LaporanStatus.initial;
  String _errorMessage = '';

  List<LaporanModel> get laporanList => _laporanList;
  LaporanStatus get status => _status;
  String get errorMessage => _errorMessage;

  // Mengambil daftar laporan
  Future<void> fetchLaporan() async {
    _status = LaporanStatus.loading;
    notifyListeners();

    try {
      _laporanList = await _apiService.getLaporan();
      _status = LaporanStatus.loaded;
    } catch (e) {
      _status = LaporanStatus.error;
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  // Menambah laporan baru
  Future<void> addLaporan(String judul, String deskripsi, String? fotoUrl) async {
    try {
      await _apiService.postLaporan(judul, deskripsi, fotoUrl);

      await fetchLaporan();
    } catch (e) {
      rethrow;
    }
  }

  // Update status laporan (oleh Perangkat)
  Future<void> updateStatus(int id, String status) async {
    try {
      await _apiService.updateStatusLaporan(id, status);
      await fetchLaporan();
    } catch (e) {
      rethrow;
    }
  }
}