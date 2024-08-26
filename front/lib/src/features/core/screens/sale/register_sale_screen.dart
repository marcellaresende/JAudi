import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaudi/src/features/core/screens/products/register_products_form_widget.dart';
import 'package:jaudi/src/features/core/screens/sale/register_sale_form_widget.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/register_supplier_business_form_widget.dart';
import '../../../../commom_widgets/form_header_widget.dart';
import '../../../../constants/images_strings.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../home_screen/widgets/app_bar.dart';


class RegisterSaleScreen extends StatelessWidget{
  const RegisterSaleScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            double elementWidth;
            if (constraints.maxWidth < 800) {
              elementWidth = double.infinity;
            } else {
              elementWidth = constraints.maxWidth * 0.3;
            }

            return Container(
              padding: const EdgeInsets.all(defaultSize),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: elementWidth,
                      child: const FormHeaderWidget(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        image: welcomeImage,
                        title: tRegisterSaleTitle,
                        subTitle: tRegisterSaleSubTitle,
                        imageHeight: 0.15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: elementWidth,
                      child: const RegisterSaleFormWidget(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}




