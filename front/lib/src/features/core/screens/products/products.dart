class ProductsRequest {
  final String name;
  final String price;
  final String supplierCnpj;

  ProductsRequest({
    required this.name,
    required this.price,
    required this.supplierCnpj,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'supplierCnpj': supplierCnpj
    };
  }
}

/*class  ProductsResponse{
  final num id;
  final String name;
  final String price;
  final num supplierId;
  final String? lastTimePurchase;
  final List<num>? oldPrices;
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
}*/

class ProductsResponse {
  final int id;
  final String name;
  final double price;
  final int supplierId;
  final String? lastTimePurchase; // This can be null
  final List<double> oldPrices;
  final String creationDate;

  ProductsResponse({
    required this.id,
    required this.name,
    required this.price,
    required this.supplierId,
    this.lastTimePurchase,
    required this.oldPrices,
    required this.creationDate,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    return ProductsResponse(
      id: json['id'],
      name: json['name'],
      price: double.parse(json['price']), // Ensure price is parsed as double
      supplierId: json['supplierId'],
      lastTimePurchase: json['lastTimePurchase'],
      oldPrices: List<double>.from(json['oldPrices']), // Ensuring correct parsing
      creationDate: json['creationDate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'supplierId': supplierId,
      'lastTimePurchase': lastTimePurchase,
      'oldPrices': oldPrices,
      'creationDate': creationDate,
    };
  }
}


class  UpdateProductRequest {
  final String name;
  final String price;
  final String supplierId;

  UpdateProductRequest({required this.name, required this.price, required this.supplierId,});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price' : price,
      'supplierId': supplierId,
    };
  }
}

