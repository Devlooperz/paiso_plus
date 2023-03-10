import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:paiso_plus/core/database/my_database.dart';
import 'package:paiso_plus/features/transaction/page/add_transaction_page.dart';
import 'package:paiso_plus/features/transaction/provider/add_transaction_provider.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AddTransaction(),
                  fullscreenDialog: true));
        },
        tooltip: "Add Transactions",
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: const Text("Transactions")),
      body: Center(
        child: TextButton(
          onPressed: () async {
            await MyDatabase().transactionsDao.getAllTransaction();
          },
          child: Text("DATA"),
        ),
      ),
    );
  }
}
