class TodoItem {
  String id;
  String title;
  bool isCompleted;

  TodoItem({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  // From Firestore document
  factory TodoItem.fromFirestore(Map<String, dynamic> data, String id) {
    return TodoItem(
      id: id,
      title: data['title'],
      isCompleted: data['isCompleted'] ?? false,
    );
  }

  // To Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
   TodoItem copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
