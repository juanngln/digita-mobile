import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  final String text;

  const Subtitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(text, style: Theme.of(context).textTheme.titleMedium),
        Expanded(
          child: Container(
            height: 6,
            margin: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
        ),
      ],
    );
  }
}
