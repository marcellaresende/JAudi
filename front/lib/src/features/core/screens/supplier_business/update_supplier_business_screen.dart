import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:jaudi/src/features/core/screens/products/products.dart';
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

class UpdateSupplierBusinessScreen extends StatefulWidget {
  const UpdateSupplierBusinessScreen({super.key, required this.supplierBusiness});
  final SupplierBusinessResponse supplierBusiness;
  
  @override
  _UpdateSupplierBusinessScreenState createState() => _UpdateSupplierBusinessScreenState();
}

class _UpdateSupplierBusinessScreenState extends State<UpdateSupplierBusinessScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController supplierIdController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    nameController.text = widget.supplierBusiness.name;
    cnpjController.text = widget.supplierBusiness.cnpj;
  }

  bool _clearFieldName = false;
  bool _clearFieldCnpj = false;

  @override
  Widget build(BuildContext context) {
    Future<void> updateSupplierBusiness(VoidCallback onSuccess) async {
      String name = nameController.text;
      String cnpj = cnpjController.text;

      if (name.isEmpty ||
          cnpj.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      if (name.length == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O nome deve conter mais que um carácter');
          },
        );
        return;
      }

      if (cnpjController.text.replaceAll(RegExp(r'\D'), '').length != 14) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número do CNPJ deve conter exatamente 14 dígitos.');
          },
        );
        return;
      }


      SupplierBusinessRequest supplierBusinessRequest = SupplierBusinessRequest(
        name: name,
        cnpj: cnpj
      );

      String requestBody = jsonEncode(supplierBusinessRequest.toJson());

      print(requestBody);
      print(widget.supplierBusiness.id);

      try {
        final response = await http.put(
          Uri.parse('http://localhost:8080/api/central/supplierBusiness/${widget.supplierBusiness.id}'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Registration successful!');
        } else {
          print('Registration failed. Status code: ${response.statusCode}');
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertPopUp(
                    errorDescription: response.body);
              });
        }
      } catch (e) {
        print('Error occurred: $e');
      }
    }

    Future<void> deleteWorker() async {

      final response = await http.delete(
        Uri.parse('http://llocalhost:8080/api/central/supplierBusiness/${widget.supplierBusiness.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Serviço excluído com sucesso!')),
          );
        });
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Get.back(), icon: const Icon(LineAwesomeIcons.angle_left)),
        title: Text(tEditSupplierBusiness, style: Theme.of(context).textTheme.headline4),
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
                            TextFormField(
                              controller: nameController,
                              decoration: InputDecoration(
                                labelText: tName,
                                prefixIcon: const Icon(Icons.business_rounded),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _clearFieldName = true;
                                      if (_clearFieldName) {
                                        nameController.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: formHeight - 20),
                            TextFormField(
                              controller: cnpjController,
                              inputFormatters: [
                                MaskTextInputFormatter(mask: '##.###.###/####-##',),
                              ],
                              decoration: InputDecoration(
                                labelText: tCnpj,
                                prefixIcon: const Icon(LineAwesomeIcons.business_time),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      _clearFieldCnpj = true;
                                      if (_clearFieldCnpj) {
                                        cnpjController.clear();
                                      }
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: formHeight),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  updateSupplierBusiness(() {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const HomeScreen())
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Atualização Realizada')),
                                    );
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: primaryColor,
                                    side: BorderSide.none,
                                    shape: const StadiumBorder()),
                                child: Text(tEditSupplierBusiness.toUpperCase(), style: const TextStyle(color: darkColor)),
                              ),
                            ),
                            const SizedBox(height: formHeight),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text.rich(
                                  TextSpan(
                                    text: tJoinedSupplierBusiness,
                                    style: const TextStyle(fontSize: 12),
                                    children: [
                                      TextSpan(
                                          text: DateFormat('dd/MM/yyyy').format(DateTime.parse(widget.supplierBusiness.creationDate)),
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
                                            deleteWorker();
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
