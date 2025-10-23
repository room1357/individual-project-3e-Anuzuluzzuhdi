class WishlistItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final double price;
  bool isCompleted;

  WishlistItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    this.isCompleted = false,
  });

  factory WishlistItem.fromJson(Map<String, dynamic> json) {
    return WishlistItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      price: json['price'],
      isCompleted: json['isCompleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'price': price,
      'isCompleted': isCompleted,
    };
  }
}