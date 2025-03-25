// ignore: depend_on_referenced_packages
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// Custom business object class which contains properties to hold the detailed
/// information about the dealers info which will be rendered in datagrid.
class Dealer {
  /// Creates the dealers info class with required details.
  Dealer(
    this.productNo,
    this.dealerName,
    this.shippedDate,
    this.shipCountry,
    this.shipCity,
    this.productPrice,
  );

  /// Product number of the dealer.
  int productNo;

  /// Name of the dealer.
  String dealerName;

  /// Product price of the dealer.
  double productPrice;

  /// Shipped date of the dealer.
  DateTime shippedDate;

  /// Shipped city of the dealer.
  String shipCity;

  /// Shipped country of the dealer.
  String shipCountry;

  /// Get datagrid row of the dealer.
  DataGridRow obtainDataGridRow() {
    return DataGridRow(
      cells: <DataGridCell>[
        DataGridCell<int>(columnName: 'Product No', value: productNo),
        DataGridCell<String>(columnName: 'Dealer Name', value: dealerName),
        DataGridCell<DateTime>(columnName: 'Shipped Date', value: shippedDate),
        DataGridCell<String>(columnName: 'Ship Country', value: shipCountry),
        DataGridCell<String>(columnName: 'Ship City', value: shipCity),
        DataGridCell<double>(columnName: 'Price', value: productPrice),
      ],
    );
  }
}
