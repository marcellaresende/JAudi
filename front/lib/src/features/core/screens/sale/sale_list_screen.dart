import 'dart:convert';
import 'dart:html';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jaudi/src/features/core/screens/client_business/client_business.dart';
import 'package:jaudi/src/features/core/screens/home_screen/widgets/app_bar.dart';
import 'package:jaudi/src/features/core/screens/sale/sale.dart';
import 'package:jaudi/src/features/core/screens/sale/update_sale_screen.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/supplier_business.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../products/products.dart';




class SaleListScreen extends StatefulWidget {
  const SaleListScreen({Key? key}) : super(key: key);

  @override
  _SalesListScreenState createState() => _SalesListScreenState();
}

class _SalesListScreenState extends State<SaleListScreen> {
  bool searchBarInUse = false;
  late Future<List<SaleInformations>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<SaleInformations> saleList;
  late List<SaleInformations> filteredSalesList;
  List<ProductsResponse> products = [];

  @override
  void initState() {
    super.initState();
    futureData = getAllSales();
    searchController.addListener(_onSearchChanged);
    saleList = [];
    filteredSalesList = [];
  }


  void _onSearchChanged() {
    setState(() {
      filteredSalesList = saleList.where((data) {
        final name = data.sale.purchaseOrder.toLowerCase();
        final query = searchController.text.toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<List<SupplierBusinessResponse>> getAllSuppliersBusiness() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/supplierBusiness'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        final List<SupplierBusinessResponse> suppliersBusinessList = jsonData.map((item) {
          return SupplierBusinessResponse(
              id: item['id'],
              name: item['name'],
              creationDate: item['creationDate'],
              cnpj: item['cnpj'],
              responsibleCentralId: item['responsibleCentralId'],
              products: null
          );
        }).toList();

        return suppliersBusinessList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load suppliersBusiness list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de clientsBusiness');
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
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;

        final List<ClientBusinessResponse> clientsBusinessList = jsonData.map((item) {
          return ClientBusinessResponse(
            id: item['id'],
            name: item['name'],
            cnpj: item['cnpj'],
            cellphone: item['cellphone'],
            creationDate: item['creationDate'],
            responsibleCentral: item['responsibleCentral'],
          );
        }).toList();

        return clientsBusinessList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load clientBusiness list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de clientsBusiness');
    }
  }

  Future<void> getAllProducts() async {
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

  Future<List<SaleInformations>> getAllSales() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:8080/api/central/sale'),
        headers: {
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
        },
      );
      print("Status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        print(jsonData);

        final allClientsBusiness = await getAllClientBusiness();
        final allSuppliersBusiness = await getAllSuppliersBusiness();
        await getAllProducts();

        final Map<num, String> clientBusinessIdToNameMap = {
          for (var clientBusiness in allClientsBusiness)
            clientBusiness.id: clientBusiness.name
        };
        final Map<num, String> suppliersBusinessIdToNameMap = {
          for (var supplierBusiness in allSuppliersBusiness)
            supplierBusiness.id: supplierBusiness.name
        };
        final Map<num, String> productIdToNameMap = {
          for (var product in products)
            product.id: product.name
        };

        final List<SaleInformations> salesList = [];
        for (var item in jsonData) {
          final clientBusinessName = clientBusinessIdToNameMap[item['clientId']] ?? 'Unknown';
          final supplierBusinessName = suppliersBusinessIdToNameMap[item['supplierId']] ?? 'Unknown';

          final List<String> productNamesWithQuantities = (item['productsQtt'] as List<dynamic>).map((product) {
            final productQtt = ProductQttResponse.fromJson(product);
            final productName = productIdToNameMap[productQtt.idProduct] ?? 'Unknown Product';
            return '$productName: ${productQtt.qtt}';
          }).toList();

          final List<ProductQttResponse> productsQtt = (item['productsQtt'] as List<dynamic>)
              .map((product) => ProductQttResponse.fromJson(product))
              .toList();

          final sale = SaleResponse(
            id: item['id'],
            clientId: item['clientId'],
            supplierId: item['supplierId'],
            purchaseOrder: item['purchaseOrder'],
            carrier: item['carrier'],
            fare: item['fare'],
            productsQtt: productsQtt,
            saleDate: item['saleDate'],
            billingDate: item['billingDate'],
            totalPrice: item['totalPrice']
          );

          final saleInformations = SaleInformations(
            sale.id,
            clientBusinessName,
            supplierBusinessName,
            sale,
            productNamesWithQuantities
          );

          if (!salesList.any((existingSale) => existingSale.sale.id == sale.id)) {
            salesList.add(saleInformations);
          }
        }

        setState(() {
          saleList = salesList;
          filteredSalesList = salesList;
        });

        return salesList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load sale list');
      }
    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de vendas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(homePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${CentralManager.instance.loggedUser!.central.name},",
                  style: Theme.of(context).textTheme.bodyText2,
                ),
                Text(
                  assitanceListSubTitle,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: homePadding,),
                //Search Box
                Container(
                  decoration: const BoxDecoration(border: Border(left: BorderSide(width: 4))),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            _onSearchChanged();
                          },
                          decoration: InputDecoration(
                            hintText: tSearch,
                            hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
                            suffixIcon: IconButton(
                              onPressed: () {
                                _onSearchChanged();
                              },
                              icon: const Icon(Icons.search, size: 25),
                            ),
                          ),
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: homePadding,),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(homeCardPadding),
              child: ListView.builder(
                itemCount: filteredSalesList.length,
                itemBuilder: (context, index) {
                  final data = filteredSalesList[index];
                  return Card(
                    elevation: 3,
                    color: cardBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.numbers_rounded,
                                      color: darkColor,
                                      size: 35,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        data.sale.purchaseOrder,
                                        style: GoogleFonts.poppins(fontSize: 20.0, fontWeight: FontWeight.w800, color: darkColor),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => UpdateSaleScreen(sale: data.sale));
                                },
                                icon: const Icon(Icons.edit, color: darkColor),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.business_rounded,
                                color: darkColor,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  data.clientBusinessName,
                                  style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.shopping_cart_rounded,
                                color: darkColor,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  data.productNamesWithQuantities.join(', '),
                                  style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.work_rounded,
                                color: darkColor,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                  data.supplierBusinessName,
                                  style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.attach_money_rounded,
                                color: darkColor,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: Text(
                                    'R\$ ${data.sale.totalPrice.toStringAsFixed(2)}',
                                  style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w500, color: darkColor),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}