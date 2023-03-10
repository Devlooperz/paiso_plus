import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GenerateBills extends StatelessWidget {
  const GenerateBills({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            //602296375 vat    30595996 bnb(pan)
              onPressed: () async {
                final pdf = pw.Document();
                pdf.addPage(pw.MultiPage(
                  pageFormat: PdfPageFormat.a4,
                  margin: const pw.EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  header: (context) => pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.Column(children: [
                          pw.Text("Apple Computer Suppliers",
                              style: const pw.TextStyle(fontSize: 25)),
                          pw.Text("Sandhikharka, Arghakhanchi"),
                          pw.SizedBox(height: 15)
                        ]),
                      ]),
                  build: (context) => [
                    pw.Table(
                        tableWidth: pw.TableWidth.max,
                        border: pw.TableBorder.all(),
                        children: [
                          pw.TableRow(children: [
                            pw.Text("Date"),
                            pw.Text("Product"),
                            pw.Text("Rate"),
                            pw.Text("Qty"),
                            pw.Text("Amt")
                          ]),
                          pw.TableRow(children: [
                            pw.Text("2022-03-0600000000000000"),
                            pw.Text("120GB SSD Sandisk 12xfdgj000000"),
                            pw.Text("10,00000000000000"),
                            pw.Text("50000000000000000"),
                            pw.Text("5000000000000000000")
                          ]),
                        ])
                  ],
                ));
                final byte = await pdf.save();
                final dir = await getApplicationDocumentsDirectory();
                final file = File('${dir.path}/data.pdf');

                file.writeAsBytes(byte);
              },
              child: const Text("Generate Pdf"))
        ],
      ),
    );
  }
}
