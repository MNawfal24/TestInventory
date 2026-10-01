class InventoryTransaction {
  final String id;
  final String productId;
  final String productName;
  final int quantity;
  final double total;
  final DateTime date;
  final String type;

  InventoryTransaction({
    required this.id,
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.total,
    required this.date,
    required this.type,
  });
}