import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/register_supplier_business_form_widget.dart';
import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../home_screen/widgets/app_bar.dart';


class RegisterSupplierBusinessScreen extends StatelessWidget{
  const RegisterSupplierBusinessScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(defaultSize),
          child: const Column(
            children: [
              FormHeaderWidget(
                crossAxisAlignment: CrossAxisAlignment.center,
                image: welcomeImage,
                title: tRegisterSupplierBusinessTitle,
                subTitle: tRegisterSupplierBusinessSubTitle,
                imageHeight: 0.15,
              ),
              RegisterSupplierBusinessFormWidget(),
            ],
          ),
        ),
      ),
    );
  }
}





