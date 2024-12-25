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
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      timestamp: json['timestamp'] as String,
      isRead: json['isRead'] as bool? ?? false,
      imageUrl: json['imageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'timestamp': timestamp,
      'isRead': isRead,
      'imageUrl': imageUrl,
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
