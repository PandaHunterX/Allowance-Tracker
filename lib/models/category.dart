import 'package:flutter/material.dart';

enum ExpenseCategories {
  food,
  transportation,
  entertainment,
  education,
  health,
  shopping,
  utilities,
  subscriptions,
  donations,
  others,
}

class ExpenseCategory {
  const ExpenseCategory(this.title, this.icon);

  final String title;
  final Icon icon;
}

enum AllowanceCategories {
  salary,
  gifts,
  scholarship,
  businessProfit,
  familySupport,
  governmentAid,
  others,
}

class AllowanceCategory {
  AllowanceCategory(this.title, this.icon);

  final String title;
  final Icon icon;
}