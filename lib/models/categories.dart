import 'package:flutter/material.dart';
import 'package:productivity_app/models/category.dart';

const expense_categories = {
  ExpenseCategories.food: ExpenseCategory('Food', Icon(Icons.fastfood)),
  ExpenseCategories.entertainment: ExpenseCategory('Entertainment', Icon(Icons.tv)),
  ExpenseCategories.transportation: ExpenseCategory('Transportation', Icon(Icons.car_rental)),
  ExpenseCategories.education: ExpenseCategory('Education', Icon(Icons.book)),
  ExpenseCategories.health: ExpenseCategory('Health', Icon(Icons.health_and_safety)),
  ExpenseCategories.shopping: ExpenseCategory('Shopping', Icon(Icons.shopping_basket)),
  ExpenseCategories.subscriptions: ExpenseCategory('Subscriptions', Icon(Icons.movie_creation_outlined)),
  ExpenseCategories.utilities: ExpenseCategory('Utilities', Icon(Icons.construction)),
  ExpenseCategories.donations: ExpenseCategory('Donations', Icon(Icons.handshake)),
  ExpenseCategories.others: ExpenseCategory('Others', Icon(Icons.devices_other)),
};

var allowance_categories = {
  AllowanceCategories.salary: AllowanceCategory('Salary', const Icon(Icons.monetization_on)),
  AllowanceCategories.gifts: AllowanceCategory('Gifts', const Icon(Icons.card_giftcard)),
  AllowanceCategories.scholarship: AllowanceCategory('Scholarship', const Icon(Icons.school)),
  AllowanceCategories.businessProfit: AllowanceCategory('Business', const Icon(Icons.business)),
  AllowanceCategories.familySupport: AllowanceCategory('Family Support', const Icon(Icons.diversity_3)),
  AllowanceCategories.governmentAid: AllowanceCategory('Salary', const Icon(Icons.account_balance)),
  AllowanceCategories.others: AllowanceCategory('Salary', const Icon(Icons.not_listed_location)),
};
