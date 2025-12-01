import 'package:flutter/material.dart';

class ColorSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const ColorSearchBar({super.key, required this.onChanged});

  @override
  State<ColorSearchBar> createState() => _ColorSearchBarState();
}

class _ColorSearchBarState extends State<ColorSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        hintText: 'Search Color...',
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
    );
  }
}
