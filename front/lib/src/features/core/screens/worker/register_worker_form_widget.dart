import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:jaudi/src/features/core/screens/worker/worker_list_screen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../../../../commom_widgets/alert_dialog.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/sizes.dart';
import 'package:http/http.dart' as http;
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';
import '../home_screen/home_screen.dart';
import 'worker.dart';

class RegisterWorkerFormWidget extends StatefulWidget {
  const RegisterWorkerFormWidget({
    super.key,
  });

  @override
  _RegisterWorkerFormWidget createState() => _RegisterWorkerFormWidget();

}

class _RegisterWorkerFormWidget extends State<RegisterWorkerFormWidget> {
  final TextEditingController workerController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController cellphoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegExp.hasMatch(email);
  }

  final FocusNode _passwordFocusNode = FocusNode();
  bool _isVisiblePassword = false;
  bool _isVisibleConfirmPassword = false;
  bool _isPasswordEightCharacters = false;
  bool _hasPasswordOneNumber = false;
  bool _hasPasswordUppercase = false;
  bool _hasPasswordLowercase = false;
  bool _hasPasswordSpecialCharacters = false;

  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final upperRegex = RegExp(r'[A-Z]');
    final lowerRegex = RegExp(r'[a-z]');
    final specialRegex = RegExp(r'[@$!%*?&]');

    setState(() {
      _isPasswordEightCharacters = false;
      if (password.length >= 8)
        _isPasswordEightCharacters = true;

      _hasPasswordOneNumber = false;
      if (numericRegex.hasMatch(password))
        _hasPasswordOneNumber = true;

      _hasPasswordUppercase = false;
      if (upperRegex.hasMatch(password))
        _hasPasswordUppercase = true;

      _hasPasswordLowercase = false;
      if (lowerRegex.hasMatch(password))
        _hasPasswordLowercase = true;

      _hasPasswordSpecialCharacters = false;
      if (specialRegex.hasMatch(password))
        _hasPasswordSpecialCharacters = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future<void> registerWorker(VoidCallback onSuccess) async {
      String worker = workerController.text;
      String cellphone = cellphoneController.text;
      String email = emailController.text;
      String cpf = cpfController.text;
      String password = passwordController.text;

      if (worker.isEmpty ||
          cellphone.isEmpty ||
          email.isEmpty ||
          cpf.isEmpty ||
          password.isEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'Todos os campos são obrigatórios.');
          },
        );
        return;
      }

      if (worker.length == 1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O nome deve conter mais que um carácter');
          },
        );
        return;
      }

      if (!isValidEmail(email)) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription: 'O email inserido é inválido.');
          },
        );
        return;
      }

      if (cpfController.text.replaceAll(RegExp(r'\D'), '').length != 11) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return const AlertPopUp(
                errorDescription:
                'O número do CPF deve conter exatamente 11 dígitos.');
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



      WorkerRequest workerRequest = WorkerRequest(
          name: worker,
          email: email,
          cpf: cpf,
          cellphone: cellphone,
          password: password,
      );

      String requestBody = jsonEncode(workerRequest.toJson());
      print(requestBody);

      try {
        final response = await http.post(
          Uri.parse('http://localhost:8080/api/central/worker'),
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
          print('Registration failed. Status code: ${response.statusCode}');

          if (response.body == 'Email já cadastrado!' || response.body ==  "CPF do funcionário já cadastrado!") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertPopUp(
                    errorDescription: response.body,
                    onConfirmed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkerListScreen(),
                        ),
                      );
                    },
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertPopUp(
                    errorDescription: response.body,
                  );
                });
          }

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
              controller: workerController,
              decoration: const InputDecoration(
                  label: Text(tFullName),
                  prefixIcon: Icon(Icons.person_outline_rounded)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                  label: Text(tEmail),
                  prefixIcon: Icon(Icons.email_outlined)
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: cpfController,
              inputFormatters: [
                MaskTextInputFormatter(mask: '###.###.###-##',),
              ],
              decoration: const InputDecoration(
                  label: Text(tCpf),
                  prefixIcon: Icon(Icons.numbers)
              ),
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
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: passwordController,
              onChanged: (passwordController) => onPasswordChanged(passwordController),
              obscureText: !_isVisiblePassword,
              focusNode: _passwordFocusNode,
              onTap: () {
                setState(() {
                  _isPasswordEightCharacters = false;
                  _hasPasswordOneNumber = false;
                  _hasPasswordLowercase = false;
                  _hasPasswordUppercase = false;
                  _hasPasswordSpecialCharacters = false;
                });
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: tPassword,
                hintText: tPassword,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisiblePassword = !_isVisiblePassword;
                    });
                  },
                  icon: _isVisiblePassword ? const Icon(Icons.visibility) :
                  const Icon(Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: formHeight - 29),
            Visibility(
              visible: _passwordFocusNode.hasFocus,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: formHeight - 20),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _isPasswordEightCharacters ? Colors.green : Colors.transparent,
                            border: _isPasswordEightCharacters ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check, color: whiteColor, size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(tNumberOfCharacters, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                  const SizedBox(height: formHeight - 29),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _hasPasswordOneNumber ? Colors.green : Colors.transparent,
                            border: _hasPasswordOneNumber ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                            child: Icon(
                              Icons.check,
                              color: whiteColor,
                              size: 10,
                            )
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(tNumberCharacter, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                  const SizedBox(height: formHeight - 29),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _hasPasswordLowercase ? Colors.green : Colors.transparent,
                            border: _hasPasswordLowercase ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(tLowercaseCharacter, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                  const SizedBox(height: formHeight - 29),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _hasPasswordUppercase ? Colors.green : Colors.transparent,
                            border: _hasPasswordUppercase ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(tUppercaseCharacter, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                  const SizedBox(height: formHeight - 29),
                  Row(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                            color: _hasPasswordSpecialCharacters ? Colors.green : Colors.transparent,
                            border: _hasPasswordSpecialCharacters ? Border.all(color: Colors.transparent) : Border.all(color: primaryColor),
                            borderRadius: BorderRadius.circular(50)
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check,
                            color: whiteColor,
                            size: 10,
                          ),
                        ),
                      ),
                      const SizedBox(width: formHeight - 25),
                      Text(tSpecialCharacter, style: Theme.of(context).textTheme.overline)
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: formHeight - 20),
            TextFormField(
              controller: confirmPasswordController,
              onChanged: (confirmPasswordController) => onPasswordChanged(confirmPasswordController),
              obscureText: !_isVisibleConfirmPassword,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.fingerprint),
                labelText: tConfirmPassword,
                hintText: tConfirmPassword,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _isVisibleConfirmPassword = !_isVisibleConfirmPassword;
                    });
                  },
                  icon: _isVisibleConfirmPassword ? const Icon(Icons.visibility) :
                  const Icon(Icons.visibility_off),
                ),
              ),
            ),
            const SizedBox(height: formHeight - 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  String password = passwordController.text;
                  String confirmPassword = confirmPasswordController.text;

                  if (password != confirmPassword) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const AlertPopUp(
                            errorDescription: 'As senhas não coincidem ');
                      },
                    );
                  } else {
                    registerWorker(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen())
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cadastro Realizado')),
                      );
                    });
                  }
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