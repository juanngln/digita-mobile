import 'package:flutter/material.dart';

class Subtitle extends StatelessWidget {
  final String subtitle;
  
  const Subtitle({super.key, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          subtitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          child: Container(
            height: 6,
            margin: const EdgeInsets.only(left: 8.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ],
    );
  }
}
