import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paiso_plus/features/bills/generate_pdf.dart';
import 'package:paiso_plus/features/customers/page/customer_list/customer_list.dart';
import 'package:paiso_plus/core/providers/customer_provider/customer_provider.dart';
import 'package:paiso_plus/features/home/widget/dashboard_card.dart';
import 'package:paiso_plus/features/products/page/product_list/product_list_page.dart';
import 'package:paiso_plus/core/providers/product_provider/product_provider.dart';
import 'package:paiso_plus/features/transaction/page/transaction_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          child: Column(
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person,
                  color: Colors.black,
                ),
                title: const Text("Customers"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomerPage(),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.computer,
                  color: Colors.black,
                ),
                title: const Text("Products"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductListPage(),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.money,
                  color: Colors.black,
                ),
                title: const Text("Transaction"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionsPage(),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.receipt,
                  color: Colors.black,
                ),
                title: const Text("Bills"),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GenerateBills(),
                      ));
                },
              )
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text("Paiso+"),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Licensed To",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                "Apple Computer Suppliers",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(
            width: 15,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DashBoardCard(
                  mainIcon: Icons.add,
                  colors: const [Color(0xff233853), Color(0xff233853)],
                  bottomText: "Add Transaction",
                  onTap: () {},
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final customers = ref.watch(customerProvider).length;
                    return DashBoardCard(
                      title: "Customers",
                      titleIcon: Icons.person,
                      bottomText: customers.toString(),
                      colors: const [Color(0xff162133), Color(0xff233853)],
                      onTap: () {},
                    );
                  },
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final products = ref.watch(productProvider).length;
                    return DashBoardCard(
                      title: "Products",
                      bottomText: "$products",
                      titleIcon: Icons.computer,
                      colors: const [Color(0xff111111), Color(0xff195E9F)],
                      onTap: () {},
                    );
                  },
                )
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              "Recent Transaction",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
            )
          ],
        ),
      ),
    );
  }
}
