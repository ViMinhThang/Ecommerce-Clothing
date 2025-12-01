import 'package:flutter/material.dart';

class SizeSearchBar extends StatefulWidget {
  final ValueChanged<String> onChanged;

  const SizeSearchBar({super.key, required this.onChanged});

  @override
  State<SizeSearchBar> createState() => _SizeSearchBarState();
}

class _SizeSearchBarState extends State<SizeSearchBar> {
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
        hintText: 'Search Size...',
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
