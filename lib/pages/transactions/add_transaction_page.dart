import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/product_model.dart';

class AddTransactionPage extends StatefulWidget {
  final InventoryStore store;

  const AddTransactionPage({
    super.key,
    required this.store,
  });

  @override
  State<AddTransactionPage> createState() =>
      _AddTransactionPageState();
}

class _AddTransactionPageState
    extends State<AddTransactionPage> {
  Product? selectedProduct;
  final quantityController =
      TextEditingController(text: '1');

  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    quantityController.dispose();
    super.dispose();
  }

  void saveTransaction() {
    if (selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a product'),
        ),
      );
      return;
    }

    final quantity =
        int.tryParse(quantityController.text);

    if (quantity == null || quantity <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid quantity'),
        ),
      );
      return;
    }

    if (quantity > selectedProduct!.stock) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Quantity exceeds current stock'),
        ),
      );
      return;
    }

    widget.store.addTransaction(
      product: selectedProduct!,
      quantity: quantity,
      date: selectedDate,
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final total = selectedProduct == null
        ? 0
        : selectedProduct!.sellPrice *
            (int.tryParse(quantityController.text) ?? 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Transaction'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            const Text(
              'Product',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<Product>(
              value: selectedProduct,
              decoration: const InputDecoration(
                hintText: 'Select product',
              ),
              items: widget.store.products.map(
                (product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(
                      '${product.name} (${product.stock} ${product.unit})',
                    ),
                  );
                },
              ).toList(),
              onChanged: (product) {
                setState(() {
                  selectedProduct = product;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              'Quantity',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              onChanged: (_) {
                setState(() {});
              },
              decoration: const InputDecoration(
                hintText: 'Enter quantity',
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Date',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2035),
                );

                if (picked != null) {
                  setState(() {
                    selectedDate = picked;
                  });
                }
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(17),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined),
                    const SizedBox(width: 12),
                    Text(
                      '${selectedDate.day}/'
                      '${selectedDate.month}/'
                      '${selectedDate.year}',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rp ${total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: FilledButton.icon(
                onPressed: saveTransaction,
                icon: const Icon(Icons.check),
                label: const Text('Save Transaction'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}