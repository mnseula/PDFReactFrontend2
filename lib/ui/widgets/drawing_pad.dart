import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class DrawingPad extends StatelessWidget {
  final Function(Uint8List) onSignatureComplete;
  
  const DrawingPad({
    super.key,
    required this.onSignatureComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: SfSignaturePad(
        backgroundColor: Colors.white,
      ),
    );
  }
}
