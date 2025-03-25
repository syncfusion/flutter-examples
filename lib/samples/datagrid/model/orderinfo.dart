/// Custom business object class which contains properties to hold the detailed
/// information about the order which will be rendered in datagrid.
class OrderInfo {
  /// Creates the order class with required details.
  OrderInfo(
    this.id,
    this.customerId,
    this.name,
    this.freight,
    this.city,
    this.price,
  );

  /// Id of an order.
  final int id;

  /// Customer Id of an order.
  final int customerId;

  /// Name of an order.
  final String name;

  /// City of an order.
  final String city;

  /// Freight of an order.
  final double freight;

  /// Price of an order.
  final double price;
}
