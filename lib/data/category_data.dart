import 'package:flutter/material.dart';
import 'package:flutter_application_coinz/models/category_model.dart';

class KategoryData {
  static List<KategoriModel> excategories = [
    KategoriModel(
      id: '1',
      name: 'Tagihan',
      icon: Icons.receipt_long,
      type: 'expense',
      color: Colors.redAccent,
    ),
    KategoriModel(
      id: '2',
      name: 'Transportasi',
      icon: Icons.directions_car,
      type: 'expense',
      color: Colors.blueAccent,
    ),
    KategoriModel(
      id: '3',
      name: 'Konsumsi',
      icon: Icons.restaurant,
      type: 'expense',
      color: Colors.green,
    ),
    KategoriModel(
      id: '4',
      name: 'Entertain',
      icon: Icons.movie,
      type: 'expense',
      color: Colors.purple,
    ),
    KategoriModel(
      id: '5',
      name: 'Dana Darurat',
      icon: Icons.savings,
      type: 'expense',
      color: Colors.teal,
    ),
    KategoriModel(
      id: '6',
      name: 'Investasi',
      icon: Icons.trending_up,
      type: 'expense',
      color: Colors.indigo,
    ),
  ];

  static List<KategoriModel> incategories = [
    KategoriModel(
      id: '101',
      name: 'Job',
      icon: Icons.work,
      type: 'income',
      color: Colors.orange,
    ),
    KategoriModel(
      id: '102',
      name: 'Pemberian',
      icon: Icons.card_giftcard,
      type: 'income',
      color: Colors.pink,
    ),
  ];

  static KategoriModel getById(String id) {
    return [...incategories, ...excategories].firstWhere((c) => c.id == id);
  }

  static List<KategoriModel> allCategories() {
    final List<KategoriModel> allCat = [];
    allCat.addAll(excategories);
    allCat.addAll(incategories);

    return allCat;
  }
}
