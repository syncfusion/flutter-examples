import 'package:excel/excel.dart';

class Profile {
  Profile({
    required this.firstName,
    required this.lastName,
    required this.userId,
    this.gender,
    this.dateOfBirth,
    this.currency = '',
    this.isSelectedCurrency = false,
    this.dateFormat = 'M/d/yyyy',
    this.themeFormat = 'System Default',
    this.isNewUser = true,
    this.isDrawerExpanded = true,
  });
  factory Profile.fromExcel(Profile profile) {
    return profile;
  }
  String getStringValues(SharedString value) {
    return value.toString();
  }

  List<String> get categoryStrings {
    final List<ETCategory> categories = _defaultCategories();
    return categories.map((cat) => cat.category.displayName).toList();
  }

  List<String> getSubcategoriesFor(String categoryDisplayName) {
    final List<ETCategory> categories = _defaultCategories();

    for (final ETCategory categoryItem in categories) {
      if (categoryItem.category.displayName == categoryDisplayName) {
        return categoryItem.subcategories
            .map((subcategory) => subcategory.displayName)
            .toList();
      }
    }

    return [];
  }

  String firstName;
  String lastName;
  String? gender;
  String userId;
  DateTime? dateOfBirth;
  String currency;
  String dateFormat;
  bool isSelectedCurrency;
  String themeFormat;
  bool isNewUser;
  bool isDrawerExpanded;

  static List<ETCategory> _defaultCategories() {
    return [
      ETCategory(
        category: Category.foodDining,
        subcategories: [Subcategory.diningOut, Subcategory.groceries],
      ),
      ETCategory(
        category: Category.transportation,
        subcategories: [Subcategory.gasoline, Subcategory.publicTransit],
      ),
      ETCategory(
        category: Category.utilities,
        subcategories: [Subcategory.electricity, Subcategory.water],
      ),
      ETCategory(
        category: Category.housing,
        subcategories: [Subcategory.rent, Subcategory.mortgage],
      ),
      ETCategory(
        category: Category.healthFitness,
        subcategories: [Subcategory.gym, Subcategory.medical],
      ),
      ETCategory(
        category: Category.others,
        subcategories: [Subcategory.others],
      ),
    ];
  }
}

extension CategoryExtension on Category {
  String get displayName {
    switch (this) {
      case Category.foodDining:
        return 'Food & Dining';
      case Category.transportation:
        return 'Transportation';
      case Category.utilities:
        return 'Utilities';
      case Category.housing:
        return 'Housing';
      case Category.healthFitness:
        return 'Health & Fitness';
      case Category.others:
        return 'Others';
    }
  }
}

extension SubcategoryExtension on Subcategory {
  String get displayName {
    switch (this) {
      case Subcategory.diningOut:
        return 'Dining Out';
      case Subcategory.groceries:
        return 'Groceries';
      case Subcategory.gasoline:
        return 'Gasoline';
      case Subcategory.publicTransit:
        return 'Public Transit';
      case Subcategory.electricity:
        return 'Electricity';
      case Subcategory.water:
        return 'Water';
      case Subcategory.rent:
        return 'Rent';
      case Subcategory.mortgage:
        return 'Mortgage';
      case Subcategory.gym:
        return 'Gym';
      case Subcategory.medical:
        return 'Medical';
      case Subcategory.others:
        return 'Others';
    }
  }
}

enum ETDateFormat {
  monthDayYear,
  dayMonthYear,
  yearMonthDay,
  monthNameDayYear,
  dayMonthNameYear,
  yearMonthNameDay,
}

enum Category {
  foodDining,
  transportation,
  utilities,
  housing,
  healthFitness,
  others,
}

enum Subcategory {
  // Food & Dining
  diningOut,
  groceries,

  // Transportation
  gasoline,
  publicTransit,

  // Utilities
  electricity,
  water,

  // Housing
  rent,
  mortgage,

  // Health & Fitness
  gym,
  medical,

  others,
}

class ETCategory {
  ETCategory({required this.category, required this.subcategories});

  final Category category;
  final List<Subcategory> subcategories;
}
