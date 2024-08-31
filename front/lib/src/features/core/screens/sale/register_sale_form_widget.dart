import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jaudi/src/features/core/screens/client_business/client_business.dart';
import 'package:jaudi/src/features/core/screens/products/products.dart';
import 'package:jaudi/src/features/core/screens/sale/sale.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/supplier_business.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/home_screen.dart';


class RegisterSaleFormWidget extends StatefulWidget {
  const RegisterSaleFormWidget({
    super.key,
  });

  @override
  _RegisterSaleFormWidget createState() => _RegisterSaleFormWidget();

}

class _RegisterSaleFormWidget extends State<RegisterSaleFormWidget> {
  final TextEditingController purchaseOrderController = TextEditingController();
  final TextEditingController carrierController = TextEditingController();
  final TextEditingController fareController = TextEditingController();
  final TextEditingController billingDateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  bool _isClientsBusinessExpanded = false;
  bool _isSupplierBusinessExpanded = false;
  List<ClientBusinessResponse> clientsBusiness = [];
  ClientBusinessResponse? selectedClientBusiness;
  List<SupplierBusinessResponse> suppliersBusiness = [];
  SupplierBusinessResponse? selectedSupplierBusiness;
  List<ProductsResponse> products = [];
  List<ProductQttRequest> selectedProducts = [];
  List<ProductsResponse> filteredProducts = [];
  Map<int, TextEditingController> quantityControllers = {};

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchClientId();
    fetchSupplierBusinessId();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/product'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          products = jsonData.map((item) => ProductsResponse.fromJson(item)).toList();
        });
      } else {
        throw Exception('Falha ao carregar a lista de produtos');
      }
    } catch (e) {
      print('Erro ao carregar produtos: $e');
    }
  }

  void showProductsDialog() async {
    final result = await showDialog<List<ProductQttRequest>>(
      context: context,
      builder: (BuildContext context) {

        return StatefulBuilder(
          builder: (context, setState) {
          return LayoutBuilder(
            builder: (context, constraints) {
              double elementWidth;
              if (constraints.maxWidth < 800) {
                elementWidth = double.infinity;
              } else {
                elementWidth = constraints.maxWidth * 0.3;
              }

              return AlertDialog(
                title: Text('Selecionar Produtos', style: Theme.of(context).textTheme.headline4),
                content: Container(
                  width: elementWidth,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: searchController,
                        decoration: const InputDecoration(
                            labelText: 'Pesquisar Produto'),
                        onChanged: (value) {
                          setState(() {
                            filteredProducts = products
                                .where((product) =>
                                product.name.toLowerCase().contains(
                                    value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          children: (searchController.text.isEmpty
                              ? products
                              : filteredProducts)
                              .map((product) {
                            final isSelected = selectedProducts.any((p) =>
                            p.idProduct == product.id);
                            final selectedProduct = selectedProducts.firstWhere(
                                  (p) => p.idProduct == product.id,
                              orElse: () => ProductQttRequest(
                                  idProduct: product.id, qtt: 1),
                            );

                            if (!quantityControllers.containsKey(product.id)) {
                              quantityControllers[product.id] = TextEditingController(
                                text: isSelected ? '${selectedProduct.qtt}' : '',
                              );
                            }

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedProducts.removeWhere((p) => p.idProduct == product.id);
                                    quantityControllers[product.id]?.clear();
                                  } else {
                                    selectedProducts.add(selectedProduct);
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  children: [
                                    AnimatedContainer(
                                      duration: const Duration(milliseconds: 300),
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: isSelected ? Colors.green : Colors.transparent,
                                        border: Border.all(
                                          color: isSelected ? Colors.green : Colors.grey,
                                        ),
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                      child: isSelected
                                          ? const Icon(Icons.check, color: Colors.white, size: 14)
                                          : null,
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(child: Text('${product.name} - R\$ ${product.price.toStringAsFixed(2)}')),
                                    const SizedBox(width: 16),
                                    SizedBox(
                                      width: 120,
                                      height: 30,
                                      child: TextField(
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                        decoration: const InputDecoration(
                                          labelText: 'Quantidade',
                                          isDense: true,
                                        ),
                                        controller: quantityControllers[product.id],
                                        onChanged: (value) {
                                          final quantity = int.tryParse(value) ?? 0;
                                          setState(() {
                                            if (quantity > 0) {
                                              if (!isSelected) {
                                                selectedProducts.add(ProductQttRequest(
                                                  idProduct: product.id,
                                                  qtt: quantity,
                                                ));
                                              } else {
                                                selectedProduct.qtt = quantity;
                                              }
                                            } else {
                                              selectedProducts.removeWhere((p) => p.idProduct == product.id);
                                            }
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(selectedProducts);
                    },
                    child: Text(
                      'Confirmar'.toUpperCase(),
                      style: const TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        });
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedProducts = result;
      });
    }
  }

  Future<void> fetchClientId() async {
    try {
      final clientsBusinessList = await getAllClientBusiness();
      setState(() {
        clientsBusiness = clientsBusinessList;
      });
    } catch (e) {
      print('Error fetching client Id: $e');
    }
  }

  Future<List<ClientBusinessResponse>> getAllClientBusiness() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/clientBusiness'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        final List<ClientBusinessResponse> clientsBusiness = jsonData.map((item) {
          return ClientBusinessResponse(
            id: item['id'],
            name: item['name'],
            cnpj: item['cnpj'],
            cellphone: item['cellphone'],
            creationDate: item['creationDate'],
            responsibleCentral: item['responsibleCentral'],
          );
        }).toList();
        return clientsBusiness;
      } else {
        throw Exception('Failed to load clients business');
      }
    } catch (e) {
      throw Exception('Failed to load clients business: $e');
    }
  }

  Future<void> fetchSupplierBusinessId() async {
    try {
      final suppliersBusinessList = await getAllSuppliersBusiness();
      setState(() {
        suppliersBusiness = suppliersBusinessList;
      });
    } catch (e) {
      print('Error fetching supplierBusinessId: $e');
    }
  }

  Future<List<SupplierBusinessResponse>> getAllSuppliersBusiness() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/supplierBusiness'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        final List<SupplierBusinessResponse> suppliersBusiness = jsonData.map((item) {
          return SupplierBusinessResponse(
            id: item['id'],
            name: item['name'],
            creationDate: item['creationDate'],
            cnpj: item['cnpj'],
            responsibleCentralId: item['responsibleCentralId'],
            products: null
          );
        }).toList();
        return suppliersBusiness;
      } else {
        throw Exception('Failed to load supplierBusiness');
      }
    } catch (e) {
      throw Exception('Failed to load supplierBusiness: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future<void> registerProduct(VoidCallback onSuccess) async {
      String purchaseOrder = purchaseOrderController.text;
      String carrier = carrierController.text;
      String fare = fareController.text;
      String billingDate = billingDateController.text;
      int? selectedClientId = selectedClientBusiness?.id;
      int? selectedSupplierBusinessId = selectedSupplierBusiness?.id;


      if (selectedProducts.length == 0 ||
          selectedClientId == null ||
          selectedSupplierBusinessId == null ||
          purchaseOrder.isEmpty ||
          carrier.isEmpty ||
          fare.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      SaleRequest saleRequest = SaleRequest(
          productsQtt: selectedProducts,
          clientId: selectedClientId,
          supplierId: selectedSupplierBusinessId,
          purchaseOrder: purchaseOrder,
          carrier: carrier,
          fare: fare,
          billingDate: billingDate
      );

      String requestBody = jsonEncode(saleRequest.toJson());
      print(requestBody);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/sale'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Cadastro realizado com sucesso!');
        } else {
          print('Falha no cadastro. Status code: ${response.statusCode}');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertPopUp(
                    errorDescription: response.body);
              });
        }
      } catch (e) {
        print('Ocorreu um erro: $e');
      }
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                showProductsDialog();
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Produtos',
                  prefixIcon: Icon(Icons.shopping_cart),
                ),
                child: Text(
                  selectedProducts.isEmpty
                      ? ''
                      : selectedProducts
                      .map((p) => '${products.firstWhere((prod) => prod.id == p.idProduct).name}: ${p.qtt}')
                      .join(', '),
                ),
              ),
            ),

            const SizedBox(height: formHeight - 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isClientsBusinessExpanded = !_isClientsBusinessExpanded;
                });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  label: const Text('Cliente'),
                  prefixIcon: const Icon(Icons.category_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isClientsBusinessExpanded ? LineAwesomeIcons.angle_up : LineAwesomeIcons.angle_down,
                    ),
                    onPressed: () {
                      setState(() {
                        _isClientsBusinessExpanded = !_isClientsBusinessExpanded;
                      });
                    },
                  ),
                ),
                child: Text(
                  selectedClientBusiness?.name ?? '',
                ),
              ),
            ),
            const SizedBox(height: 2),
            if (_isClientsBusinessExpanded)
              Column(
                children: clientsBusiness.map((clientBusiness) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedClientBusiness = clientBusiness;
                        _isClientsBusinessExpanded = false;
                      });
                    },
                    child: Row(
                      children: [
                        Radio<ClientBusinessResponse>(
                          value: clientBusiness,
                          groupValue: selectedClientBusiness,
                          onChanged: (ClientBusinessResponse? value) {
                            setState(() {
                              selectedClientBusiness = value;
                              _isClientsBusinessExpanded = false;
                            });
                          },
                        ),
                        Text(clientBusiness.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: formHeight - 20),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSupplierBusinessExpanded = !_isSupplierBusinessExpanded;
                });
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  label: const Text('Fornecedor'),
                  prefixIcon: const Icon(Icons.category_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isSupplierBusinessExpanded ? LineAwesomeIcons.angle_up : LineAwesomeIcons.angle_down,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSupplierBusinessExpanded = !_isSupplierBusinessExpanded;
                      });
                    },
                  ),
                ),
                child: Text(
                  selectedSupplierBusiness?.name ?? '',
                ),
              ),
            ),
            const SizedBox(height: 2),
            if (_isSupplierBusinessExpanded)
              Column(
                children: suppliersBusiness.map((supplierBusiness) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSupplierBusiness = supplierBusiness;
                        _isSupplierBusinessExpanded = false;
                      });
                    },
                    child: Row(
                      children: [
                        Radio<SupplierBusinessResponse>(
                          value: supplierBusiness,
                          groupValue: selectedSupplierBusiness,
                          onChanged: (SupplierBusinessResponse? value) {
                            setState(() {
                              selectedSupplierBusiness = value;
                              _isSupplierBusinessExpanded = false;
                            });
                          },
                        ),
                        Text(supplierBusiness.name),
                      ],
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: purchaseOrderController,
              decoration: const InputDecoration(
                  label: Text(tPurchaseOrder),
                  prefixIcon: Icon(Icons.numbers)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: carrierController,
              decoration: const InputDecoration(
                  label: Text(tCarrier),
                  prefixIcon: Icon(Icons.directions_bus)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: fareController,
              decoration: const InputDecoration(
                  label: Text(tFare),
                  prefixIcon: Icon(Icons.attach_money_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: billingDateController,
              decoration: const InputDecoration(
                label: Text(tBillingDate),
                prefixIcon: Icon(Icons.calendar_today_rounded),
              ),
              inputFormatters: [
                MaskTextInputFormatter(
                  mask: '##/##/####',
                  filter: { "#": RegExp(r'[0-9]') },
                )
              ],
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  registerProduct(() {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cadastro Realizado')),
                    );
                  });
                },
                child: Text(tSignUp.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}