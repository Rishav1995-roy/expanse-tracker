import 'package:expanse_tracker_app/core/storage/user_storage.dart';
import 'package:expanse_tracker_app/core/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/expense_model.dart';
import '../bloc/user_data_bloc.dart';
import '../bloc/user_data_event.dart';
import '../bloc/user_data_state.dart';

class ExpensesListWidget extends StatefulWidget {
  const ExpensesListWidget({super.key});

  @override
  State<ExpensesListWidget> createState() => _ExpensesListWidgetState();
}

class _ExpensesListWidgetState extends State<ExpensesListWidget> {
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userId = UserStorage.getUserId();
    if (userId.isNotEmpty) {
      context.read<UserDataBloc>().add(LoadUserDataEvent(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is UserDataLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is UserDataError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadUserData,
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is UserDataLoaded) {
          if (state.expenses.isEmpty) {
            return const Center(
              child: Text('No expenses added yet. Add your first expense!'),
            );
          }

          return ListView.builder(
            itemCount: state.expenses.length,
            itemBuilder: (context, index) {
              final expense = state.expenses[index];
              return ExpenseCard(expense: expense);
            },
          );
        }

        return const Center(child: Text('No data available'));
      },
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final ExpenseModel expense;

  const ExpenseCard({super.key, required this.expense});

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
                      _getImage(expense.category),
                      width: 18,
                      height: 18,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      expense.category,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
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
              '₹ ${expense.amount.toStringAsFixed(2)}',
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
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
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
      default:
        return '';
    }
  }
}
