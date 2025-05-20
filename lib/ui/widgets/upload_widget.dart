import 'package:flutter/material.dart';

class UploadWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const UploadWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: const Text('Upload Document'),
    );
  }
}