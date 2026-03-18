import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_scan_app_v2/models/escaneo_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QRService {
  final List<EscaneoQR> _historial = [];
  static const _keyHistorial = 'historial_qr';
  static const _keyTema = 'tema_oscuro';

  final ValueNotifier<bool> temaOscuro = ValueNotifier(false);

  QRService() {
    _cargarDatos();
  }

  List<EscaneoQR> get historial => List.unmodifiable(_historial);
  int get total => _historial.length;

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Cargar historial
    final jsonString = prefs.getString(_keyHistorial);
    if (jsonString != null) {
      final List<dynamic> decoded = json.decode(jsonString);
      _historial.clear();
      _historial.addAll(decoded.map((e) => EscaneoQR.fromJson(e)).toList());
    }

    // Cargar preferencia de tema
    temaOscuro.value = prefs.getBool(_keyTema) ?? false;
  }

  Future<void> _guardarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(_historial.map((e) => e.toJson()).toList());
    await prefs.setString(_keyHistorial, jsonString);
  }

  Future<void> alternarTema() async {
    temaOscuro.value = !temaOscuro.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyTema, temaOscuro.value);
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
