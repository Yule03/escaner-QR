import 'package:flutter/material.dart';
import 'services/qr_service.dart';
import 'screens/scanner_screen.dart';
import 'screens/historial_screen.dart';
import 'screens/generar_qr_screen.dart';

void main() {
  runApp(const QRScanApp());
}

class QRScanApp extends StatefulWidget {
  const QRScanApp({super.key});

  @override
  State<QRScanApp> createState() => _QRScanAppState();
}

class _QRScanAppState extends State<QRScanApp> {
  final QRService _service = QRService();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _service.temaOscuro,
      builder: (context, esOscuro, _) {
        return MaterialApp(
          title: 'Escáner QR',
          debugShowCheckedModeBanner: false,
          themeMode: esOscuro ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF39A900),
              brightness: Brightness.light,
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF39A900),
              brightness: Brightness.dark,
            ),
            useMaterial3: true,
          ),
          home: HomeScreen(service: _service),
        );
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  final QRService service;
  const HomeScreen({super.key, required this.service});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _paginaActual = 0;

  @override
  Widget build(BuildContext context) {
    final paginas = [
      ScannerScreen(service: widget.service),
      HistorialScreen(service: widget.service),
      const GenerarQRScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Escáner QR',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF39A900),
        foregroundColor: Colors.white,
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: widget.service.temaOscuro,
            builder: (context, esOscuro, _) {
              return IconButton(
                icon: Icon(esOscuro ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => widget.service.alternarTema(),
              );
            },
          ),
        ],
      ),
      body: paginas[_paginaActual],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _paginaActual,
        onDestinationSelected: (i) => setState(() => _paginaActual = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Escanear',
          ),
          NavigationDestination(icon: Icon(Icons.history), label: 'Historial'),
          NavigationDestination(icon: Icon(Icons.add_box), label: 'Generar'),
        ],
      ),
    );
  }
}
