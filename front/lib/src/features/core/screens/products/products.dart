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
  final String? lastTimePurchase;
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
      price: double.parse(json['price'].toString()),
      supplierId: json['supplierId'],
      lastTimePurchase: json['lastTimePurchase'],
      oldPrices: (json['oldPrices'] as List<dynamic>).map((price) => double.parse(price.toString())).toList(),
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


class UpdateProductsRequest {
  final String name;
  final String price;
  final String? supplierCnpj;

  UpdateProductsRequest({
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

class ProductQttRequest {
  int? qtt;
  final int idProduct;

  ProductQttRequest({
    required this.qtt,
    required this.idProduct
  });

  Map<String, dynamic> toJson() {
    return {
      'qtt': qtt,
      'idProduct': idProduct
    };
  }
}

class ProductQttResponse {
  final int? qtt;
  final int idProduct;

  ProductQttResponse({
    required this.idProduct,
    required this.qtt
  });

  factory ProductQttResponse.fromJson(Map<String, dynamic> json) {
    return ProductQttResponse(
      idProduct: json['idProduct'],
      qtt: json['qtt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProduct': idProduct,
      'qtt': qtt
    };
  }
}





