import 'package:flutter/material.dart';

enum Categories {
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

class Category {
  const Category(this.title, this.icon);

  final String title;
  final Icon icon;
}