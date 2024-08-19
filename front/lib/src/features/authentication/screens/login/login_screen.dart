import 'package:flutter/material.dart';

import '../../../../constants/sizes.dart';
import '../../../../commom_widgets/authentication_appbar.dart';
import 'login_footer_widget.dart';
import 'login_form_widget.dart';
import 'login_header_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
    @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        appBar: const WelcomeAppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(defaultSize),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double elementWidth;
                if (constraints.maxWidth < 800) {
                  elementWidth = double.infinity;
                } else {
                  elementWidth = constraints.maxWidth * 0.4;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: elementWidth,
                        child: LoginHeaderWidget(size: Size(constraints.maxWidth, constraints.maxHeight)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: elementWidth,
                        child: const LoginForm(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: elementWidth,
                        child: const LoginFooterWidget(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}