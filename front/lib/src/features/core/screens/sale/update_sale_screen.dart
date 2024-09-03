import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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


class UpdateSaleScreen extends StatefulWidget {
  const UpdateSaleScreen({
    super.key, required this.sale
  });
  final SaleResponse sale;

  @override
  _UpdateSaleScreen createState() => _UpdateSaleScreen();

}

class _UpdateSaleScreen extends State<UpdateSaleScreen> {
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
  Map<int, String> productIdToNameMap = {};
  List<ProductsResponse> filteredProducts = [];
  Map<int, TextEditingController> quantityControllers = {};

  @override
  void initState() {
    super.initState();
    fetchProducts().then((_) {
      mapProductIdsToNamesAndQuantities();
    });

    fetchClientId().then((_) {
      setState(() {
        selectedClientBusiness = clientsBusiness.firstWhere(
                (client) => client.id == widget.sale.clientId);
      });
    });
    fetchSupplierBusinessId().then((_) {
      setState(() {
        selectedSupplierBusiness = suppliersBusiness.firstWhere(
                (supplier) => supplier.id == widget.sale.supplierId);
      });
    });
    
    purchaseOrderController.text = widget.sale.purchaseOrder;
    carrierController.text = widget.sale.carrier;
    fareController.text = widget.sale.fare;
    billingDateController.text = widget.sale.billingDate;
  }

  bool _clearFieldPurchaseOrder = false;
  bool _clearFieldCarrier = false;
  bool _clearFieldFare = false;

  void mapProductIdsToNamesAndQuantities() {
    for (var productQtt in widget.sale.productsQtt) {
      final product = products.firstWhere((p) => p.id == productQtt.idProduct);

      setState(() {
        selectedProducts.add(ProductQttRequest(idProduct: product.id, qtt: productQtt.qtt));
        productIdToNameMap[product.id] = product.name;
        quantityControllers[product.id] = TextEditingController(text: '${productQtt.qtt}');
      });
    }
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
            return AlertDialog(
              title: Text('Selecionar Produtos', style: Theme.of(context).textTheme.headline4),
              content: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        labelText: 'Pesquisar Produto',
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredProducts = products
                              .where((product) => product.name.toLowerCase().contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4, // Tamanho fixo para a lista de produtos
                      child: ListView(
                        children: (searchController.text.isEmpty ? products : filteredProducts)
                            .map((product) {
                          final isSelected = selectedProducts.any((p) => p.idProduct == product.id);
                          final selectedProduct = selectedProducts.firstWhere(
                                (p) => p.idProduct == product.id,
                            orElse: () => ProductQttRequest(idProduct: product.id, qtt: 1),
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
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/central/sale/${widget.sale.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Atualização da venda realizada com sucesso!');
        } else {
          print('Falha na atualização da venda. Status code: ${response.statusCode}');
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

    Future<void> deleteSale() async {

      final response = await http.delete(
        Uri.parse('http://localhost:8080/api/central/sale/${widget.sale.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venda excluída com sucesso!')),
          );
        });
      }
    }
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tEditProduct, style: Theme.of(context).textTheme.headline4),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
          double elementWidth;
          if (constraints.maxWidth < 800) {
            elementWidth = double.infinity;
          } else {
            elementWidth = constraints.maxWidth * 0.3;
          }
          return Center(
            child: Container(
              padding: const EdgeInsets.all(defaultSize),
              width: elementWidth,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
                child: Column(
                  children: [
                    const Stack(
                      children: [
                        SizedBox(
                        width: 120,
                          height: 120,
                          child: Icon(LineAwesomeIcons.user_edit, color: primaryColor, size: 100),
                        ),
                      ],
                    ),
                  const SizedBox(height: 50),
                  Form(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showProductsDialog();
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Produtos',
                              prefixIcon: Icon(Icons.shopping_cart),
                              suffixIcon: Icon(Icons.edit)
                            ),
                            child: Text(
                              selectedProducts.isEmpty
                                  ? ''
                                  : selectedProducts
                                  .map((productQtt) =>
                              '${productIdToNameMap[productQtt.idProduct]}: ${productQtt.qtt}')
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
                        decoration: InputDecoration(
                            label: Text(tPurchaseOrder),
                            prefixIcon: Icon(Icons.numbers),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _clearFieldPurchaseOrder = true;
                                if (_clearFieldPurchaseOrder) {
                                  purchaseOrderController.clear();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: formHeight - 20),
                      TextFormField(
                        controller: carrierController,
                        decoration: InputDecoration(
                            label: Text(tCarrier),
                            prefixIcon: Icon(Icons.directions_bus),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _clearFieldCarrier = true;
                                if (_clearFieldCarrier) {
                                  carrierController.clear();
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: formHeight - 20),
                      TextFormField(
                        controller: fareController,
                        decoration: InputDecoration(
                            label: Text(tFare),
                            prefixIcon: Icon(Icons.attach_money_rounded),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                _clearFieldFare = true;
                                if (_clearFieldFare) {
                                  fareController.clear();
                                }
                              });
                            },
                          ),
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
                                const SnackBar(content: Text('Atualização Realizada')),
                              );
                            });
                          },
                          child: Text(tEditSale.toUpperCase()),
                        ),
                      ),
                      const SizedBox(height: formHeight),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.sale.saleDate)),
                              style: const TextStyle(fontSize: 12),
                              children: [
                                TextSpan(
                                    text: widget.sale.fare,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))
                              ],
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Get.defaultDialog(
                                title: tDelete.toUpperCase(),
                                titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                content: const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text("Tem certeza que deseja excluir esse produto?"),
                                ),
                                confirm: Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      deleteSale();
                                      Get.to(const HomeScreen());
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, side: BorderSide.none),
                                    child: const Text("Sim"),
                                  ),
                                ),
                                cancel: OutlinedButton(onPressed: () => Get.back(), child: const Text("Não")),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent.withOpacity(0.1),
                                elevation: 0,
                                foregroundColor: Colors.red,
                                shape: const StadiumBorder(),
                                side: BorderSide.none),
                            child: const Text(tDelete),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                ],
                ),
              ),
            ),
            );
          },
        ),
      ),
    );
  }
}