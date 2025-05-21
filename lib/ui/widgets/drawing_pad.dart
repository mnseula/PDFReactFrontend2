import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';
import 'dart:ui' as ui;

class DrawingPad extends StatelessWidget {
  final Function(Uint8List) onSignatureComplete;
  final GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();
  
  const DrawingPad({
    super.key,
    required this.onSignatureComplete,
  });

  Future<void> _handleSave() async {
    final data = await _signaturePadKey.currentState!.toImage();
    final bytes = await data.toByteData(format: ui.ImageByteFormat.png);
    if (bytes != null) {
      onSignatureComplete(bytes.buffer.asUint8List());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: SfSignaturePad(
            key: _signaturePadKey,
            backgroundColor: Colors.white,
            strokeColor: Colors.black,
            minimumStrokeWidth: 1.0,
            maximumStrokeWidth: 4.0,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _signaturePadKey.currentState?.clear(),
              child: const Text('Clear'),
            ),
            ElevatedButton(
              onPressed: _handleSave,
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
