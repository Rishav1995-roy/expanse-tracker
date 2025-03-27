import 'package:expanse_tracker_app/core/util/images.dart';
import 'package:expanse_tracker_app/core/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_data_bloc.dart';
import '../bloc/user_data_event.dart';
import '../bloc/user_data_state.dart';
import '../../../../core/storage/user_storage.dart';
import 'expenses_list_widget.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadUserData();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Refresh data when app is resumed
      _loadUserData();
    }
  }

  void _loadUserData() {
    final userId = UserStorage.getUserId();
    if (userId.isNotEmpty) {
      context.read<UserDataBloc>().add(LoadUserDataEvent(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        _loadUserData();
      },
      child: BlocBuilder<UserDataBloc, UserDataState>(
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
            if (state.expenses.isEmpty && state.salary == null) {
              return const Center(
                child: Text('No data available yet. Add your first expense!'),
              );
            }
            
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  // Salary Card
                  Card(
                    margin: const EdgeInsets.all(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                child: Text(
                                  'Your Salary',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Image.asset(Images.money, width: 15, height: 15,),
                              const SizedBox(width: 10,),
                              Text(
                                '₹ ${state.salary?.toString().convertCurrencyInBottomSheet(state.salary ?? 0.0, false) ?? '0.00'}',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Expenses Title
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Your Expenses',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Total: ₹ ${_calculateTotal(state.expenses).toStringAsFixed(2)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expenses List
                  state.expenses.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(32.0),
                          child: Center(
                            child: Text(
                                'No expenses added yet. Add your first expense!'),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.expenses.length,
                          itemBuilder: (context, index) {
                            final expense = state.expenses[index];
                            return ExpenseCard(expense: expense);
                          },
                        ),
                ],
              ),
            );
          }

          return const Center(child: Text('No data available'));
        },
      ),
    );
  }

  double _calculateTotal(List<dynamic> expenses) {
    return expenses.fold(0.0, (sum, expense) => sum + expense.amount);
  }
}
