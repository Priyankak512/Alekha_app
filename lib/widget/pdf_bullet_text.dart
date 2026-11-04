import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

pw.Widget buildPdfBulletText(
  String text, {
  pw.TextStyle? style,
  pw.TextStyle? boldStyle,
  bool isBold = false,
  double bulletSize = 3.5,
  PdfColor bulletColor = PdfColors.black,
  pw.Alignment align = pw.Alignment.centerLeft,
}) {
  final defaultStyle = style ?? const pw.TextStyle(fontSize: 10);
  final activeStyle = (isBold && boldStyle != null)
      ? boldStyle
      : (isBold
          ? pw.TextStyle(
              fontSize: defaultStyle.fontSize ?? 10,
              fontWeight: pw.FontWeight.bold,
              color: defaultStyle.color,
            )
          : defaultStyle);

  if (!text.contains('\n') &&
      !text.trimLeft().startsWith('\u2022') &&
      !text.trimLeft().startsWith('- ') &&
      !text.trimLeft().startsWith('* ')) {
    return pw.Align(
      alignment: align,
      child: pw.Text(text, style: activeStyle),
    );
  }

  final lines = text.split('\n');
  return pw.Align(
    alignment: align,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: lines.map((line) {
        final trimmed = line.trimLeft();
        if (trimmed.startsWith('\u2022') ||
            trimmed.startsWith('- ') ||
            trimmed.startsWith('* ')) {
          final textPart = trimmed.startsWith('\u2022')
              ? trimmed.substring(1).trimLeft()
              : trimmed.substring(2).trimLeft();

          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Container(
                  margin: pw.EdgeInsets.only(
                    top: (activeStyle.fontSize ?? 10) * 0.35,
                    right: 4,
                  ),
                  width: bulletSize,
                  height: bulletSize,
                  decoration: pw.BoxDecoration(
                    color: bulletColor,
                    shape: pw.BoxShape.circle,
                  ),
                ),
                pw.Expanded(
                  child: pw.Text(textPart, style: activeStyle),
                ),
              ],
            ),
          );
        } else {
          return pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 2),
            child: pw.Text(line, style: activeStyle),
          );
        }
      }).toList(),
    ),
  );
}

