import 'package:jaudi/src/features/core/screens/products/products.dart';

class SupplierBusinessRequest {
  final String name;
  final String cnpj;

  SupplierBusinessRequest({
    required this.name,
    required this.cnpj
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cnpj': cnpj
    };
  }
}

class  SupplierBusinessResponse{
  final num id;
  final String name;
  final String creationDate;
  final String cnpj;
  final num responsibleCentralId;
  final List<ProductsResponse>? products;

  SupplierBusinessResponse({required this.id, required this.name, required this.creationDate, required this.cnpj, required this.responsibleCentralId,
    required this.products});

  Map<String, dynamic> toJson() {
    return {
      'id' : id,
      'name': name,
      'creationDate' : creationDate,
      'cnpj': cnpj,
      'responsibleCentralId': responsibleCentralId,
      'products': products
    };
  }
}

