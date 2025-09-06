

import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:alekha/screens/home/home_common_widgets/icon_title_container.dart';
import 'package:flutter/material.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: PickColors.whiteColor,
        appBar: AppBar(
          backgroundColor: PickColors.whiteColor,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              backToScreen(context: context);
            },
            child: Icon(
              Icons.arrow_left_outlined,
              size: 35,
              color: PickColors.hintColor,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Forms',
            style: CommonTextStyle().appBarTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 columns in the grid
              mainAxisSpacing: 8.0, // vertical space between items
              crossAxisSpacing: 8.0, // horizontal space between items
            ),
            itemCount: GlobalList.formsList.length,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  changeScreen(
                    context: context,
                    widget: GlobalList.formsList[index]["screen"],
                  );
                },
                child: IconTitleContainer(
                  mainIcon: GlobalList.formsList[index]["icon"],
                  mainText: GlobalList.formsList[index]["title"].toString()
                      .toUpperCase(),
                  subText: "",
                  mainTextTextStyle: CommonTextStyle().sectionTextStyle,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
