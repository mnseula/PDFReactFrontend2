import 'package:flutter/material.dart';

class ToolSelector extends StatelessWidget {
  final Function(String) onToolSelected;
  
  const ToolSelector({
    super.key,
    required this.onToolSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => onToolSelected('signature'),
          icon: const Icon(Icons.draw),
        ),
        IconButton(
          onPressed: () => onToolSelected('text'),
          icon: const Icon(Icons.text_fields),
        ),
      ],
    );
  }
}