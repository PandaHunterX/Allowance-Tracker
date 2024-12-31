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

enum CurrencyCategories {
  dollar,
  euro,
  poundSterling,
  yen,
  franc,
  rupee,
  dinar,
  dirham,
  riyal,
  mark,
  rouble,
  lari,
  lira,
  manat,
  tenge,
  hryvnia,
  spesmilo,
  baht,
  won,
  dong,
  tugrik,
  drachma,
  peso,
  austral,
  cedi,
  guarani,
  sheqel,
  penny,
}

class CurrencyCategory {
  CurrencyCategory(this.title, this.symbol, this.currency);

  final String title;
  final String symbol;
  final String currency;
}