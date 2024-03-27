import 'dart:convert';

class Note {
  final int id;
  final String title;
  final String body;
  String createDate; 
  Note({
    required this.id,
    required this.title,
    required this.body,
    required this.createDate,
  });

  Note copyWith({
    int? id,
    String? title,
    String? body,
    String? createDate,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      createDate: createDate ?? this.createDate,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    result.addAll({'id': id});
    result.addAll({'title': title});
    result.addAll({'body': body});
    result.addAll({'createDate': createDate});
  
    return result;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id']?.toInt() ?? 0,
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      createDate: map['createDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Note.fromJson(String source) => Note.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Note(id: $id, title: $title, body: $body, createDate: $createDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Note &&
      other.id == id &&
      other.title == title &&
      other.body == body &&
      other.createDate == createDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      body.hashCode ^
      createDate.hashCode;
  }
}
