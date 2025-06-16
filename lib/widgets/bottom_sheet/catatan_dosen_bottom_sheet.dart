import 'package:digita_mobile/widgets/bottom_sheet/base_bottom_sheet.dart';
import 'package:flutter/material.dart';

class CatatanDosenBottomSheet extends StatefulWidget {
  final String title;
  final String hintText;
  final String buttonText;
  final Function(String) onSave;

  const CatatanDosenBottomSheet({
    super.key,
    required this.title,
    required this.hintText,
    this.buttonText = 'SIMPAN',
    required this.onSave,
  });

  @override
  State<CatatanDosenBottomSheet> createState() => _CatatanDosenBottomSheetState();
}

class _CatatanDosenBottomSheetState extends State<CatatanDosenBottomSheet> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Uses the BaseBottomSheet for consistent styling!
    return BaseBottomSheet(
      title: widget.title,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFD9EEFF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _controller,
              maxLines: 4,
              decoration: InputDecoration.collapsed(hintText: widget.hintText),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.trim().isEmpty) return;
                widget.onSave(_controller.text.trim());
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F47AD),
                foregroundColor: Colors.white,
              ),
              child: Text(widget.buttonText),
            ),
          ),
        ],
      ),
    );
  }
}