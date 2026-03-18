import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenerarQRScreen extends StatefulWidget {
  const GenerarQRScreen({super.key});

  @override
  State<GenerarQRScreen> createState() => _GenerarQRScreenState();
}

class _GenerarQRScreenState extends State<GenerarQRScreen> {
  final _textController = TextEditingController();
  String _qrData = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          TextField(
            controller: _textController,
            decoration: const InputDecoration(
              labelText: 'Texto para el QR',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.edit),
            ),
            onChanged: (value) {
              setState(() {
                _qrData = value;
              });
            },
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Center(
              child: _qrData.isEmpty
                  ? const Text('Ingresa texto para generar un QR')
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        QrImageView(
                          data: _qrData,
                          version: QrVersions.auto,
                          size: 250.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Tu código QR generado',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF39A900),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
