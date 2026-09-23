class CartItem {
  final String id;
  final String name;
  final String category;
  final String imageUrl;
  final double price;
  final int quantity;

  const CartItem({
    required this.id,
    required this.name,
    required this.category,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({
    String? id,
    String? name,
    String? category,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}