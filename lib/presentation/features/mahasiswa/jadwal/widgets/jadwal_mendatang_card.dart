import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UpcomingScheduleCard extends StatefulWidget {
  final String title;
  final String dateTime;
  final String supervisor;
  final String location;
  final String note;

  const UpcomingScheduleCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.supervisor,
    required this.location,
    required this.note,
  });

  @override
  State<UpcomingScheduleCard> createState() => _UpcomingScheduleCard();
}

class _UpcomingScheduleCard extends State<UpcomingScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 40,
      height: 200,
      padding: const EdgeInsets.all(12.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Icon(
                Icons.access_time_filled,
                color: Colors.black,
              ),
              SizedBox(width: 12),
              Text(
                widget.dateTime,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.person, 
                color: Colors.black,
              ),
              SizedBox(width: 12),
              Text(
                widget.supervisor,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.location_on, 
                color: Colors.black,
              ),
              SizedBox(width: 12),
              Text(
                widget.location,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Icon(
                Icons.edit_document, 
                color: Colors.black,
              ),
              SizedBox(width: 12),
              Text(
                'Catatan: ${widget.note}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
