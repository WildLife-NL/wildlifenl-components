class AlarmConveyance {
  const AlarmConveyance({
    required this.id,
    required this.timestamp,
    required this.message,
    this.user,
  });

  final String id;
  final String timestamp;
  final AlarmMessage message;
  final AlarmUser? user;

  factory AlarmConveyance.fromJson(Map<String, dynamic> json) {
    return AlarmConveyance(
      id: json['ID'] as String? ?? json['id'] as String? ?? '',
      timestamp: json['timestamp'] as String? ?? '',
      message: AlarmMessage.fromJson(
        json['message'] as Map<String, dynamic>? ?? {},
      ),
      user: json['user'] != null
          ? AlarmUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'ID': id,
        'timestamp': timestamp,
        'message': message.toJson(),
        if (user != null) 'user': user!.toJson(),
      };
}

class AlarmMessage {
  const AlarmMessage({
    this.body,
    this.title,
  });

  final String? body;
  final String? title;

  factory AlarmMessage.fromJson(Map<String, dynamic> json) {
    return AlarmMessage(
      body: json['body'] as String?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (body != null) 'body': body,
        if (title != null) 'title': title,
      };
}

class AlarmUser {
  const AlarmUser({
    this.id,
    this.displayName,
  });

  final String? id;
  final String? displayName;

  factory AlarmUser.fromJson(Map<String, dynamic> json) {
    return AlarmUser(
      id: json['ID'] as String? ?? json['id'] as String?,
      displayName: json['displayName'] as String? ?? json['display_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        if (id != null) 'ID': id,
        if (displayName != null) 'displayName': displayName,
      };
}
