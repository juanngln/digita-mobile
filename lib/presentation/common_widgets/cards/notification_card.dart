import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:badges/badges.dart' as badges;

class NotificationCard extends StatefulWidget {
  final String title;
  final String message;
  final bool isRead;
  final VoidCallback onTap;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.isRead,
    required this.onTap,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: badges.Badge(
        showBadge: !widget.isRead,
        position: badges.BadgePosition.topEnd(top: 8, end: 1),
        badgeStyle: badges.BadgeStyle(
          badgeColor: Colors.red,
          elevation: 0,
          padding: EdgeInsets.all(6.0),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width - 48,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                spreadRadius: 0,
                blurRadius: 4,
                offset: Offset(0, 4),
                color: Colors.black.withAlpha(50),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.bodyLarge),
              Text(
                widget.message,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
