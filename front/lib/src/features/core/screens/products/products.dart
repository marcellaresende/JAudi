class ProductsRequest {
  final String name;
  final String price;
  final num supplierId;

  ProductsRequest({
    required this.name,
    required this.price,
    required this.supplierId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'supplierId': supplierId
    };
  }
}

class  ProductsResponse{
  final num id;
  final String name;
  final String price;
  final num supplierId;
  final String lastTimePurchase;
  final List<num> oldPrices;
  final String creationDate;

  ProductsResponse({required this.id, required this.name, required this.price, required this.supplierId, required this.lastTimePurchase,
    required this.oldPrices, required this.creationDate});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'price' : price,
      'supplierId': supplierId,
      'lastTimePurchase': lastTimePurchase,
      'oldPrices': oldPrices,
      'creationDate': creationDate,
    };
  }
}

