import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/supplier_business.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/home_screen.dart';


class RegisterSupplierBusinessFormWidget extends StatefulWidget {
  const RegisterSupplierBusinessFormWidget({
    super.key,
  });

  @override
  _RegisterSupplierBusinessFormWidget createState() => _RegisterSupplierBusinessFormWidget();

}

class _RegisterSupplierBusinessFormWidget extends State<RegisterSupplierBusinessFormWidget> {
  final TextEditingController supplierBusinessController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> registerClient(VoidCallback onSuccess) async {
      String supplierBusiness = supplierBusinessController.text;
      String cnpj = cnpjController.text;


      if (supplierBusiness.isEmpty ||
          cnpj.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Os campos nome e cpf são obrigatórios.');
          },
        );
        return;
      }

      if (supplierBusiness.length == 1) {
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
          name: supplierBusiness,
          cnpj: cnpj,
      );

      String requestBody = jsonEncode(supplierBusinessRequest.toJson());
      print(requestBody);
      print(CentralManager.instance.loggedUser!.token);
      print(CentralManager.instance.loggedUser!.central.name);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/supplierBusiness/'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${CentralManager.instance.loggedUser!.token}'
          },
          body: requestBody,
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          onSuccess.call();
          print('Registration successful!');
        }  else {
          // Registration failed
          print('Login failed. Status code: ${response.statusCode}');

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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: formHeight - 10),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: supplierBusinessController,
              decoration: const InputDecoration(
                  label: Text(tName),
                  prefixIcon: Icon(Icons.person_outline_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cnpjController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '##.###.###/####-##',),
              ],
              decoration: const InputDecoration(
                  label: Text(tCnpj), prefixIcon: Icon(Icons.numbers)),
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  registerClient(() {
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