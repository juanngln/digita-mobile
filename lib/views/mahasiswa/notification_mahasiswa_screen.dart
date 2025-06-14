import 'package:digita_mobile/widgets/card/notification_card.dart';
import 'package:flutter/material.dart';

class NotificationMahasiswaScreen extends StatefulWidget {
  const NotificationMahasiswaScreen({super.key});

  @override
  State<NotificationMahasiswaScreen> createState() => _NotificationMahasiswaScreenState();
}

class _NotificationMahasiswaScreenState extends State<NotificationMahasiswaScreen> {
  final List<Map<String, dynamic>> notificationCards = [
    {
      'title': 'Jadwal Bimbingan',
      'message': 'Jangan lupa bimbingan online jam 14:00',
      'isRead': false,
    },
    {
      'title': 'Dokumen Tugas Akhir',
      'message': 'Jadwal lupa mengumpulkan BAB II: Latar Belakang',
      'isRead': false,
    },
    {
      'title': 'Jadwal Bimbingan',
      'message': 'Jangan lupa bimbingan jam 10:00 di GU 706',
      'isRead': false,
    },
  ];

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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Hari ini
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hari ini',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall!.copyWith(fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notificationCards.length,
                      itemBuilder: (context, index) {
                        return NotificationCard(
                          title: notificationCards[index]['title'] ?? '',
                          message: notificationCards[index]['message'] ?? '',
                          isRead: notificationCards[index]['isRead'] ?? false,
                          onTap: () {
                            setState(() {
                              notificationCards[index]['isRead'] = true;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
              // Kemarin
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kemarin',
                      style: Theme.of(
                        context,
                      ).textTheme.titleSmall!.copyWith(fontSize: 16),
                    ),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: notificationCards.length,
                      itemBuilder: (context, index) {
                        return NotificationCard(
                          title: notificationCards[index]['title'] ?? '',
                          message: notificationCards[index]['message'] ?? '',
                          isRead: notificationCards[index]['isRead'] ?? false,
                          onTap: () {
                            setState(() {
                              notificationCards[index]['isRead'] = true;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
