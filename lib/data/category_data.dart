import 'package:flutter_application_coinz/models/category_model.dart';

class KategoryData {
  static List<KategoriModel> excategories = [
    KategoriModel(
      id: '1',
      name: 'Tagihan',
      icon: 'Icons.receipt_long',
      type: 'expense',
    ),
    KategoriModel(
      id: '2',
      name: 'Transportasi',
      icon: 'Icons.directions_car',
      type: 'expense',
    ),
    KategoriModel(
      id: '3',
      name: 'Konsumsi',
      icon: 'Icons.restaurant',
      type: 'expense',
    ),
    KategoriModel(
      id: '4',
      name: 'Entertain',
      icon: 'Icons.movie',
      type: 'expense',
    ),
    KategoriModel(
      id: '5',
      name: 'Dana Darurat',
      icon: 'Icons.savings',
      type: 'expense',
    ),
    KategoriModel(
      id: '6',
      name: 'Investasi',
      icon: 'Icons.trending_up',
      type: 'expense',
    ),
  ];

  static List<KategoriModel> incategories = [
    KategoriModel(id: '101', name: 'Job', icon: 'Icons.work', type: 'income'),
    KategoriModel(
      id: '102',
      name: 'Pemberian',
      icon: 'Icons.card_giftcard',
      type: 'income',
    ),
  ];

  static KategoriModel getById(String id) {
    return [...incategories, ...excategories].firstWhere((c) => c.id == id);
  }
}
