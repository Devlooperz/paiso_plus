import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paiso_plus/core/config/constants.dart';
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
    debugPrint(customerData.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Customers"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final bool? dialogResult = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Add New Customer"),
              content: Form(
                  key: formkey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: nameEditingController,
                        decoration:
                            const InputDecoration(hintText: "Enter Name"),
                        validator: (value) =>
                            Validators.emptyText(value, "Name"),
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
                        decoration: const InputDecoration(
                            hintText: "Enter Phone Number"),
                        controller: phoneController,
                      ),
                      formseprator(),
                      ElevatedButton(
                          onPressed: () {
                            if (formkey.currentState?.validate() ?? false) {
                              ref.read(customerProvider.notifier).addCustomer(
                                  nameEditingController.text,
                                  addressController.text,
                                  phoneController.text);
                              nameEditingController.clear();
                              addressController.clear();
                              phoneController.clear();
                              Navigator.pop(context, true);
                            }
                          },
                          child: const Text("Submit"))
                    ],
                  )),
            ),
          );
          if (dialogResult ?? false) {
            return ref.refresh(customerProvider);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
