import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:paiso_plus/core/config/constants.dart';
import 'package:paiso_plus/core/config/currency_formatter.dart';
import 'package:paiso_plus/core/database/my_database.dart';
import 'package:paiso_plus/core/providers/customer_provider/customer_provider.dart';
import 'package:path_provider/path_provider.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class GenerateBills extends StatefulWidget {
  const GenerateBills({super.key});

  @override
  State<GenerateBills> createState() => _GenerateBillsState();
}

class _GenerateBillsState extends State<GenerateBills> {
  Customer? customer;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  Future<void> generatePdf([bool isBnb = false]) async {
    if (formkey.currentState?.validate() ?? false) {
      final customerData = await MyDatabase()
          .transactionsDao
          .getTransactionByCustomer(customer!.id);
      final totalAmount = customerData.fold(
          0.0,
          (previousValue, element) =>
              previousValue += (element.quantity * element.rate));
      final vatAmount = (totalAmount * 13) / 100;
      final pdf = pw.Document();
      pdf.addPage(pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        header: (context) => pw.Column(children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.center, children: [
            pw.Column(children: [
              pw.Text(
                  isBnb ? "BNB Computer Suppliers" : "Apple Computer Suppliers",
                  style: const pw.TextStyle(fontSize: 25)),
              pw.Text("Sandhikharka, Arghakhanchi"),
              pw.SizedBox(height: 15),
            ]),
          ]),
          pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text("Name: ${customer!.name}"),
                pw.Text(
                  isBnb ? "PAN:30595996" : "VAT:602296375",
                )
              ]),
          pw.SizedBox(
            height: 5,
          )
        ]),
        build: (context) => [
          pw.Table(
              tableWidth: pw.TableWidth.max,
              border: pw.TableBorder.all(),
              children: [
                pw.TableRow(children: [
                  simplePaddingWidget("Date"),
                  simplePaddingWidget("Product"),
                  simplePaddingWidget("Rate"),
                  simplePaddingWidget("Quantity"),
                  simplePaddingWidget("Amount"),
                ]),
                ...customerData
                    .map((e) => pw.TableRow(children: [
                          simplePaddingWidget(e.nepaliDateTime
                              .toIso8601String()
                              .split("T")
                              .first),
                          simplePaddingWidget(e.product.name),
                          simplePaddingWidget(
                            currencyFormat.format(e.rate),
                          ),
                          simplePaddingWidget(
                              currencyFormat.format(e.quantity)),
                          simplePaddingWidget(
                              currencyFormat.format(e.rate * e.quantity))
                        ]))
                    .toList()
              ]),
          pw.SizedBox(
            height: 20,
          ),
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.end, children: [
            pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
              pw.Text("Sum Amount: ${currencyFormat.format(totalAmount)}"),
              pw.Text("13% VAT: ${currencyFormat.format(vatAmount)}"),
              pw.Text(
                  "Total:  ${currencyFormat.format(totalAmount + vatAmount)}"),
            ])
          ]),
        ],
      ));
      final byte = await pdf.save();
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
          '${dir.path}/${isBnb ? 'BNB' : 'Apple'}_${customer!.name}_${NepaliDateTime.now()}.pdf');

      file.writeAsBytes(byte);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formkey,
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                final customerData = ref.watch(customerProvider);
                return DropdownSearch<Customer>(
                  validator: (value) {
                    if (value == null) {
                      return "Select Customer First";
                    }
                    return null;
                  },
                  popupProps: const PopupProps.menu(
                    showSearchBox: true,
                  ),
                  compareFn: (item1, item2) {
                    return item1.name == item2.name;
                  },
                  itemAsString: (item) => item.name,
                  onChanged: (value) {
                    customer = value;
                  },
                  items: customerData,
                  dropdownDecoratorProps: const DropDownDecoratorProps(
                    dropdownSearchDecoration:
                        InputDecoration(labelText: "Customer Name"),
                  ),
                );
              },
            ),
            ElevatedButton(
                //602296375 vat    30595996 bnb(pan)
                onPressed: () async {
                  await generatePdf(true);
                },
                child: const Text("Generate Pdf (BNB)")),
            ElevatedButton(
                onPressed: () async {
                  await generatePdf();
                },
                child: const Text("Generate PDF (Apple)"))
          ],
        ),
      ),
    );
  }
}
