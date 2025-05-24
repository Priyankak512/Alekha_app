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
                      if (GlobalList.projectFilesList[index]["id"] == "3") {
                        const url =
                            'https://drive.google.com/drive/folders/1ukuigvz1zphJqUhMzLh-g0R8u-fDt7ee?usp=drive_link';
                        await openUrl(url, context);
                      } else if (GlobalList.homeList[index]["id"] == "4") {
                        const url =
                            'https://drive.google.com/drive/folders/1-bwTv0ih6bQtXQAtrtZW-oOd4xGR50gD?usp=drive_link';
                        await openUrl(url, context);
                      } else if (GlobalList.homeList[index]["id"] == "5") {
                        const url =
                            'https://drive.google.com/drive/folders/1AR_qwauqLKcJLUlZQ-_uypidVujRKhZX?usp=sharing';

                        await openUrl(url, context);
                      } else if (GlobalList.homeList[index]["id"] == "6") {
                        const url =
                            'https://drive.google.com/drive/folders/1A9DJzY49lSDZK7iStogIHQByrTBjG2j4?usp=drive_link';

                        await openUrl(url, context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Link not available')),
                        );
                      }
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

  Future<void> openUrl(String url, BuildContext context) async {
    final Uri uri = Uri.parse(url);

    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(uri, mode: LaunchMode.inAppBrowserView)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the link')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong!')),
      );
    }
  }
}
