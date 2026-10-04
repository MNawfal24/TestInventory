import 'package:flutter/material.dart';

import '../../data/mock_data.dart';
import '../../models/product_model.dart';
import '../../widgets/app_theme.dart';
import 'stockout_page.dart';

class PredictionPage extends StatefulWidget {
  final InventoryStore store;

  const PredictionPage({
    super.key,
    required this.store,
  });

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    selectedProduct = widget.store.products.first;
  }

  @override
  Widget build(BuildContext context) {
    final textFamily = Theme.of(context).textTheme.bodyMedium?.fontFamily ?? 'Poppins';

    if (selectedProduct == null) {
      return const Center(child: Text('No product available'));
    }

    final demand = widget.store.predictedDemand(selectedProduct!);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFEAF2FF),
            Color(0xFFF5F7FB),
          ],
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Prediction',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                  fontFamily: textFamily,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'Demand forecasting & inventory insights',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                  fontFamily: textFamily,
                ),
              ),
              const SizedBox(height: 22),
              DropdownButtonFormField<Product>(
                value: selectedProduct,
                decoration: InputDecoration(
                  labelText: 'Select Product',
                  labelStyle: TextStyle(
                    color: AppTheme.textSecondary,
                    fontFamily: textFamily,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: widget.store.products.map((product) {
                  return DropdownMenuItem(
                    value: product,
                    child: Text(
                      product.name,
                      style: TextStyle(fontFamily: textFamily),
                    ),
                  );
                }).toList(),
                onChanged: (product) {
                  setState(() {
                    selectedProduct = product;
                  });
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _PredictionCard(
                      title: 'Current Stock',
                      value: '${selectedProduct!.stock}',
                      subtitle: selectedProduct!.unit,
                      icon: Icons.inventory_2_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PredictionCard(
                      title: 'Predicted Demand',
                      value: '$demand',
                      subtitle: 'Next 7 days',
                      icon: Icons.trending_up,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '7-Day Demand Forecast',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: AppTheme.textPrimary,
                        fontFamily: textFamily,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Mock prediction for UI demonstration',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                        fontFamily: textFamily,
                      ),
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 220,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [55, 80, 65, 105, 90, 120, 100].asMap().entries.map((entry) {
                          final index = entry.key;
                          final height = entry.value;

                          return Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${(index + 2) * 2}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textSecondary,
                                    fontFamily: textFamily,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: height.toDouble(),
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withValues(alpha: 0.75),
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(7)),
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  'D${index + 1}',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppTheme.textSecondary,
                                    fontFamily: textFamily,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: AppTheme.primary),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Prediction data is currently simulated. The ML model can be connected later.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppTheme.textPrimary,
                          fontFamily: textFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StockoutPage(
                          store: widget.store,
                          product: selectedProduct!,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.warning_amber_rounded),
                  label: Text(
                    'View Stock-out Analysis',
                    style: TextStyle(fontFamily: textFamily),
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

class _PredictionCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _PredictionCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textFamily = Theme.of(context).textTheme.bodyMedium?.fontFamily ?? 'Poppins';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textSecondary,
              fontFamily: textFamily,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              fontFamily: textFamily,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 11,
              fontFamily: textFamily,
            ),
          ),
        ],
      ),
    );
  }
}