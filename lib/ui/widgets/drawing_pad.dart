import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class DrawingPad extends StatefulWidget {
  final Function(Uint8List) onSignatureComplete;

  const DrawingPad({
    super.key,
    required this.onSignatureComplete,
  });

  @override
  State<DrawingPad> createState() => _DrawingPadState();
}

class _DrawingPadState extends State<DrawingPad> {
  // Fixed: Made GlobalKey const for web compatibility
  static const _signaturePadKey = GlobalKey<SfSignaturePadState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
          ),
          child: SfSignaturePad(
            key: _signaturePadKey,
            backgroundColor: Colors.white,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                _signaturePadKey.currentState?.clear();
              },
              child: const Text('Clear'),
            ),
            TextButton(
              onPressed: () async {
                final image = await _signaturePadKey.currentState?.toImage();
                final byteData = await image?.toByteData(format: ui.ImageByteFormat.png);
                if (byteData != null) {
                  widget.onSignatureComplete(byteData.buffer.asUint8List());
                }
              },
              child: const Text('Done'),
            ),
          ],
        ),
      ],
    );
  }
}