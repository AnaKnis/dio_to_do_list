class ListModel {
  final String? objectId;
  final String title;
  final String description;
  final String? imageUrl;

  ListModel({
    this.objectId,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory ListModel.fromJson(Map<String, dynamic> json) {
    return ListModel(
      objectId: json['objectId'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectId': objectId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
