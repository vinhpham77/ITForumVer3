class Tag {
  int id;
  String name;
  String description;

  Tag({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  static Tag empty() {
    return Tag(
      id: 0,
      name: '',
      description: '',
    );
  }
}
