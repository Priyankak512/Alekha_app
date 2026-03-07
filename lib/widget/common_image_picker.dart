import 'dart:io';

import 'package:alekha/constant/colors.dart';
import 'package:alekha/constant/get_platform.dart';
import 'package:alekha/services/general_helper.dart';
import 'package:alekha/constant/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ImagePickerControl extends StatefulWidget {
  const ImagePickerControl({
    super.key,
    required this.fieldName,
    this.bgColor,
    this.isEnabled = true,
    this.isRequired = false,
    this.onFileChange,
    this.isCandidatePhotoLabel = false,
  });

  final String fieldName;
  final Color? bgColor;
  final bool isEnabled;
  final bool isCandidatePhotoLabel;
  final bool isRequired;
  final dynamic onFileChange;

  @override
  State<ImagePickerControl> createState() => _ImagePickerControlState();
}
// Future<XFile?> _cropImage(XFile pickedImage, BuildContext context) async {

//   /// ❌ Web / Desktop me crop supported nahi (Flutter 3.19)
//   if (checkPlatForm(
//     context: context,
//     platforms: [
//       CustomPlatForm.WEB,CustomPlatForm.LARGE_LAPTOP_VIEW
//     ],
//   )) {
//     return pickedImage; // direct return
//   }

//   /// ✅ Mobile only
//   CroppedFile? croppedFile = await ImageCropper().cropImage(
//     sourcePath: pickedImage.path,
//     uiSettings: [
//       AndroidUiSettings(
//         toolbarTitle: 'Crop Image',
//         toolbarColor: PickColors.primaryColor,
//         toolbarWidgetColor: Colors.white,
//         activeControlsWidgetColor: PickColors.primaryColor,
//         lockAspectRatio: false,
//       ),
//       IOSUiSettings(
//         title: 'Crop Image',
//       ),
//     ],
//   );

//   if (croppedFile == null) return null;
//   return XFile(croppedFile.path);
// }


class _ImagePickerControlState extends State<ImagePickerControl> {
  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, GeneralHelper helper, snapshot) {
      return FormBuilderField(
          name: widget.fieldName,
          validator: FormBuilderValidators.compose([
            if (widget.isRequired)
              FormBuilderValidators.required(
                  errorText:
                      "Profile Image is Mandatory Please Select Profile picture."),
          ]),
          onChanged: widget.onFileChange,
          builder: (FormFieldState<dynamic> field) {
            print("============My Value===${field.value ?? []}============");

            return Center(
              child: InkWell(
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () async {
                  if ((field.value ?? []).isEmpty ||
                      ((field.value.last ?? "") == "")) {
                    XFile? pickedImage = await CustomImagePicker.show(
                      context,
                      !checkPlatForm(context: context, platforms: [
                        CustomPlatForm.MIN_MOBILE,
                        CustomPlatForm.MOBILE,
                        CustomPlatForm.TABLET,
                      ]),
                    );

                    // List<XFile?> imagesList = [];
                    // if (field.value != null) {
                    //   imagesList.addAll(field.value);
                    // }
                    // imagesList.add(pickedImage);
                    field.didChange([pickedImage]);
                  }
                },
                // onTap: () async {
                //   if ((field.value ?? []).isEmpty ||
                //       ((field.value.last ?? "") == "")) {
                //     XFile? pickedImage = await CustomImagePicker.show(
                //       context,
                //       !checkPlatForm(
                //         context: context,
                //         platforms: [
                //           CustomPlatForm.MIN_MOBILE,
                //           CustomPlatForm.MOBILE,
                //           CustomPlatForm.TABLET,
                //         ],
                //       ),
                //     );

                //     if (pickedImage == null) return;

                //     // ✅ Crop image after picking
                //     XFile? croppedImage =
                //         await _cropImage(pickedImage, context);

                //     if (croppedImage != null) {
                //       field.didChange([croppedImage]);
                //     }
                //   }
                // },

                child: MouseRegion(
                  hitTestBehavior: HitTestBehavior.deferToChild,
                  cursor: SystemMouseCursors.click,
                  child: (field.value ?? []).isEmpty ||
                          ((field.value.last ?? "") == "")
                      ? Container(
                          // constraints:
                          //     BoxConstraints(maxHeight: 120, maxWidth: 120),
                          decoration: BoxDecoration(
                            // shape: BoxShape.circle,
                            color: widget.bgColor ?? PickColors.whiteColor,
                          ),
                          child: const Icon(Icons.camera_alt_outlined))
                      : Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              constraints: const BoxConstraints(
                                  maxHeight: 80, maxWidth: 80),
                              decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: checkPlatForm(
                                                context: context,
                                                platforms: [
                                                  CustomPlatForm.MIN_MOBILE,
                                                  CustomPlatForm.MOBILE,
                                                  CustomPlatForm.TABLET,
                                                ]) &&
                                            !field.value.last.path.contains(
                                                'Documents/Recruitment/CandidatePhoto')
                                        ? FileImage(File(field.value.last.path))
                                        : NetworkImage(field.value.last.path)
                                            as ImageProvider,
                                  ),
                                  color: widget.bgColor ??
                                      PickColors.secondaryBGColor),
                            ),
                            Positioned(
                              top: -10,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  field.didChange([]);
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(.7),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: Alignment.center,
                                  height: 22,
                                  width: 22,
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                ),
              ),
            );
          });
    });
  }
}




class CommonMultipleImagePicker {
  static final ImagePicker _picker = ImagePicker();

  /// ✅ Pick multiple images from gallery
  static Future<List<File>> pickMultipleImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();

    if (pickedFiles == null || pickedFiles.isEmpty) {
      return [];
    }

    return pickedFiles.map((xFile) => File(xFile.path)).toList();
  }
}



// import 'dart:io';
// import 'dart:typed_data';

// import 'package:alekha/constant/colors.dart';
// import 'package:alekha/constant/get_platform.dart';
// import 'package:alekha/services/general_helper.dart';
// import 'package:alekha/constant/image_picker_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_form_builder/flutter_form_builder.dart';
// import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:image_editor_plus/image_editor_plus.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:provider/provider.dart';

// class ImagePickerControl extends StatefulWidget {
//   const ImagePickerControl({
//     super.key,
//     required this.fieldName,
//     this.bgColor,
//     this.isEnabled = true,
//     this.isRequired = false,
//     this.onFileChange,
//     this.isCandidatePhotoLabel = false,
//   });

//   final String fieldName;
//   final Color? bgColor;
//   final bool isEnabled;
//   final bool isCandidatePhotoLabel;
//   final bool isRequired;
//   final dynamic onFileChange;

//   @override
//   State<ImagePickerControl> createState() => _ImagePickerControlState();
// }

// class _ImagePickerControlState extends State<ImagePickerControl> {
//   /// Image pick karke editor open karo, edited bytes ko temp file me save karo
//   Future<XFile?> _pickAndEditImage(BuildContext context, bool isWeb) async {
//     // Step 1: Image pick karo
//     XFile? pickedImage = await CustomImagePicker.show(context, isWeb);
//     if (pickedImage == null) return null;

//     // Step 2: Bytes padhlo
//     final Uint8List originalBytes = await pickedImage.readAsBytes();

//     // Step 3: image_editor_plus ka ImageEditor open karo
//     // Ye editor crop, rotate, draw, text, filters sab deta hai
//     final Uint8List? editedBytes = await Navigator.push<Uint8List>(
//       context,
//       MaterialPageRoute(
//         builder: (_) => ImageEditor(
//           image: originalBytes,
//         ),
//       ),
//     );

//     // Agar user ne cancel kiya to original image use karo
//     final Uint8List finalBytes = editedBytes ?? originalBytes;

//     // Step 4: Edited bytes ko temp file me save karo
//     final tempDir = await getTemporaryDirectory();
//     final fileName = 'edited_${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final tempFile = File('${tempDir.path}/$fileName');
//     await tempFile.writeAsBytes(finalBytes);

//     return XFile(tempFile.path);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer(builder: (context, GeneralHelper helper, snapshot) {
//       return FormBuilderField(
//         name: widget.fieldName,
//         validator: FormBuilderValidators.compose([
//           if (widget.isRequired)
//             FormBuilderValidators.required(
//                 errorText:
//                     "Profile Image is Mandatory. Please select a profile picture."),
//         ]),
//         onChanged: widget.onFileChange,
//         builder: (FormFieldState<dynamic> field) {
//           final bool isEmpty =
//               (field.value ?? []).isEmpty || ((field.value?.last ?? "") == "");

//           return Center(
//             child: InkWell(
//               focusColor: Colors.transparent,
//               hoverColor: Colors.transparent,
//               onTap: () async {
//                 if (!isEmpty) return; // Already has image, tap on X to remove

//                 final bool isWeb = !checkPlatForm(
//                   context: context,
//                   platforms: [
//                     CustomPlatForm.MIN_MOBILE,
//                     CustomPlatForm.MOBILE,
//                     CustomPlatForm.TABLET,
//                   ],
//                 );

//                 // Pick + Edit image
//                 XFile? editedImage = await _pickAndEditImage(context, isWeb);

//                 if (editedImage != null) {
//                   field.didChange([editedImage]);
//                 }
//               },
//               child: MouseRegion(
//                 hitTestBehavior: HitTestBehavior.deferToChild,
//                 cursor: SystemMouseCursors.click,
//                 child: isEmpty
//                     ? Container(
//                         decoration: BoxDecoration(
//                           color: widget.bgColor ?? PickColors.whiteColor,
//                         ),
//                         child: const Icon(Icons.camera_alt_outlined),
//                       )
//                     : Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           // ── Image preview ──
//                           GestureDetector(
//                             // Long press se re-edit karo
//                             onLongPress: () async {
//                               final bool isWeb = !checkPlatForm(
//                                 context: context,
//                                 platforms: [
//                                   CustomPlatForm.MIN_MOBILE,
//                                   CustomPlatForm.MOBILE,
//                                   CustomPlatForm.TABLET,
//                                 ],
//                               );

//                               final currentPath = field.value?.last?.path ?? '';
//                               if (currentPath.isEmpty) return;

//                               final Uint8List currentBytes =
//                                   await File(currentPath).readAsBytes();

//                               final Uint8List? reEditedBytes =
//                                   await Navigator.push<Uint8List>(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (_) => ImageEditor(
//                                     image: currentBytes,
//                                   ),
//                                 ),
//                               );

//                               if (reEditedBytes != null) {
//                                 final tempDir = await getTemporaryDirectory();
//                                 final tempFile = File(
//                                     '${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg');
//                                 await tempFile.writeAsBytes(reEditedBytes);
//                                 field.didChange([XFile(tempFile.path)]);
//                               }
//                             },
//                             child: Container(
//                               constraints: const BoxConstraints(
//                                   maxHeight: 80, maxWidth: 80),
//                               decoration: BoxDecoration(
//                                 image: DecorationImage(
//                                   image: checkPlatForm(
//                                               context: context,
//                                               platforms: [
//                                                 CustomPlatForm.MIN_MOBILE,
//                                                 CustomPlatForm.MOBILE,
//                                                 CustomPlatForm.TABLET,
//                                               ]) &&
//                                           !field.value.last.path.contains(
//                                               'Documents/Recruitment/CandidatePhoto')
//                                       ? FileImage(File(field.value.last.path))
//                                           as ImageProvider
//                                       : NetworkImage(field.value.last.path)
//                                           as ImageProvider,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 color: widget.bgColor ??
//                                     PickColors.secondaryBGColor,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ),
//                           ),

//                           // ── Edit icon (bottom-left) ──
//                           Positioned(
//                             bottom: -8,
//                             left: 0,
//                             child: GestureDetector(
//                               onTap: () async {
//                                 final bool isWeb = !checkPlatForm(
//                                   context: context,
//                                   platforms: [
//                                     CustomPlatForm.MIN_MOBILE,
//                                     CustomPlatForm.MOBILE,
//                                     CustomPlatForm.TABLET,
//                                   ],
//                                 );

//                                 final currentPath =
//                                     field.value?.last?.path ?? '';
//                                 if (currentPath.isEmpty) return;

//                                 final Uint8List currentBytes =
//                                     await File(currentPath).readAsBytes();

//                                 final Uint8List? reEditedBytes =
//                                     await Navigator.push<Uint8List>(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => ImageEditor(
//                                       image: currentBytes,
//                                     ),
//                                   ),
//                                 );

//                                 if (reEditedBytes != null) {
//                                   final tempDir = await getTemporaryDirectory();
//                                   final tempFile = File(
//                                       '${tempDir.path}/edited_${DateTime.now().millisecondsSinceEpoch}.jpg');
//                                   await tempFile.writeAsBytes(reEditedBytes);
//                                   field.didChange([XFile(tempFile.path)]);
//                                 }
//                               },
//                               child: Container(
//                                 margin: const EdgeInsets.all(3),
//                                 decoration: BoxDecoration(
//                                   color:
//                                       PickColors.primaryColor.withOpacity(0.85),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 alignment: Alignment.center,
//                                 height: 22,
//                                 width: 22,
//                                 child: const Icon(
//                                   Icons.edit,
//                                   size: 14,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),

//                           // ── Remove / Close icon (top-right) ──
//                           Positioned(
//                             top: -10,
//                             right: 0,
//                             child: InkWell(
//                               onTap: () => field.didChange([]),
//                               child: Container(
//                                 margin: const EdgeInsets.all(3),
//                                 decoration: BoxDecoration(
//                                   color: Colors.grey.withOpacity(.7),
//                                   shape: BoxShape.circle,
//                                 ),
//                                 alignment: Alignment.center,
//                                 height: 22,
//                                 width: 22,
//                                 child: const Icon(
//                                   Icons.close,
//                                   size: 18,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//               ),
//             ),
//           );
//         },
//       );
//     });
//   }
// }

// // ─────────────────────────────────────────────────────────────────────────────
// // Multi-image picker helper (unchanged)
// // ─────────────────────────────────────────────────────────────────────────────
// class CommonMultipleImagePicker {
//   static final ImagePicker _picker = ImagePicker();

//   static Future<List<File>> pickMultipleImages() async {
//     final List<XFile> pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles.isEmpty) return [];
//     return pickedFiles.map((xFile) => File(xFile.path)).toList();
//   }
// }
