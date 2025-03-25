/// Custom business object class which contains properties to hold the detailed
/// information about the product which will be rendered in datagrid.
class Product {
  /// Creates the product class with required details.
  Product(
    this.id,
    this.productId,
    this.product,
    this.quantity,
    this.unitPrice,
    this.city,
    this.orderDate,
    this.name,
  );

  /// Id of product.
  final int id;

  /// ProductId of product.
  final int productId;

  /// ProductName of product.
  final String product;

  /// Quantity of product.
  final int quantity;

  /// Unit price of product.
  final double unitPrice;

  /// City of product.
  final String city;

  /// Order date of product.
  final DateTime orderDate;

  /// Name of product.
  final String name;
}
