import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jaudi/src/features/authentication/screens/login/login_screen.dart';

import '../constants/colors.dart';


class AlertPopUp extends StatelessWidget {
  const AlertPopUp({super.key, required this.errorDescription});

  final String errorDescription;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Icon(Icons.warning_rounded, color: primaryColor, size: 30),

      content: Text(errorDescription),
      actions: [
        TextButton(
          onPressed: () {
            if (errorDescription == 'Email já cadastrado!' || errorDescription == 'CNPJ já cadastrado!') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
            } else if (errorDescription == 'Email do cliente já cadastrado!' || errorDescription == 'CPF do cliente já cadastrado!') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
            } else if (errorDescription == 'Cliente não encontrado.') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
            }else if (errorDescription == 'Email já cadastrado!' || errorDescription ==  "CPF do funcionário já cadastrado!"){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const LoginScreen()));
            } else {Navigator.of(context).pop();}
          },
          child: const Text(
            'OK',
            style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}