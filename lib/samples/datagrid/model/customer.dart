import 'package:flutter/material.dart';

/// Custom business object class which contains properties to hold the detailed
/// information about the customer info which will be rendered in datagrid.
class Customer {
  /// Creates the customer info class with required details.
  Customer(
    this.dealer,
    this.id,
    this.name,
    this.price,
    this.shippedDate,
    this.city,
    this.freight,
  );

  /// Id of customer.
  final int id;

  /// Name of customer.
  final String name;

  /// Price of customer product.
  final double price;

  /// Shipped date of the product
  final DateTime shippedDate;

  /// Image of the customer.
  final Image dealer;

  /// Freight of the customer.
  final double freight;

  /// City of the customer
  final String city;
}
