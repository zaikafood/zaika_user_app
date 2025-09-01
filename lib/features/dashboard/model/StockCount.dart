class StockModel {
  final int count;
  final int stock;

  StockModel({
    required this.count,
    required this.stock,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      count: json['count'] ?? 0,
      stock: json['stock'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'stock': stock,
    };
  }
}
