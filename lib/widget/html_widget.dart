// import 'package:flutter/material.dart';
// import 'package:html_editor_enhanced/html_editor.dart';

// class HtmlEditorWidget extends StatelessWidget {
//   const HtmlEditorWidget({
//     super.key,
//     required this.jdDescriptionController,
//     this.initialText,
//     this.onValueChanged,
//     this.hintText,
//     this.isDisabled = false,
//     this.editorHeight,
//   });

//   final HtmlEditorController jdDescriptionController;
//   final String? initialText;
//   final dynamic onValueChanged;
//   final String? hintText;
//   final bool isDisabled;
//   final double? editorHeight;

//   @override
//   Widget build(BuildContext context) {
//     return HtmlEditor(
//         controller: jdDescriptionController,
//         htmlEditorOptions: HtmlEditorOptions(
//           hint: hintText ?? 'Your text here...',
//           shouldEnsureVisible: false,
//           initialText: initialText ?? "",
//           disabled: isDisabled,
//         ),
//         callbacks: Callbacks(onChangeContent: onValueChanged),
//         otherOptions: OtherOptions(height: editorHeight ?? 150),
//         htmlToolbarOptions: const HtmlToolbarOptions(
//             toolbarType: ToolbarType.nativeScrollable,
//             toolbarItemHeight: 20,
//             gridViewHorizontalSpacing: 0,
//             // dropdownBoxDecoration: BoxDecoration(),
//             defaultToolbarButtons: [
//               FontButtons(
//                   bold: true,
//                   italic: true,
//                   underline: false,
//                   clearAll: false,
//                   strikethrough: false,
//                   subscript: false,
//                   superscript: false),
//               StyleButtons(),
//               ListButtons(listStyles: false),
//               InsertButtons(
//                   picture: false,
//                   audio: false,
//                   video: false,
//                   otherFile: false,
//                   table: false,
//                   hr: false)
//             ]));
//   }
// }



