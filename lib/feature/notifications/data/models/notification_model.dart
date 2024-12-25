import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final String timestamp;
  final bool isRead;
  final String? imageUrl;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
    this.imageUrl,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      timestamp: json['created_at']?.toString() ?? '',
      isRead: json['is_read'] as bool? ?? false,
      imageUrl: json['image_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'created_at': timestamp,
      'is_read': isRead,
      'image_url': imageUrl,
    };
  }

  @override
  List<Object?> get props => [id, title, body, timestamp, isRead, imageUrl];

  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? timestamp,
    bool? isRead,
    String? imageUrl,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  // إضافة getter للحصول على كائن DateTime
  DateTime get dateTime => DateTime.parse(timestamp);
}
