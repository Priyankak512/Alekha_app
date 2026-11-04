// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'dart:typed_data';
import 'package:alekha/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:image_editor_plus/image_editor_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class CustomImagePicker {
  /// Opens the WhatsApp-style full editor after image selection
  static Future<XFile?> _openEditor(BuildContext context, XFile pickedFile) async {
    try {
      final Uint8List originalBytes = await pickedFile.readAsBytes();

      if (!context.mounted) return pickedFile;

      final dynamic result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ImageEditor(
            image: originalBytes,
          ),
        ),
      );

      if (result != null && result is Uint8List) {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(result);
        return XFile(tempFile.path);
      } else {
        // If user cancelled editing or didn't change anything, return original picked image
        return pickedFile;
      }
    } catch (e) {
      debugPrint("Error opening image editor: $e");
      return pickedFile;
    }
  }

  static Future<XFile?> show(BuildContext context, bool isOnlyGallery) async {
    ImageSource? source;

    if (isOnlyGallery) {
      source = ImageSource.gallery;
    } else {
      source = await showDialog<ImageSource>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text(
              "Choose your image",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Open Sans",
              ),
            ),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PickColors.buttonColor,
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
                  onPressed: () {
                    Navigator.of(dialogContext).pop(ImageSource.gallery);
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PickColors.buttonColor,
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
                  onPressed: () {
                    Navigator.of(dialogContext).pop(ImageSource.camera);
                  },
                )
              ],
            ),
          );
        },
      );
    }

    if (source == null) return null;

    final pickedFile = await ImagePicker().pickImage(
      source: source,
      imageQuality: 85,
    );

    if (pickedFile == null) return null;

    if (!context.mounted) return pickedFile;

    return await _openEditor(context, pickedFile);
  }
}
