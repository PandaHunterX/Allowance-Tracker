import 'package:flutter/material.dart';
import 'package:productivity_app/models/category.dart';

const categories = {
  Categories.food: Category('Food', Icon(Icons.fastfood)),
  Categories.entertainment: Category('Entertainment', Icon(Icons.tv)),
  Categories.transportation: Category('Transportation', Icon(Icons.car_rental)),
  Categories.education: Category('Education', Icon(Icons.book)),
  Categories.health: Category('Health', Icon(Icons.health_and_safety)),
  Categories.shopping: Category('Shopping', Icon(Icons.shopping_basket)),
  Categories.subscriptions: Category('Subscriptions', Icon(Icons.movie_creation_outlined)),
  Categories.utilities: Category('Utilities', Icon(Icons.construction)),
  Categories.donations: Category('Donations', Icon(Icons.handshake)),
  Categories.others: Category('Others', Icon(Icons.devices_other)),
};
