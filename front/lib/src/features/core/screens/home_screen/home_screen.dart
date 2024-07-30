import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaudi/src/features/core/screens/home_screen/widgets/app_bar.dart';
import 'package:jaudi/src/features/core/screens/home_screen/widgets/central_control.dart';
import '../../../../constants/sizes.dart';
import '../../../../constants/text_strings.dart';
import '../../../authentication/screens/signup/central_manager.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();



}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: SingleChildScrollView(
        child: Container(
        padding: const EdgeInsets.all(homePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            //Heading
            Text(tHomePageTitle,
                //+ CentralManager.instance.loggedUser!.central.name,
              style: Theme.of(context).textTheme.bodyText2,
            ),
            Text(tExplore, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),

            //Search Box
            const SearchBar(),
            const SizedBox(height: homePadding,),

            //Control Center
            Text(tControlCenter, style: Theme.of(context).textTheme.headline2,),
            const SizedBox(height: homePadding,),
            const CentralControl(),
            const SizedBox(height: homePadding,),

            //
          ],
          ),
        ),
      ),
    );
  }
}





