import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class DrawingPad extends StatelessWidget {
  final Function(Uint8List) onSignatureComplete;
  final GlobalKey<SfSignaturePadState> _signaturePadKey = const GlobalKey();

  const DrawingPad({
    super.key,
    required this.onSignatureComplete,
  });

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
                  onSignatureComplete(byteData.buffer.asUint8List());
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
