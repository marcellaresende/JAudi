import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:jaudi/src/features/core/screens/profile/update_profile_screen.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/supplier_business.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/update_supplier_business_screen.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/widgets/app_bar.dart';

class SupplierBusinessListScreen extends StatefulWidget {
  const SupplierBusinessListScreen({Key? key}) : super(key: key);

  @override
  _SupplierBusinessListScreenState createState() => _SupplierBusinessListScreenState();
}

class _SupplierBusinessListScreenState extends State<SupplierBusinessListScreen> {
  bool searchBarInUse = false;
  late Future<List<SupplierBusinessResponse>> futureData;

  TextEditingController searchController = TextEditingController();

  late List<SupplierBusinessResponse> supplierBusinessList;
  late List<SupplierBusinessResponse> filteredSupplierBusinessList;

  @override
  void initState() {
    super.initState();
    futureData = getAllSuppliersBusiness();
    searchController.addListener(_onSearchChanged);
    supplierBusinessList = [];
    filteredSupplierBusinessList = [];
  }


  void _onSearchChanged() {
    setState(() {
      filteredSupplierBusinessList = supplierBusinessList.where((supplierBusiness) {
        final name = supplierBusiness.name.toLowerCase();
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

        final List<SupplierBusinessResponse> suppliersBusinessList = [];
        for (var item in jsonData) {
          final supplierBusiness = SupplierBusinessResponse(
              id: item['id'],
              name: item['name'],
              creationDate: item['creationDate'],
              cnpj: item['cnpj'],
              responsibleCentralId: item['responsibleCentralId'],
              products: null,
          );

          suppliersBusinessList.add(supplierBusiness);
        }

        setState(() {
          supplierBusinessList = suppliersBusinessList;
          filteredSupplierBusinessList = suppliersBusinessList;
        });


        return supplierBusinessList;
      } else {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load client list');
      }

    } catch (e) {
      print('Erro ao fazer a solicitação HTTP: $e');
      throw Exception('Falha ao carregar a lista de clientes');
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
                  tSupplierBusinessListSubTitle,
                  style: Theme.of(context).textTheme.headline2,
                ),
                const SizedBox(height: homePadding),
                //Search Box
                Container(
                  decoration: const BoxDecoration(
                      border: Border(left: BorderSide(width: 4))),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                            hintStyle:
                            TextStyle(color: Colors.grey.withOpacity(0.5)),
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
                const SizedBox(height: homePadding),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(homeCardPadding),
              child: ListView.builder(
                itemCount: filteredSupplierBusinessList.length,
                itemBuilder: (context, index) {
                  final supplierBusiness = filteredSupplierBusinessList[index];
                  return Card(
                    elevation: 3,
                    color: cardBgColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.business_center_rounded,
                                      color: darkColor,
                                      size: 35,
                                    ),
                                    const SizedBox(width: 5),
                                    Flexible(
                                      child: Text(
                                        supplierBusiness.name,
                                        style: GoogleFonts.poppins(
                                            fontSize: 20.0,
                                            fontWeight: FontWeight.w800,
                                            color: darkColor),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Get.to(() => UpdateSupplierBusinessScreen(supplierBusiness: supplierBusiness));
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
                                Icons.numbers_rounded,
                                color: darkColor,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  supplierBusiness.cnpj,
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: darkColor),
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
                                Icons.calendar_today,
                                color: darkColor,
                                size: 20,
                              ),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(DateTime.parse(supplierBusiness.creationDate)),
                                  style: GoogleFonts.poppins(
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                      color: darkColor),
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