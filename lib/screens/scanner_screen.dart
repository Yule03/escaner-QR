import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_scan_app_v2/models/escaneo_qr.dart';
import 'package:qr_scan_app_v2/services/qr_service.dart';
import 'package:url_launcher/url_launcher.dart';

class ScannerScreen extends StatefulWidget {
  final QRService service;
  const ScannerScreen({super.key, required this.service});
  @override
  State<ScannerScreen> createState() => _ScannerState();
}

class _ScannerState extends State<ScannerScreen> {
  final _ctrl = MobileScannerController();
  String _ultimo = 'Sin escanear';

  void _detectar(BarcodeCapture cap) async {
    final raw = cap.barcodes.first.rawValue;
    if (raw != null && raw != _ultimo) {
      final escaneo = EscaneoQR.fromTexto(raw);
      widget.service.agregar(escaneo);
      setState(() => _ultimo = raw);

      if (escaneo.tipo == TipoQR.url) {
        final uri = Uri.tryParse(raw);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    }
  }

  @override
  Widget build(BuildContext ctx) => Column(
    children: [
      Expanded(
        child: MobileScanner(controller: _ctrl, onDetect: _detectar),
      ),
      Container(
        padding: const EdgeInsets.all(16),
        child: Text(
          'Último: $_ultimo',
          style: const TextStyle(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }
}
