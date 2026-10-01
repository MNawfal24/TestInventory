import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/product_model.dart';

class ProductFormPage extends StatefulWidget {
  final InventoryStore store;
  final Product? product;

  const ProductFormPage({
    super.key,
    required this.store,
    this.product,
  });

  @override
  State<ProductFormPage> createState() =>
      _ProductFormPageState();
}

class _ProductFormPageState
    extends State<ProductFormPage> {
  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController stockController;
  late TextEditingController minStockController;
  late TextEditingController buyPriceController;
  late TextEditingController sellPriceController;

  String category = 'Coffee';
  String unit = 'Kg';

  bool get isEdit => widget.product != null;

  @override
  void initState() {
    super.initState();

    final product = widget.product;

    nameController =
        TextEditingController(text: product?.name ?? '');
    stockController = TextEditingController(
      text: product?.stock.toString() ?? '',
    );
    minStockController = TextEditingController(
      text: product?.minStock.toString() ?? '',
    );
    buyPriceController = TextEditingController(
      text: product?.buyPrice.toStringAsFixed(0) ?? '',
    );
    sellPriceController = TextEditingController(
      text: product?.sellPrice.toStringAsFixed(0) ?? '',
    );

    category = product?.category ?? 'Coffee';
    unit = product?.unit ?? 'Kg';
  }

  @override
  void dispose() {
    nameController.dispose();
    stockController.dispose();
    minStockController.dispose();
    buyPriceController.dispose();
    sellPriceController.dispose();
    super.dispose();
  }

  void saveProduct() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final product = Product(
      id: widget.product?.id ??
          'P${DateTime.now().millisecondsSinceEpoch}',
      name: nameController.text.trim(),
      category: category,
      stock: int.parse(stockController.text),
      minStock: int.parse(minStockController.text),
      unit: unit,
      buyPrice: double.parse(buyPriceController.text),
      sellPrice: double.parse(sellPriceController.text),
    );

    if (isEdit) {
      widget.store.updateProduct(product);
    } else {
      widget.store.addProduct(product);
    }

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isEdit
              ? 'Product updated successfully'
              : 'Product added successfully',
        ),
      ),
    );
  }

  String? requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit Product' : 'Add Product',
        ),
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: requiredValidator,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  prefixIcon:
                      Icon(Icons.inventory_2_outlined),
                ),
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: const [
                  'Coffee',
                  'Dairy',
                  'Sweetener',
                  'Ingredient',
                  'Other',
                ].map(
                  (item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      category = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: stockController,
                      validator: requiredValidator,
                      keyboardType:
                          TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Current Stock',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: minStockController,
                      validator: requiredValidator,
                      keyboardType:
                          TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Minimum Stock',
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: unit,
                decoration: const InputDecoration(
                  labelText: 'Unit',
                ),
                items: const [
                  'Kg',
                  'Liter',
                  'Pcs',
                  'Pack',
                  'Box',
                ].map(
                  (item) {
                    return DropdownMenuItem(
                      value: item,
                      child: Text(item),
                    );
                  },
                ).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      unit = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: buyPriceController,
                validator: requiredValidator,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Purchase Price',
                  prefixText: 'Rp ',
                ),
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: sellPriceController,
                validator: requiredValidator,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: 'Selling Price',
                  prefixText: 'Rp ',
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: saveProduct,
                  child: Text(
                    isEdit
                        ? 'Save Changes'
                        : 'Add Product',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}