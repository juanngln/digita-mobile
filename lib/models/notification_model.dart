class NotificationModel {
  final int? id;
  final String title;
  final String body;
  final DateTime receivedAt;
  final bool isRead;

  NotificationModel({
    this.id,
    required this.title,
    required this.body,
    required this.receivedAt,
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'receivedAt': receivedAt.toIso8601String(),
      'isRead': isRead ? 1 : 0,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      receivedAt: DateTime.parse(map['receivedAt']),
      isRead: map['isRead'] == 1,
    );
  }
}
