import 'package:digita_mobile/helper/db_helper.dart';
import 'package:digita_mobile/models/notification_model.dart';
import 'package:digita_mobile/presentation/common_widgets/cards/notification_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationMahasiswaScreen extends StatefulWidget {
  const NotificationMahasiswaScreen({super.key});

  @override
  State<NotificationMahasiswaScreen> createState() =>
      _NotificationMahasiswaScreenState();
}

class _NotificationMahasiswaScreenState
    extends State<NotificationMahasiswaScreen> {
  late Future<List<NotificationModel>> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = DBHelper.instance.getNotifications();
  }

  Map<String, List<NotificationModel>> _groupNotifications(
    List<NotificationModel> notifications,
  ) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    final Map<String, List<NotificationModel>> grouped = {
      'Hari Ini': [],
      'Kemarin': [],
      'Sebelumnya': [],
    };

    for (var notif in notifications) {
      final receivedAt = notif.receivedAt;
      final notifDate = DateTime(
        receivedAt.year,
        receivedAt.month,
        receivedAt.day,
      );

      if (notifDate == today) {
        grouped['Hari Ini']!.add(notif);
      } else if (notifDate == yesterday) {
        grouped['Kemarin']!.add(notif);
      } else {
        grouped['Sebelumnya']!.add(notif);
      }
    }

    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifikasi',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Skeletonizer(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, builder) {
                  return NotificationCard(
                    title: 'notification title',
                    message: 'notification',
                    isRead: true,
                    onTap: () {},
                  );
                },
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text("Tidak ada notifikasi", style: GoogleFonts.poppins()),
            );
          }

          final items = snapshot.data!;
          final grouped = _groupNotifications(items);

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: ListView(
              children:
                  grouped.entries.where((entry) => entry.value.isNotEmpty).map((
                    entry,
                  ) {
                    final title = entry.key;
                    final notifs = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(
                            context,
                          ).textTheme.titleSmall!.copyWith(fontSize: 16),
                        ),
                        ...notifs.map(
                          (notif) => NotificationCard(
                            title: notif.title,
                            message: notif.body,
                            isRead: notif.isRead,
                            onTap: () async {
                              await DBHelper.instance.markAsReadNotification(
                                notif.id,
                              );
                              setState(() {
                                _notifications =
                                    DBHelper.instance.getNotifications();
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  }).toList(),
            ),
          );
        },
      ),
    );
  }
}
