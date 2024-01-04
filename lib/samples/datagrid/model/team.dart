import 'package:flutter/material.dart';

/// Custom business object class which contains properties to hold the detailed
/// information about the team which will be rendered in datagrid.
class Team {
  /// Creates the team class with required details.
  Team(
    this.team,
    this.winPercentage,
    this.gamesBehind,
    this.wins,
    this.losses,
    this.image,
  );

  /// Name of the team.
  final String team;

  /// Win percentage of the team.
  final double winPercentage;

  /// Games behind of the team.
  final double gamesBehind;

  /// Wins of the team.
  final int wins;

  /// Losses of the team.
  final int losses;

  /// Image of the team.
  final Image image;
}

/// Custom business object class which contains properties to hold the detailed
/// information about the employee which will be rendered in datagrid.
class Employee {
  /// Creates the employee class with required details.
  Employee(
    this.employeeName,
    this.designation,
    this.mail,
    this.location,
    this.status,
    this.trustworthiness,
    this.softwareProficiency,
    this.salary,
    this.address,
  );

  /// Location of an employee.
  final String location;

  /// Name of an employee.
  final String employeeName;

  /// Designation of an employee.
  final String designation;

  /// Mail id of an employee.
  final String mail;

  /// Trustworthiness of an employee.
  final String trustworthiness;

  /// Status of an employee.
  final String status;

  /// Software proficiency of an employee.
  final int softwareProficiency;

  /// Salary of an employee.
  final int salary;

  /// Address of an employee.
  final String address;
}
