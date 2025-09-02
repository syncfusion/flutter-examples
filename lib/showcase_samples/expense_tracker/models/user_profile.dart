// import 'package:excel/excel.dart';
import 'package:flutter/material.dart';

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

  // TODO(Praveen): Replace this code based on csv format.
  // String getStringValues(SharedString value) {
  //   return value.toString();
  // }

  List<String> get categoryStrings {
    final List<ETCategory> categories = _defaultCategories();
    return List.generate(
      categories.length,
      (int index) => categories[index].category.displayName,
    );
  }

  List<String> get goalCategoryStrings {
    final List<ETGoalCategory> goalCategories = _defaultGoalCategories();
    return List.generate(
      goalCategories.length,
      (int index) => goalCategories[index].category.displayName,
    );
  }

  List<String> getSubcategoriesFor(String categoryDisplayName) {
    final List<ETCategory> categories = _defaultCategories();

    for (final ETCategory categoryItem in categories) {
      if (categoryItem.category.displayName == categoryDisplayName) {
        return List.generate(
          categoryItem.subcategories.length,
          (index) => categoryItem.subcategories[index].displayName,
        );
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
        icon: Icons.restaurant_outlined,
      ),
      ETCategory(
        category: Category.transportation,
        subcategories: [Subcategory.gasoline, Subcategory.publicTransit],
        icon: Icons.directions_car_outlined,
      ),
      ETCategory(
        category: Category.utilities,
        subcategories: [Subcategory.electricity, Subcategory.water],
        icon: Icons.electrical_services_outlined,
      ),
      ETCategory(
        category: Category.housing,
        subcategories: [Subcategory.rent, Subcategory.mortgage],
        icon: Icons.home_outlined,
      ),
      ETCategory(
        category: Category.healthFitness,
        subcategories: [Subcategory.gym, Subcategory.medical],
        icon: Icons.fitness_center_outlined,
      ),
      ETCategory(
        category: Category.travel,
        subcategories: [
          Subcategory.flights,
          Subcategory.accommodations,
          Subcategory.sightseeing,
        ],
        icon: Icons.flight_outlined,
      ),
      ETCategory(
        category: Category.socialEvents,
        subcategories: [
          Subcategory.parties,
          Subcategory.concerts,
          Subcategory.weddings,
        ],
        icon: Icons.event_outlined,
      ),
      ETCategory(
        category: Category.education,
        subcategories: [
          Subcategory.tuition,
          Subcategory.books,
          Subcategory.onlineCourses,
        ],
        icon: Icons.school_outlined,
      ),
      ETCategory(
        category: Category.others,
        subcategories: [Subcategory.others],
        icon: Icons.more_horiz_outlined,
      ),
      ETCategory(
        category: Category.freelance,
        subcategories: [Subcategory.projectBased, Subcategory.consulting],
        icon: Icons.business_center_outlined,
      ),
      ETCategory(
        category: Category.bills,
        subcategories: [
          Subcategory.electricityBill,
          Subcategory.waterBill,
          Subcategory.internetBill,
        ],
        icon: Icons.receipt_outlined,
      ),
      ETCategory(
        category: Category.groceries,
        subcategories: [
          Subcategory.fruits,
          Subcategory.vegetables,
          Subcategory.householdItems,
        ],
        icon: Icons.local_grocery_store_outlined,
      ),
      ETCategory(
        category: Category.entertainment,
        subcategories: [
          Subcategory.movies,
          Subcategory.games,
          Subcategory.musicConcerts,
        ],
        icon: Icons.movie_outlined,
      ),
    ];
  }

  static List<ETGoalCategory> _defaultGoalCategories() {
    return [
      ETGoalCategory(
        category: GoalCategory.homeOwnership,
        icon: Icons.home_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.retireEarly,
        icon: Icons.event_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.worldTravel,
        icon: Icons.flight_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.startBusiness,
        icon: Icons.business_center_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.educationUpgrade,
        icon: Icons.school_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.fitnessAchievement,
        icon: Icons.fitness_center_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.luxuryPurchase,
        icon: Icons.shopping_bag_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.emergencyPreparedness,
        icon: Icons.security_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.communityService,
        icon: Icons.volunteer_activism_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.personalGrowth,
        icon: Icons.self_improvement_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.familyExpansion,
        icon: Icons.family_restroom_outlined,
      ),
      ETGoalCategory(
        category: GoalCategory.creativeProject,
        icon: Icons.brush_outlined,
      ),
    ];
  }

  IconData getIconForCategory(String categoryDisplayName) {
    final List<ETCategory> categories = _defaultCategories();
    for (final ETCategory category in categories) {
      final String defaultCategoryName = category.category.name.toLowerCase();
      if (defaultCategoryName == categoryDisplayName) {
        return category.icon;
      }
    }
    return Icons.shape_line;
  }

  IconData getIconForGoalCategory(String categoryDisplayName) {
    final List<ETGoalCategory> goalCategories = _defaultGoalCategories();
    for (final ETGoalCategory goalCategory in goalCategories) {
      final String defaultCategoryName = goalCategory.category.name
          .toLowerCase();
      if (defaultCategoryName == categoryDisplayName) {
        return goalCategory.icon;
      }
    }
    return Icons.shape_line;
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
      case Category.travel:
        return 'Travel';
      case Category.socialEvents:
        return 'Social Events';
      case Category.education:
        return 'Education';
      case Category.others:
        return 'Others';
      case Category.freelance:
        return 'Freelance';
      case Category.bills:
        return 'Bills';
      case Category.groceries:
        return 'Groceries';
      case Category.entertainment:
        return 'Entertainment';
    }
  }

  IconData get iconData {
    switch (this) {
      case Category.foodDining:
        return Icons.restaurant_outlined;
      case Category.transportation:
        return Icons.directions_car_outlined;
      case Category.utilities:
        return Icons.electrical_services_outlined;
      case Category.housing:
        return Icons.home_outlined;
      case Category.healthFitness:
        return Icons.fitness_center_outlined;
      case Category.travel:
        return Icons.flight_outlined;
      case Category.socialEvents:
        return Icons.event_outlined;
      case Category.education:
        return Icons.school_outlined;
      case Category.others:
        return Icons.more_horiz_outlined;
      case Category.freelance:
        return Icons.business_center_outlined;
      case Category.bills:
        return Icons.receipt_outlined;
      case Category.groceries:
        return Icons.local_grocery_store_outlined;
      case Category.entertainment:
        return Icons.movie_outlined;
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
      case Subcategory.flights:
        return 'Flights';
      case Subcategory.accommodations:
        return 'Accommodations';
      case Subcategory.sightseeing:
        return 'Sightseeing';
      case Subcategory.parties:
        return 'Parties';
      case Subcategory.concerts:
        return 'Concerts';
      case Subcategory.weddings:
        return 'Weddings';
      case Subcategory.tuition:
        return 'Tuition';
      case Subcategory.books:
        return 'Books';
      case Subcategory.onlineCourses:
        return 'Online Courses';
      case Subcategory.others:
        return 'Others';
      case Subcategory.projectBased:
        return 'Project Based';
      case Subcategory.consulting:
        return 'Consulting';
      case Subcategory.electricityBill:
        return 'Electricity Bill';
      case Subcategory.waterBill:
        return 'Water Bill';
      case Subcategory.internetBill:
        return 'Internet Bill';
      case Subcategory.fruits:
        return 'Fruits';
      case Subcategory.vegetables:
        return 'Vegetables';
      case Subcategory.householdItems:
        return 'Household Items';
      case Subcategory.movies:
        return 'Movies';
      case Subcategory.games:
        return 'Games';
      case Subcategory.musicConcerts:
        return 'Music Concerts';
    }
  }
}

extension GoalCategoryExtension on GoalCategory {
  String get displayName {
    switch (this) {
      case GoalCategory.homeOwnership:
        return 'Home Ownership';
      case GoalCategory.retireEarly:
        return 'Retire Early';
      case GoalCategory.worldTravel:
        return 'World Travel';
      case GoalCategory.startBusiness:
        return 'Start Business';
      case GoalCategory.educationUpgrade:
        return 'Education Upgrade';
      case GoalCategory.fitnessAchievement:
        return 'Fitness Achievement';
      case GoalCategory.luxuryPurchase:
        return 'Luxury Purchase';
      case GoalCategory.emergencyPreparedness:
        return 'Emergency Preparedness';
      case GoalCategory.communityService:
        return 'Community Service';
      case GoalCategory.personalGrowth:
        return 'Personal Growth';
      case GoalCategory.familyExpansion:
        return 'Family Expansion';
      case GoalCategory.creativeProject:
        return 'Creative Project';
    }
  }

  IconData get iconData {
    switch (this) {
      case GoalCategory.homeOwnership:
        return Icons.home_outlined;
      case GoalCategory.retireEarly:
        return Icons.event_outlined;
      case GoalCategory.worldTravel:
        return Icons.flight_outlined;
      case GoalCategory.startBusiness:
        return Icons.business_center_outlined;
      case GoalCategory.educationUpgrade:
        return Icons.school_outlined;
      case GoalCategory.fitnessAchievement:
        return Icons.fitness_center_outlined;
      case GoalCategory.luxuryPurchase:
        return Icons.shopping_bag_outlined;
      case GoalCategory.emergencyPreparedness:
        return Icons.security_outlined;
      case GoalCategory.communityService:
        return Icons.volunteer_activism_outlined;
      case GoalCategory.personalGrowth:
        return Icons.self_improvement_outlined;
      case GoalCategory.familyExpansion:
        return Icons.family_restroom_outlined;
      case GoalCategory.creativeProject:
        return Icons.brush_outlined;
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
  travel,
  socialEvents,
  education,
  utilities,
  housing,
  healthFitness,
  others,
  freelance,
  bills,
  groceries,
  entertainment,
}

enum GoalCategory {
  homeOwnership,
  retireEarly,
  worldTravel,
  startBusiness,
  educationUpgrade,
  fitnessAchievement,
  luxuryPurchase,
  emergencyPreparedness,
  communityService,
  personalGrowth,
  familyExpansion,
  creativeProject,
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

  // Travel
  flights,
  accommodations,
  sightseeing,

  // Social Events
  parties,
  concerts,
  weddings,

  // Education
  tuition,
  books,
  onlineCourses,

  // Others
  others,

  // Freelance
  projectBased,
  consulting,

  // Bills
  electricityBill,
  waterBill,
  internetBill,

  // Groceries
  fruits,
  vegetables,
  householdItems,

  // Entertainment
  movies,
  games,
  musicConcerts,
}

class ETCategory {
  ETCategory({
    required this.category,
    required this.subcategories,
    required this.icon,
  });

  final Category category;
  final List<Subcategory> subcategories;
  final IconData icon;
}

class ETGoalCategory {
  ETGoalCategory({required this.category, required this.icon});

  final GoalCategory category;
  final IconData icon;
}
