import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/transaction_card.dart';
import 'add_transaction_page.dart';

class TransactionsPage extends StatelessWidget {
  final InventoryStore store;

  const TransactionsPage({
    super.key,
    required this.store,
  });

  String currency(double value) {
    return 'Rp ${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final totalSales = store.transactions.fold<double>(
          0,
          (sum, transaction) => sum + transaction.total,
        );

        final totalItems = store.transactions.fold<int>(
          0,
          (sum, transaction) => sum + transaction.quantity,
        );

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddTransactionPage(
                      store: store,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add Sale'),
            ),
            body: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                90,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transactions',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Track your sales activity',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: _SummaryCard(
                          title: 'Total Sales',
                          value: currency(totalSales),
                          icon: Icons.payments_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SummaryCard(
                          title: 'Items Sold',
                          value: '$totalItems',
                          icon: Icons.shopping_cart_outlined,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView.builder(
                      itemCount: store.transactions.length,
                      itemBuilder: (context, index) {
                        return TransactionCard(
                          transaction:
                              store.transactions[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}