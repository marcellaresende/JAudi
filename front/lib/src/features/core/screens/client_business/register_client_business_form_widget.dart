import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jaudi/src/features/core/screens/client_business/client_business.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;

import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/home_screen.dart';
import 'client_business.dart';


class RegisterClientBusinessFormWidget extends StatefulWidget {
  const RegisterClientBusinessFormWidget({
    super.key,
  });

  @override
  _RegisterClientBusinessFormWidget createState() => _RegisterClientBusinessFormWidget();

}

class _RegisterClientBusinessFormWidget extends State<RegisterClientBusinessFormWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cnpjController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    Future<void> registerClientBusiness(VoidCallback onSuccess) async {
      String name = nameController.text;
      String cnpj = cnpjController.text;
      String cellphone = cellphoneController.text;


      if (name.isEmpty ||
          cnpj.isEmpty ||
          cellphone.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Os campos nome, cnpj e celular são obrigatórios.');
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

      if (cellphoneController.text.replaceAll(RegExp(r'\D'), '').length != 11) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número de celular deve conter 11 dígitos, incluindo o DDD.');
          },
        );
        return;
      }



      ClientBusinessRequest nameRequest = ClientBusinessRequest(
          name: name,
          cnpj: cnpj,
          cellphone: cellphone,
        
      );

      String requestBody = jsonEncode(nameRequest.toJson());
      print(requestBody);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/clientBusiness'),
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
              controller: nameController,
              decoration: const InputDecoration(
                  label: Text(tName),
                  prefixIcon: Icon(Icons.business_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cnpjController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '##.###.###/####-##',),
              ],
              decoration: const InputDecoration(
                  label: Text(tCnpj), prefixIcon: Icon(Icons.numbers_rounded)),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cellphoneController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '(##) #####-####',),
              ],
              decoration: const InputDecoration(
                  label: Text(tCellphone),
                  prefixIcon: Icon(Icons.phone_android)
              ),
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {

                  registerClientBusiness(() {
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