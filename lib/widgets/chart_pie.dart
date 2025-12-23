import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/sumary_model.dart';
import '../../data/category_data.dart';
import '../view_models/transaksi_controller.dart';

final controller = TransaksiController();

class ExpensePieChart extends StatelessWidget {
  final List<SummaryModel> data;

  const ExpensePieChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final filtered = data.where((e) => e.amount > 0).toList();

    return PieChart(
      PieChartData(
        sections: filtered.map((e) {
          final category = KategoryData.getById(e.categoryId);

          return PieChartSectionData(
            value: e.amount,
            title: '${category.name}\n${e.amount.toInt()}',
            radius: 70,
            titleStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }
}
