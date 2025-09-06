// ignore_for_file: use_build_context_synchronously
import 'package:alekha/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CustomImagePicker {
  static Future<XFile?> show(BuildContext context, bool isOnlyGallery) async {
    XFile? image;
    if (isOnlyGallery) {
      final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
          imageQuality: 25,
          maxHeight: 500, // <- reduce the image size
          maxWidth: 500);
      // Navigator.of(context).pop();
      image = pickedFile!;
    } else {
      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Choose your image",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Open Sans",
                )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PickColors.buttonColor, // background
                  ),
                  child: const Text(
                    "Gallery",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Open Sans",
                    ),
                  ),
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        imageQuality: 25,
                        maxHeight: 500, // <- reduce the image size
                        maxWidth: 500);

                    Navigator.of(context).pop();
                    image = pickedFile!;
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PickColors.buttonColor, // background
                  ),
                  child: const Text(
                    "Camera",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Open Sans",
                    ),
                  ),
                  onPressed: () async {
                    final pickedFile = await ImagePicker().pickImage(
                        source: ImageSource.camera,
                        imageQuality: 25,
                        maxHeight: 500, // <- reduce the image size
                        maxWidth: 500);
                    Navigator.of(context).pop();
                    image = pickedFile!;
                  },
                )
              ],
            ),
          );
        },
      );
    }

    return image;
  }
}
