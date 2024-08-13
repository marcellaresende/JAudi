
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jaudi/src/features/core/screens/client_business/client_business_list_screen.dart';
import 'package:jaudi/src/features/core/screens/client_business/register_client_business_screen.dart';
import 'package:jaudi/src/features/core/screens/products/products_list_screen.dart';
import 'package:jaudi/src/features/core/screens/products/register_products_screen.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/register_supplier_business_form_widget.dart';
import 'package:jaudi/src/features/core/screens/supplier_business/supplier_business_list_screen.dart';
import 'package:jaudi/src/features/core/screens/worker/register_worker_screen.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import '../../../../../constants/colors.dart';
import '../../../../../constants/sizes.dart';
import '../../../../../constants/text_strings.dart';
import '../../supplier_business/register_supplier_business_screen.dart';
import '../../worker/worker_list_screen.dart';

class CentralControl extends StatelessWidget {
  const CentralControl({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Center(
        child: Wrap(
          spacing: homePadding,
          runSpacing: homePadding,
          alignment: WrapAlignment.center,
          children: [
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const RegisterWorkerScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_add, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterWorker,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const WorkerListScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.person_search, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tWorkers,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const RegisterSupplierBusinessScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_business_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterSupplierBusiness,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const SupplierBusinessListScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.business, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tSupplierBusinessList,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const RegisterClientBusinessScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_business_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterClientBusiness,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const ClientBusinessListScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.business_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tClientBusinessList,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const RegisterProductsScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.add_box_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tRegisterProducts,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const ProductsListScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_box_outline_blank_rounded, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tProductsList,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            /*FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () => Get.to(() => const AssistanceListScreen()),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.work_history, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          serviceHistory,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.attach_money, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          comissionControl,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
            FractionallySizedBox(
              widthFactor: 0.3,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: cardBgColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: SizedBox(
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.insert_chart_outlined, size: 40, color: darkColor),
                      const SizedBox(height: 10),
                      Flexible(
                        child: Text(
                          tDashboards,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(fontSize: 14.0, fontWeight: FontWeight.w600, color: darkColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}