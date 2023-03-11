import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;

formseprator() => const SizedBox(
      height: 10,
    );

pw.Widget simplePaddingWidget(String text) => pw.Padding(
    padding: const pw.EdgeInsets.symmetric(horizontal: 2), child: pw.Text(text));
