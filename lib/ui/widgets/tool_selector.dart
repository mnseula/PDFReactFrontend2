import 'package:flutter/material.dart';

class ToolSelector extends StatelessWidget {
  final Function(String) onToolSelected;
  final String selectedTool;
  
  const ToolSelector({
    super.key,
    required this.onToolSelected,
    required this.selectedTool,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => onToolSelected('signature'),
          icon: Icon(Icons.draw, 
            color: selectedTool == 'signature' ? Colors.blue : Colors.grey),
        ),
        IconButton(
          onPressed: () => onToolSelected('text'),
          icon: Icon(Icons.text_fields,
            color: selectedTool == 'text' ? Colors.blue : Colors.grey),
        ),
      ],
    );
  }
}