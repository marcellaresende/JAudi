import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jaudi/src/features/core/screens/products/products.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/supplier_business.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/home_screen.dart';


class RegisterProductsFormWidget extends StatefulWidget {
  const RegisterProductsFormWidget({
    super.key,
  });

  @override
  _RegisterProductsFormWidget createState() => _RegisterProductsFormWidget();

}

class _RegisterProductsFormWidget extends State<RegisterProductsFormWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> registerProduct(VoidCallback onSuccess) async {
      String name = nameController.text;
      String price = priceController.text;
      String cnpj = cnpjController.text;

      if (name.isEmpty || price.isEmpty || cnpj.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Os campos nome, preço e CNPJ são obrigatórios.');
          },
        );
        return;
      }

      if (name.length == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O nome deve conter mais que um caractere');
          },
        );
        return;
      }

      if (cnpj.replaceAll(RegExp(r'\D'), '').length != 14) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O número do CNPJ deve conter exatamente 14 dígitos.');
          },
        );
        return;
      }

      ProductsRequest productsRequest = ProductsRequest(
          name: name,
          price: price,
          supplierCnpj: cnpj
      );

      String requestBody = jsonEncode(productsRequest.toJson());
      print(requestBody);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/product'),
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
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                  label: Text(tName),
                  prefixIcon: Icon(Icons.add_box_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: priceController,
              decoration: const InputDecoration(
                  label: Text(tPrice), prefixIcon: Icon(Icons.attach_money_rounded)
              ),
              keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: true),
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