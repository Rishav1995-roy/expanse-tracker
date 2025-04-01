import 'package:expanse_tracker_app/core/storage/user_storage.dart';
import 'package:expanse_tracker_app/core/util/images.dart';
import 'package:expanse_tracker_app/core/util/string_extension.dart';
import 'package:expanse_tracker_app/features/home/presentation/bloc/user_data_bloc.dart';
import 'package:expanse_tracker_app/features/home/presentation/bloc/user_data_event.dart';
import 'package:expanse_tracker_app/features/home/presentation/bloc/user_data_state.dart';
import 'package:expanse_tracker_app/features/home/presentation/widgets/expense_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/models/expense_model.dart';

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;
  final String categoryName;
  final Function loadUserData;

  const ExpenseCard({
    super.key,
    required this.expense,
    required this.categoryName,
    required this.loadUserData,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.only(top: 16, left: 16, bottom: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.copyWith(color: Colors.black, fontSize: 13),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '₹ ${expense.amount.toString().convertCurrencyInBottomSheet(expense.amount, false)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                PopupMenuButton(
                  padding: const EdgeInsets.all(2),
                  onSelected: (value) async {
                    if (value == 'Update') {
                      await showDialog(
                        context: context,
                        builder: (context) => ExpenseInputDialog(
                          categoryName: categoryName,
                          amount: expense.amount,
                          dueDate: expense.dueDate,
                        ),
                      );
                    } else if (value == 'Delete') {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Expanse'),
                          content: const Text(
                              'Are you sure you want to delete this expanse?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancel'),
                            ),
                            BlocBuilder<UserDataBloc, UserDataState>(
                              builder: (context, state) {
                                if (state is UserDataLoading) {
                                  return const ElevatedButton(
                                    onPressed: null,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  );
                                }
                                return TextButton(
                                  onPressed: () {
                                    context.read<UserDataBloc>().add(
                                          DeleteExpenseEvent(
                                            userId: UserStorage.getUserId(),
                                            category: categoryName,
                                          ),
                                        );
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'Update',
                      child: Row(
                        children: [
                          Icon(Icons.update),
                          SizedBox(width: 8),
                          Text('Update'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'Delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
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
