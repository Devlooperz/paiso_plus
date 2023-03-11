import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paiso_plus/core/config/constants.dart';
import 'package:paiso_plus/core/config/currency_formatter.dart';
import 'package:paiso_plus/core/config/styles.dart';
import 'package:paiso_plus/core/config/validators.dart';
import 'package:paiso_plus/core/database/my_database.dart';
import 'package:paiso_plus/features/transaction/provider/add_transaction_provider.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';

// class AddTransaction extends ConsumerWidget {
//   AddTransaction({super.key});
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final data = ref.watch(addTransactionProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Add Transaction"),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
//         child: Row(
//           children: [
//             Expanded(
//               child: Form(
//                 key: formkey,
//                 child: Column(
//                   children: [
//                     DropdownSearch<Customer>(
//                       validator: (value) {
//                         if (value == null) {
//                           return "Select Customer First";
//                         }
//                         return null;
//                       },
//                       popupProps: const PopupProps.menu(
//                         showSearchBox: true,
//                       ),
//                       compareFn: (item1, item2) {
//                         return item1.name == item2.name;
//                       },
//                       itemAsString: (item) => item.name,
//                       onChanged: (value) {
//                         ref
//                             .read(addTransactionProvider.notifier)
//                             .changeCustomer(value);
//                       },
//                       items:
//                           ref.read(addTransactionProvider.notifier).customers,
//                       dropdownDecoratorProps: const DropDownDecoratorProps(
//                         dropdownSearchDecoration:
//                             InputDecoration(labelText: "Customer Name"),
//                       ),
//                       selectedItem:
//                           ref.read(addTransactionProvider.notifier).customer,
//                     ),
//                     formseprator(),
//                     DropdownSearch<Product>(
//                       validator: (value) {
//                         if (value == null) {
//                           return "Select Product";
//                         }
//                         return null;
//                       },
//                       popupProps: const PopupProps.menu(
//                         showSearchBox: true,
//                       ),
//                       dropdownDecoratorProps: const DropDownDecoratorProps(
//                           dropdownSearchDecoration:
//                               InputDecoration(labelText: "Product")),
//                       itemAsString: (item) => item.name,
//                       compareFn: (item1, item2) => item1.name == item2.name,
//                       onChanged: ref
//                           .read(addTransactionProvider.notifier)
//                           .changeProduct,
//                       items: ref.read(addTransactionProvider.notifier).products,
//                       selectedItem: null,
//                     ),
//                     formseprator(),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: TextFormField(
//                             validator: (value) =>
//                                 Validators.emptyText(value, "Rate"),
//                             inputFormatters: [
//                               FilteringTextInputFormatter.allow(
//                                   RegExp(r'^\d+\.?\d{0,2}'))
//                             ],
//                             decoration: const InputDecoration(
//                                 labelText: "Rate",
//                                 border: OutlineInputBorder()),
//                             controller: ref
//                                 .read(addTransactionProvider.notifier)
//                                 .rateEditingController,
//                           ),
//                         ),
//                         const SizedBox(
//                           width: 10,
//                         ),
//                         Expanded(
//                           child: TextFormField(
//                             validator: (value) =>
//                                 Validators.emptyText(value, "Quantity"),
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             decoration: const InputDecoration(
//                                 labelText: "Quantity",
//                                 border: OutlineInputBorder()),
//                             controller: ref
//                                 .read(addTransactionProvider.notifier)
//                                 .quantityController,
//                           ),
//                         )
//                       ],
//                     ),
//                     formseprator(),
//                     ElevatedButton.icon(
//                         onPressed: () {
//                           if (formkey.currentState?.validate() ?? false) {
//                             ref
//                                 .read(addTransactionProvider.notifier)
//                                 .addNewTransaction();
//                           }
//                         },
//                         icon: const Icon(Icons.arrow_right),
//                         label: const Text("Add"))
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             SizedBox(
//               width: MediaQuery.of(context).size.width * 0.45,
//               child: ListView.separated(
//                   separatorBuilder: (context, index) => formseprator(),
//                   itemCount: data.length,
//                   itemBuilder: (context, index) {
//                     final transactionData = data[index];
//                     return Container(
//                       height: 60,
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 4),
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(15),
//                         border:
//                             Border.all(color: Colors.grey.shade300, width: 2),
//                       ),
//                       child: Row(
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 transactionData.product.name,
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ],
//                           )
//                         ],
//                       ),
//                     );
//                   }),
//             )
//           ],
//         ),
//       ),
//     );
//   }

// }

class AddTransaction extends ConsumerStatefulWidget {
  const AddTransaction({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddTransactionState();
}

class _AddTransactionState extends ConsumerState<AddTransaction> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final _popupBuilderKey = GlobalKey<DropdownSearchState<Product>>();
  bool editMode = false;
  NepaliDateTime? nepaliDateTime;

  @override
  void initState() {
    super.initState();
    nepaliDateTime = NepaliDateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(addTransactionProvider);
    print("rebuild");
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Form(
                key: formkey,
                child: Column(
                  children: [
                    DropdownSearch<Customer>(
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
                        ref
                            .read(addTransactionProvider.notifier)
                            .changeCustomer(value);
                      },
                      items:
                          ref.read(addTransactionProvider.notifier).customers,
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                        dropdownSearchDecoration:
                            InputDecoration(labelText: "Customer Name"),
                      ),
                      selectedItem:
                          ref.read(addTransactionProvider.notifier).customer,
                    ),
                    formseprator(),
                    DropdownSearch<Product>(
                      key: _popupBuilderKey,
                      validator: (value) {
                        if (value == null) {
                          return "Select Product";
                        }
                        return null;
                      },
                      popupProps: const PopupProps.menu(
                        showSearchBox: true,
                      ),
                      dropdownDecoratorProps: const DropDownDecoratorProps(
                          dropdownSearchDecoration:
                              InputDecoration(labelText: "Product")),
                      itemAsString: (item) => item.name,
                      compareFn: (item1, item2) => item1.name == item2.name,
                      onChanged: ref
                          .read(addTransactionProvider.notifier)
                          .changeProduct,
                      items: ref.read(addTransactionProvider.notifier).products,
                      selectedItem: null,
                    ),
                    formseprator(),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            validator: (value) =>
                                Validators.emptyText(value, "Rate"),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}'))
                            ],
                            decoration: const InputDecoration(
                                labelText: "Rate",
                                border: OutlineInputBorder()),
                            controller: ref
                                .read(addTransactionProvider.notifier)
                                .rateEditingController,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) =>
                                Validators.emptyText(value, "Quantity"),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: const InputDecoration(
                                labelText: "Quantity",
                                border: OutlineInputBorder()),
                            controller: ref
                                .read(addTransactionProvider.notifier)
                                .quantityController,
                          ),
                        )
                      ],
                    ),
                    formseprator(),
                    InkWell(
                      onTap: () async {
                        nepaliDateTime = await showMaterialDatePicker(
                            context: context,
                            initialDate: NepaliDateTime.now(),
                            firstDate: NepaliDateTime(2000),
                            lastDate: NepaliDateTime.now());
                        nepaliDateTime ??= NepaliDateTime.now();
                        setState(() {});
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Date Of Transaction"),
                          Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            width: double.infinity,
                            height: 50,
                            child: Text(nepaliDateTime!
                                .toIso8601String()
                                .split("T")
                                .first),
                          )
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (formkey.currentState?.validate() ?? false) {
                          try {
                            ref
                                .read(addTransactionProvider.notifier)
                                .addNewTransaction(nepaliDateTime!);
                            _popupBuilderKey.currentState?.clear();
                          } catch (e) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                    title: const Text(
                                      "Error",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          e.toString(),
                                          style: const TextStyle(fontSize: 16),
                                        )
                                      ],
                                    )));
                          }
                        }
                      },
                      icon: const Icon(Icons.arrow_right),
                      label: const Text("Add"),
                    ),
                    const Spacer(),
                    ElevatedButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(addTransactionProvider.notifier)
                                .submitTransaction();
                            if (!mounted) return;
                            Navigator.pop(context);
                          } catch (e) {
                            ScaffoldMessenger.of(context)
                                .showMaterialBanner(MaterialBanner(
                                    content: Text(
                                      e.toString(),
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    actions: [
                                  IconButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context)
                                            .clearMaterialBanners();
                                      },
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ))
                                ]));
                          }
                        },
                        child: const Text("Submit")),
                    const Spacer()
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.45,
              child: (data.isNotEmpty)
                  ? ListView.separated(
                      separatorBuilder: (context, index) => formseprator(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        final transactionData = data[index];
                        return InkWell(
                          onDoubleTap: () {},
                          child: Container(
                            height: 80,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                  color: Colors.grey.shade300, width: 2),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(transactionData.product.name,
                                        style: TextStyles.boldStyle),
                                    Row(
                                      children: [
                                        const Text(
                                          "Rate:",
                                          style: TextStyles.boldStyle,
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(currencyFormat
                                            .format(transactionData.rate)),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Quantity:",
                                              style: TextStyles.boldStyle,
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(currencyFormat.format(
                                                transactionData.quantity))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    IconButton(
                                        onPressed: () {
                                          ref
                                              .read(addTransactionProvider
                                                  .notifier)
                                              .removeItem(transactionData.id);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.attach_money,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          currencyFormat.format(
                                              transactionData.quantity *
                                                  transactionData.rate),
                                          style: TextStyles.boldStyle,
                                        )
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      })
                  : const Center(
                      child: Text("No Transaction's Please Add"),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
