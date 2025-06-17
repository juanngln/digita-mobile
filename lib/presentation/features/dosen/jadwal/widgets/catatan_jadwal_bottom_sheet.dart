import 'package:digita_mobile/presentation/common_widgets/base_bottom_sheet.dart';
import 'package:digita_mobile/presentation/common_widgets/forms/text_area_input_field.dart';
import 'package:digita_mobile/presentation/common_widgets/primary_action_button.dart';
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
    return BaseBottomSheet(
      title: widget.title,
      child: Column(
        children: [
          // Now using the semantically correct TextAreaField widget
          TextAreaField(
            controller: _controller,
            hintText: widget.hintText,
            maxLines: 8,
            fillColor: const Color(0xFFD9EEFF),
          ),
          const SizedBox(height: 24),
          PrimaryActionButton(
            text: widget.buttonText,
            // isLoading: _isSaving, // Example of how to use the loading state
            onPressed: () {
              if (_controller.text.trim().isEmpty) return;

              // If you were saving to a server, you could do:
              // setState(() => _isSaving = true);
              // await someApiCall();
              // setState(() => _isSaving = false);

              widget.onSave(_controller.text.trim());
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}