import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/global_list.dart';
import 'package:alekha/constant/navigation_route.dart';
import 'package:alekha/constant/text_style.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectFilesScreen extends StatefulWidget {
  const ProjectFilesScreen({super.key});

  @override
  State<ProjectFilesScreen> createState() => _ProjectFilesScreenState();
}

class _ProjectFilesScreenState extends State<ProjectFilesScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: PickColors.whiteColor,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () {
              backToScreen(context: context);
            },
            child: Icon(
              Icons.arrow_left_outlined,
              color: PickColors.hintColor,
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text(
            'Project Files',
            style: CommonTextStyle().appBarTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: GlobalList.projectFilesList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      final link = GlobalList.projectFilesList[index]["link"];
                      if (link != null && link.isNotEmpty) {
                        final uri = Uri.parse(link);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri,
                              mode: LaunchMode.externalApplication);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Could not launch link')),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link not available')),
                        );
                      }

                      // final link = GlobalList.projectFilesList[index]["link"];
                      // if (link != null && link.isNotEmpty) {
                      //   final uri = Uri.parse(link);
                      //   if (await canLaunchUrl(uri)) {
                      //     await launchUrl(uri,
                      //         mode: LaunchMode.externalApplication);
                      //   } else {
                      //     ScaffoldMessenger.of(context).showSnackBar(
                      //       const SnackBar(
                      //           content: Text('Could not launch link')),
                      //     );
                      //   }
                      // } else {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(content: Text('Link not available')),
                      //   );
                      // }
                    },
                    child: Container(
                      margin: const EdgeInsets.all(5.00),
                      padding: const EdgeInsets.all(5.00),
                      decoration: BoxDecoration(
                        border: Border.all(color: PickColors.primaryColor),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5.00),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.folder_copy_outlined),
                          const SizedBox(width: 8),
                          Text(GlobalList.projectFilesList[index]["title"]
                              .toString()),
                          const Spacer(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
