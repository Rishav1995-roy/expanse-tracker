import 'package:expanse_tracker_app/core/util/string_extension.dart';
import 'package:expanse_tracker_app/features/home/data/models/expense_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExpensesPieChart extends StatefulWidget {
  final Map<String,ExpenseModel> expenses;

  const ExpensesPieChart({
    super.key,
    required this.expenses,
  });
  @override
  State<ExpensesPieChart> createState() => _ExpensesPieChartState();
}

class _ExpensesPieChartState extends State<ExpensesPieChart> {
  int _selectedIndex = -1;
  String _selectedvalue = '';

  @override
  Widget build(BuildContext context) {
    if (widget.expenses.isEmpty) {
      return const Center(
        child: Text('No expenses to display'),
      );
    }

    // Calculate total expenses
    final total =
        widget.expenses.values.fold(0.0, (sum, expense) => sum + expense.amount);

    // Group expenses by category and calculate percentages
    final Map<String, double> categoryTotals = {};
    widget.expenses.forEach((k,v) {
      categoryTotals[k] = v.amount;
    });

    // Sort categories by amount (highest first)
    final sortedCategories = categoryTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Create pie chart sections
    final List<ChartData> chartData = [];
    final Map<String, Color> colors = {
      '2- wheeler loan': Colors.blue,
      'Home loan': Colors.red,
      'Personal loan': Colors.green,
      '4-wheeler loan': Colors.orange,
      'LIC premium': Colors.purple,
      'Health insurance': Colors.teal,
      'House rent': Colors.pink,
      'Wifi rent': Colors.indigo,
      'Maid charges': Colors.amber,
      'OTT charges': Colors.deepOrange,
      'Investments': Colors.lime,
      'Others': Colors.deepOrange,
    };

    for (var entry in sortedCategories) {
      chartData.add(
        ChartData(
          entry.key,
          (entry.value / total) * 100,
          colors[entry.key]!,
        ),
      );
    }

    return Column(
      children: [
        SizedBox(
          height: 300,
          child: SfCircularChart(
            series: <CircularSeries>[
              DoughnutSeries<ChartData, String>(
                dataSource: chartData,
                pointColorMapper: (ChartData data, _) => data.color,
                xValueMapper: (ChartData data, _) => data.category,
                yValueMapper: (ChartData data, _) => data.value,
                strokeWidth: 1,
                dataLabelSettings: const DataLabelSettings(
                  isVisible: false,
                ),
                enableTooltip: true,
                radius: '80%',
                explode: true,
                explodeIndex: _selectedIndex,
                onPointTap: (ChartPointDetails details) {
                  setState(() {
                    _selectedIndex = details.pointIndex!;
                    _selectedvalue = chartData[_selectedIndex].category;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sortedCategories.map((entry) {
            final percentage = (entry.value / total) * 100;
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: colors[entry.key],
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 4),
                Opacity(
                  opacity: _selectedvalue.isEmpty? 1.0 : _selectedvalue == entry.key? 1.0 : 0.4,
                  child: Text(
                    '${entry.key}: ₹${entry.value.toString().convertCurrencyInBottomSheet(entry.value, false)} (${percentage.toStringAsFixed(1)}%)',
                    style: TextStyle(
                      fontSize: _selectedvalue == entry.key? 13 : 12,
                      fontWeight: _selectedvalue == entry.key? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class ChartData {
  final String category;
  final double value;
  final Color color;
  ChartData(
    this.category,
    this.value,
    this.color,
  );
}
