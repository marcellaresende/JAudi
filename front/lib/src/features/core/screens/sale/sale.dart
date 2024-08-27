import '../products/products.dart';

class SaleRequest {
  List<ProductQttRequest> productsQtt;
  final int? clientId;
  final int? supplierId;
  final String purchaseOrder;
  final String carrier;
  final String fare;


  SaleRequest({
    required this.productsQtt,
    required this.clientId,
    required this.supplierId,
    required this.purchaseOrder,
    required this.carrier,
    required this.fare
  });

  Map<String, dynamic> toJson() {
    return {
      'productsQtt': productsQtt.map((p) => p.toJson()).toList(),
      'clientId': clientId,
      'supplierId': supplierId,
      'purchaseOrder': purchaseOrder,
      'carrier': carrier,
      'fare': fare
    };
  }
}


class SaleInformations {
  final num id;
  final String clientBusinessName;
  final String supplierBusinessName;
  final SaleResponse sale;
  final List<String> productNamesWithQuantities;

  SaleInformations(
      this.id,
      this.clientBusinessName,
      this.supplierBusinessName,
      this.sale,
      this.productNamesWithQuantities,
      );
}

class SaleResponse {
  final num id;
  final num clientId;
  final num supplierId;
  final String purchaseOrder;
  final String carrier;
  final String fare;
  final List<ProductQttResponse> productsQtt;


  SaleResponse({required this.id, required this.clientId,required this.supplierId,required this.purchaseOrder, required this.carrier,
    required this.fare, required this.productsQtt});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'clientId': clientId,
      'supplierId': supplierId,
      'purchaseOrder': purchaseOrder,
      'carrier': carrier,
      'fare': fare,
      'productsQtt': productsQtt
    };
  }
}