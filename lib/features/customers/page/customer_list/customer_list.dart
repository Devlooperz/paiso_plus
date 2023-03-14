import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paiso_plus/core/config/constants.dart';
import 'package:paiso_plus/core/config/styles.dart';
import 'package:paiso_plus/core/config/validators.dart';
import 'package:paiso_plus/core/providers/customer_provider/customer_provider.dart';

class CustomerPage extends ConsumerWidget {
  CustomerPage({super.key});
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerData = ref.watch(customerProvider);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Customers"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final bool? dialogResult = await showInsertDialog(context, ref);
            resetTextController();
            if (dialogResult ?? false) {
              return ref.refresh(customerProvider);
            }
          },
          child: const Icon(Icons.add),
        ),
        body: GridView.builder(
          itemCount: customerData.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 3.4 / 1,
              mainAxisSpacing: 15,
              crossAxisSpacing: 10),
          itemBuilder: (context, index) {
            final currentCustomer = customerData[index];
            return Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(border: Border.all()),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentCustomer.name,
                        style: TextStyles.boldStyle,
                      ),
                      Text(currentCustomer.address)
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () async {
                            nameEditingController.text = currentCustomer.name;
                            addressController.text = currentCustomer.address;
                            phoneController.text =
                                currentCustomer.mobileNumber.toString();
                            final bool? dialogResult = await showInsertDialog(
                                context, ref, true, currentCustomer.id);
                            resetTextController();
                            if (dialogResult ?? false) {
                              return ref.refresh(customerProvider);
                            }
                          },
                          icon: const Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            ref
                                .read(customerProvider.notifier)
                                .deleteCustomer(currentCustomer.id);
                            return ref.refresh(customerProvider);
                          },
                          icon: const Icon(Icons.delete))
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }

  Future showInsertDialog(BuildContext context, WidgetRef ref,
      [bool isUpdate = false, int? id]) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(isUpdate ? "Update Customer" : "Add New Customer"),
            content: Form(
                key: formkey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameEditingController,
                      decoration: const InputDecoration(hintText: "Enter Name"),
                      validator: (value) => Validators.emptyText(value, "Name"),
                    ),
                    formseprator(),
                    TextFormField(
                        controller: addressController,
                        decoration:
                            const InputDecoration(hintText: "Enter Address"),
                        validator: (value) =>
                            Validators.emptyText(value, "Address")),
                    formseprator(),
                    TextFormField(
                      maxLength: 10,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration:
                          const InputDecoration(hintText: "Enter Phone Number"),
                      controller: phoneController,
                    ),
                    formseprator(),
                    ElevatedButton(
                        onPressed: () {
                          if (formkey.currentState?.validate() ?? false) {
                            if (!isUpdate) {
                              ref.read(customerProvider.notifier).addCustomer(
                                  nameEditingController.text,
                                  addressController.text,
                                  phoneController.text);
                            } else {
                              ref
                                  .read(customerProvider.notifier)
                                  .updateCustomer(
                                      id!,
                                      nameEditingController.text,
                                      addressController.text,
                                      int.parse(phoneController.text));
                            }

                            Navigator.pop(context, true);
                          }
                        },
                        child: Text(isUpdate ? "Update" : "Submit"))
                  ],
                )),
          );
        });
  }

  void resetTextController() {
    nameEditingController.clear();
    phoneController.clear();
    addressController.clear();
  }
}
