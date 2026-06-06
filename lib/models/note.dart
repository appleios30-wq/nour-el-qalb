class Note {
  final String id;
  String content;
  final DateTime createdAt;
  DateTime? updatedAt;

  Note({
    required this.id,
    required this.content,
    DateTime? createdAt,
    this.updatedAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null 
        ? DateTime.parse(json['updatedAt']) 
        : null,
  );
}
