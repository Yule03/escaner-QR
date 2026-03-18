import 'dart:convert';
import 'package:qr_scan_app_v2/models/escaneo_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRService {
  final List<EscaneoQR> _historial = [];
  static const _key = 'historial_qr';

  QRService() {
    _cargarHistorial();
  }

  List<EscaneoQR> get historial => List.unmodifiable(_historial);
  int get total => _historial.length;

  Future<void> _cargarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString != null) {
      final List<dynamic> decoded = json.decode(jsonString);
      _historial.clear();
      _historial.addAll(decoded.map((e) => EscaneoQR.fromJson(e)).toList());
    }
  }

  Future<void> _guardarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_historial.map((e) => e.toJson()).toList());
    await prefs.setString(_key, jsonString);
  }

  void agregar(EscaneoQR e) {
    _historial.insert(0, e);
    _guardarHistorial();
  }

  void limpiar() {
    _historial.clear();
    _guardarHistorial();
  }
}
