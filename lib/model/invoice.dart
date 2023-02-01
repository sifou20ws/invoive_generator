
class Invoice {
  final List<InvoiceItem> items;

  const Invoice({
    required this.items,
  });
}

class InvoiceItem {
  final String description;
  final double quantity;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.quantity,
    required this.unitPrice,
  });
}
