/// Class contains properties to hold the detailed information about the employee
/// which will be rendered in datagrid.
class Employee {
  /// Creates the employee info class with required details.
  Employee({
    required this.id,
    required this.contactName,
    required this.companyName,
    required this.address,
    required this.city,
    required this.country,
    required this.designation,
    required this.postalCode,
    required this.phoneNumber,
  });

  /// Fetch data from json
  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['id'],
      contactName: json['contactName'],
      companyName: json['companyName'],
      address: json['address'],
      city: json['city'],
      country: json['country'],
      designation: json['designation'],
      postalCode: json['postalCode'],
      phoneNumber: json['phoneNumber'],
    );
  }

  /// Id of an employee info.
  final String id;

  /// Contact name of an employee info.
  final String contactName;

  /// Company name of an employee info.
  final String companyName;

  /// Address of an employee info.
  final String address;

  /// City of an employee info.
  final String city;

  /// Country of an employee info.
  final String country;

  /// Designation of an employee info.
  final String designation;

  /// Postal code of an employee info.
  final String postalCode;

  /// Phone number of an employee info.
  final String phoneNumber;
}
