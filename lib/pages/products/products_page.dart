import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/product_card.dart';
import 'product_detail_page.dart';
import 'product_form_page.dart';

class ProductsPage extends StatefulWidget {
  final InventoryStore store;

  const ProductsPage({
    super.key,
    required this.store,
  });

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final TextEditingController searchController =
      TextEditingController();

  String selectedFilter = 'All';

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final search = searchController.text.toLowerCase();

        final filteredProducts = widget.store.products.where(
          (product) {
            final matchesSearch =
                product.name.toLowerCase().contains(search);

            final matchesFilter =
                selectedFilter == 'All' ||
                (selectedFilter == 'Low Stock' &&
                    product.isLowStock);

            return matchesSearch && matchesFilter;
          },
        ).toList();

        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductFormPage(
                      store: widget.store,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Product'),
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
                    'Products',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Manage your inventory',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),

                  TextField(
                    controller: searchController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search products...',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),

                  const SizedBox(height: 15),

                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('All'),
                        selected: selectedFilter == 'All',
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = 'All';
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: const Text('Low Stock'),
                        selected: selectedFilter == 'Low Stock',
                        onSelected: (_) {
                          setState(() {
                            selectedFilter = 'Low Stock';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Expanded(
                    child: filteredProducts.isEmpty
                        ? const Center(
                            child: Text(
                              'No products found.',
                            ),
                          )
                        : ListView.separated(
                            itemCount: filteredProducts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final product =
                                  filteredProducts[index];

                              return ProductCard(
                                product: product,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailPage(
                                        store: widget.store,
                                        productId: product.id,
                                      ),
                                    ),
                                  );
                                },
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