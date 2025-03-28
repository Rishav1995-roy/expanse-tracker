import 'package:expanse_tracker_app/core/util/images.dart';
import 'package:expanse_tracker_app/core/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../data/models/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final String categoryName;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      _getImage(categoryName),
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      categoryName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                Text(
                  'Due date: ${expense.dueDate}${_getOrdinalSuffix(int.parse(expense.dueDate))} of every month',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.black,
                        fontSize: 13
                      ),
                ),
                if (expense.updatedAt != null)
                  Text(
                    'Last updated: ${_formatDate(expense.updatedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
              ],
            ),
            Text(
              '₹ ${expense.amount.toString().convertCurrencyInBottomSheet(expense.amount, false)}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dateTime) {
    return DateFormat('dd MMM,yyyy').format(dateTime);
  }

  String _getImage(String category) {
    switch (category) {
      case '2- wheeler loan':
        return Images.bike;
      case 'Home loan':
        return Images.house;
      case 'Personal loan':
        return Images.personal;
      case '4-wheeler loan':
        return Images.car;
      case 'LIC premium':
        return Images.lic;
      case 'Health insurance':
        return Images.health;
      case 'House rent':
        return Images.houseRent;
      case 'Maid charges':
        return Images.maid;
      case 'OTT charges':
        return Images.ott;
      case 'Others':
        return Images.others;
      case 'Wifi rent':
        return Images.wifi;
      case 'Investments':
        return Images.investment;
      default:
        return '';
    }
  }

  String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th'; // Special case for 11, 12, 13
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
