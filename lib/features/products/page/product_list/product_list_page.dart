import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paiso_plus/core/config/constants.dart';
import 'package:paiso_plus/core/config/validators.dart';
import 'package:paiso_plus/core/providers/product_provider/product_provider.dart';

class ProductListPage extends ConsumerWidget {
  ProductListPage({super.key});
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController quantityEditingController =
      TextEditingController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(productProvider);
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Products",
          onPressed: () async {
            final bool? dialogData = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text("Add Products"),
                content: Form(
                    key: formkey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: nameEditingController,
                            decoration: const InputDecoration(
                                hintText: "Enter Product Name"),
                            validator: (value) =>
                                Validators.emptyText(value, "Product Name"),
                          ),
                        ),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            controller: quantityEditingController,
                            decoration: const InputDecoration(
                                hintText: "Enter Quantity"),
                            validator: (value) =>
                                Validators.emptyText(value, "Quantity"),
                          ),
                        ),
                        formseprator(),
                        ElevatedButton(
                            onPressed: () {
                              if (formkey.currentState?.validate() ?? false) {
                                ref.read(productProvider.notifier).addProduct(
                                    nameEditingController.text,
                                    int.parse(quantityEditingController.text));
                                nameEditingController.clear();
                                quantityEditingController.clear();
                                Navigator.pop(context, true);
                              }
                            },
                            child: const Text("Add"))
                      ],
                    )),
              ),
            );
            if (dialogData ?? false) {
              return ref.refresh(productProvider);
            }
          },
          child: const Icon(Icons.add),
        ),
        appBar: AppBar(title: const Text("Products")),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                itemCount: data.length,
                padding: const EdgeInsets.symmetric(horizontal: 25),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    childAspectRatio: 3.4 / 1,
                    mainAxisSpacing: 15,
                    crossAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.shade200)),
                    child: Text(
                      data[index].name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  );
                },
              ),
            )
          ],
        ));
  }
}
