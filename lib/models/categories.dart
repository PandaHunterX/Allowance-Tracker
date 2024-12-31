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
  AllowanceCategories.governmentAid: AllowanceCategory('Government Aid', const Icon(Icons.account_balance)),
  AllowanceCategories.others: AllowanceCategory('Others', const Icon(Icons.not_listed_location)),
};

var currency_categories = {
  CurrencyCategories.dollar: CurrencyCategory('Dollar', '\$', 'USD'),
  CurrencyCategories.euro: CurrencyCategory('Euro', '€', 'EUR'),
  CurrencyCategories.poundSterling: CurrencyCategory('Pound Sterling', '£', 'GBP'),
  CurrencyCategories.yen: CurrencyCategory('Yen', '¥', 'JPY'),
  CurrencyCategories.franc: CurrencyCategory('Franc', '₣', 'CHF'),
  CurrencyCategories.rupee: CurrencyCategory('Rupee', '₹', 'INR'),
  CurrencyCategories.dinar: CurrencyCategory('Dinar', 'د.ك', 'KWD'),
  CurrencyCategories.dirham: CurrencyCategory('Dirham', 'د.إ', 'AED'),
  CurrencyCategories.riyal: CurrencyCategory('Riyal', '﷼‎', 'SAR'),
  CurrencyCategories.mark: CurrencyCategory('Mark', '₻', 'BAM'),
  CurrencyCategories.rouble: CurrencyCategory('Rouble', '₽', 'RUB'),
  CurrencyCategories.lari: CurrencyCategory('Lari', '₾', 'GEL'),
  CurrencyCategories.lira: CurrencyCategory('Lira', '₺', 'TRY'),
  CurrencyCategories.manat: CurrencyCategory('Manat', '₼', 'AZN'),
  CurrencyCategories.tenge: CurrencyCategory('Tenge', '₸', 'KZT'),
  CurrencyCategories.hryvnia: CurrencyCategory('Hryvnia', '₴', 'UAH'),
  CurrencyCategories.spesmilo: CurrencyCategory('Spesmilo', '₷', 'XSM'),
  CurrencyCategories.baht: CurrencyCategory('Baht', '฿', 'THB'),
  CurrencyCategories.won: CurrencyCategory('Won', '원', 'KRW'),
  CurrencyCategories.dong: CurrencyCategory('Dong', '₫', 'VND'),
  CurrencyCategories.tugrik: CurrencyCategory('Tugrik', '₮', 'MNT'),
  CurrencyCategories.drachma: CurrencyCategory('Drachma', '₯', 'GRD'),
  CurrencyCategories.peso: CurrencyCategory('Peso', '₱', 'PHP'),
  CurrencyCategories.austral: CurrencyCategory('Austral', '₳', 'ARS'),
  CurrencyCategories.cedi: CurrencyCategory('Cedi', '₵', 'GHS'),
  CurrencyCategories.guarani: CurrencyCategory('Guarani', '₲', 'PYG'),
  CurrencyCategories.sheqel: CurrencyCategory('Sheqel', '₪', 'ILS'),
  CurrencyCategories.penny: CurrencyCategory('Penny', '₰', 'GBX'),
};

