import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileSection extends StatefulWidget {
  final String name;
  final String status;
  final Widget page;

  const ProfileSection({
    super.key,
    required this.name,
    required this.status,
    required this.page,
  });

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Row(
            children: [
              const CircleAvatar(
                  radius: 28, child: Icon(Icons.person, size: 28)),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.status,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          child: Badge(
            alignment: Alignment.topRight,
            offset: const Offset(-6, 8),
            label: const Text(''),
            largeSize: 16,
            smallSize: 12,
            child: IconButton(
              icon: const Icon(CupertinoIcons.bell_fill),
              iconSize: 28,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => widget.page,
                  ),
                );
              },
              color: Theme
                  .of(context)
                  .colorScheme
                  .primary,
            ),
          ),
        ),
      ],
    );
  }
}