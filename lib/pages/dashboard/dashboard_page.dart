import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../widgets/app_theme.dart';
import '../../widgets/stat_card.dart';
import '../../widgets/transaction_card.dart';

class DashboardPage extends StatelessWidget {
  final InventoryStore store;
  final VoidCallback onOpenProducts;

  const DashboardPage({
    super.key,
    required this.store,
    required this.onOpenProducts,
  });

  String currency(double value) {
    return 'Rp ${value.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        return SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await Future.delayed(
                const Duration(milliseconds: 500),
              );
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                110,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // =====================================================
                  // HEADER
                  // =====================================================
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Good evening 👋',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              'Dashboard',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.notifications_none,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // =====================================================
                  // STAT CARDS
                  // =====================================================
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,

                    // Penting:
                    // Card dibuat lebih tinggi supaya seluruh isi muat.
                    childAspectRatio: 1.08,

                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),

                    children: [
                      StatCard(
                        title: 'Products',
                        value: '${store.totalProducts}',
                        subtitle: 'Total products',
                        icon: Icons.inventory_2_outlined,
                        color: AppTheme.primary,
                      ),
                      StatCard(
                        title: 'Low Stock',
                        value: '${store.totalLowStock}',
                        subtitle: 'Need attention',
                        icon: Icons.warning_amber_rounded,
                        color: AppTheme.warning,
                      ),
                      StatCard(
                        title: 'Stock',
                        value: '${store.totalStock}',
                        subtitle: 'Total quantity',
                        icon: Icons.layers_outlined,
                        color: AppTheme.secondary,
                      ),
                      StatCard(
                        title: 'Sales',
                        value: currency(store.todaySales),
                        subtitle: 'Today',
                        icon: Icons.payments_outlined,
                        color: Colors.purple,
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // =====================================================
                  // INVENTORY ALERT HEADER
                  // =====================================================
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Inventory Alert',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: onOpenProducts,
                        child: const Text('View all'),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // =====================================================
                  // INVENTORY ALERT LIST
                  // =====================================================
                  if (store.lowStockProducts.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'All products have sufficient stock.',
                      ),
                    )
                  else
                    ...store.lowStockProducts.take(3).map(
                      (product) {
                        return Container(
                          margin:
                              const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 13,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 20,
                                backgroundColor:
                                    Color(0xFFFFF4E5),
                                child: Icon(
                                  Icons.warning_amber_rounded,
                                  color: AppTheme.warning,
                                  size: 21,
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Stock ${product.stock} ${product.unit} • Min ${product.minStock}',
                                      maxLines: 1,
                                      overflow:
                                          TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppTheme
                                            .textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 8),

                              const Icon(
                                Icons.chevron_right,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 20),

                  // =====================================================
                  // SALES OVERVIEW
                  // =====================================================
                  const Text(
                    'Sales Overview',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Container(
                    height: 210,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            currency(store.todaySales),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          'Today sales',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),

                        const SizedBox(height: 14),

                        Expanded(
                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: [
                              35,
                              55,
                              42,
                              75,
                              60,
                              90,
                              68,
                            ].map(
                              (height) {
                                return Expanded(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Container(
                                      height:
                                          height.toDouble(),
                                      decoration:
                                          BoxDecoration(
                                        color: AppTheme
                                            .primary
                                            .withValues(
                                          alpha: 0.7,
                                        ),
                                        borderRadius:
                                            BorderRadius
                                                .circular(6),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // =====================================================
                  // RECENT TRANSACTIONS
                  // =====================================================
                  const Text(
                    'Recent Transactions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ...store.transactions.take(3).map(
                    (transaction) {
                      return TransactionCard(
                        transaction: transaction,
                      );
                    },
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