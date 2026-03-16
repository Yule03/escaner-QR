import 'package:flutter/material.dart';
import 'package:qr_scan_app_v2/models/escaneo_qr.dart';
import 'package:qr_scan_app_v2/services/qr_service.dart';

class HistorialScreen extends StatefulWidget {
  final QRService service;
  const HistorialScreen({super.key, required this.service});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  TipoQR? _filtroSeleccionado;

  @override
  Widget build(BuildContext context) {
    final items = widget.service.historial.where((e) {
      if (_filtroSeleccionado == null) return true;
      return e.tipo == _filtroSeleccionado;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Historial (' + items.length.toString() + ')'),
        backgroundColor: const Color(0xFF39A900),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => setState(() {
              widget.service.limpiar();
            }),
          ),
        ],
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Row(
              children: [
                _buildFilterChip(null, 'Todos'),
                const SizedBox(width: 8),
                _buildFilterChip(TipoQR.url, 'URLs'),
                const SizedBox(width: 8),
                _buildFilterChip(TipoQR.wifi, 'WiFi'),
                const SizedBox(width: 8),
                _buildFilterChip(TipoQR.texto, 'Texto'),
              ],
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? const Center(child: Text('Sin escaneos aún'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (ctx, i) {
                      final e = items[i];
                      return ListTile(
                        leading: Icon(
                          _getIconForType(e.tipo),
                          color: const Color(0xFF39A900),
                        ),
                        title: Text(e.contenido, overflow: TextOverflow.ellipsis),
                        subtitle: Text(e.fechaHora.toString().split('.')[0]),
                        trailing: const Icon(Icons.chevron_right),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(TipoQR? tipo, String label) {
    final isSelected = _filtroSeleccionado == tipo;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _filtroSeleccionado = selected ? tipo : null;
        });
      },
      selectedColor: const Color(0xFF39A900).withOpacity(0.3),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF39A900) : Colors.black87,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }

  IconData _getIconForType(TipoQR tipo) {
    switch (tipo) {
      case TipoQR.url:
        return Icons.language;
      case TipoQR.wifi:
        return Icons.wifi;
      case TipoQR.contacto:
        return Icons.contact_page;
      case TipoQR.texto:
      default:
        return Icons.text_snippet;
    }
  }
}
