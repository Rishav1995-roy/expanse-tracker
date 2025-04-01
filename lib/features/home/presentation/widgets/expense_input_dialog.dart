import 'package:expanse_tracker_app/core/storage/user_storage.dart';
import 'package:expanse_tracker_app/core/util/images.dart';
import 'package:expanse_tracker_app/core/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/user_data_bloc.dart';
import '../bloc/user_data_event.dart';
import '../bloc/user_data_state.dart';

class ExpenseInputDialog extends StatefulWidget {
  final double amount;
  final String categoryName;
  final String dueDate;

  const ExpenseInputDialog({
    super.key,
    required this.amount,
    required this.categoryName,
    required this.dueDate,
  });

  @override
  State<ExpenseInputDialog> createState() => _ExpenseInputDialogState();
}

class _ExpenseInputDialogState extends State<ExpenseInputDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String _selectedCategory = '2- wheeler loan';
  String _dueDate = '2';
  bool _wasSaved = false;
  List<int> numbers = List.generate(28, (index) => index + 1);

  final Map<String, dynamic> _categories = {
    Images.bike: '2- wheeler loan',
    Images.house: 'Home loan',
    Images.personal: 'Personal loan',
    Images.car: '4-wheeler loan',
    Images.lic: 'LIC premium',
    Images.health: 'Health insurance',
    Images.houseRent: 'House rent',
    Images.wifi: 'Wifi rent',
    Images.maid: 'Maid charges',
    Images.ott: 'OTT charges',
    Images.others: 'Others',
    Images.investment: 'Investments',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadData());
  }

  void _loadData() {
    if (widget.categoryName.isNotEmpty) {
      _dueDate = widget.dueDate.toString();
      _selectedCategory = widget.categoryName;
      _amountController.text = "".convertCurrencyInBottomSheet(
        widget.amount,
        false,
      );
      _amountController.selection = TextSelection.collapsed(
        offset: _amountController.text.length,
      );
      if(mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    if (!_wasSaved) return;
    final userId = UserStorage.getUserId();
    if (userId.isNotEmpty) {
      context.read<UserDataBloc>().add(LoadUserDataEvent(userId: userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if (state is UserDataSaved) {
          _wasSaved = true;
          _loadUserData();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.categoryName.isEmpty? 'Expense saved successfully' : 'Expense updated successfully')),
          );
        }

        if (state is UserDataError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Add New Expense'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: _categories
                      .map((k, v) {
                        return MapEntry(
                          k,
                          DropdownMenuItem<String>(
                            value: v,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  k,
                                  width: 15,
                                  height: 15,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(v),
                              ],
                            ),
                          ),
                        );
                      })
                      .values
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Amount',
                    prefixText: '₹ ',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (amount) {
                    if (amount.isNotEmpty) {
                      double value = double.parse(amount.replaceAll(",", ""));
                      _amountController.text =
                          amount.convertCurrencyInBottomSheet(value, false);
                      _amountController.selection = TextSelection.collapsed(
                        offset: _amountController.text.length,
                      );
                    } else {
                      _amountController.clear();
                    }
                    if (mounted) setState(() {});
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an amount';
                    }
                    if (double.tryParse(value.replaceAll(",", "")) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _dueDate,
                  decoration: const InputDecoration(
                    labelText: 'Due date',
                    border: OutlineInputBorder(),
                  ),
                  items: numbers
                      .map(
                        (e) => DropdownMenuItem<String>(
                          value: e.toString(),
                          child: Text(
                            e.toString(),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _dueDate = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
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

              return ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final userId = UserStorage.getUserId();
                    if (userId.isNotEmpty) {
                      final amount = double.parse(
                          _amountController.text.replaceAll(",", ""));
                      if(widget.categoryName.isEmpty) {    
                      context.read<UserDataBloc>().add(
                            SaveExpenseEvent(
                              userId: userId,
                              category: _selectedCategory,
                              amount: amount,
                              dueDate: _dueDate,
                            ),
                          );
                      } else {
                        context.read<UserDataBloc>().add(
                            UpdateExpenseEvent(
                              userId: userId,
                              category: _selectedCategory,
                              amount: amount,
                              dueDate: _dueDate,
                            ),
                          );
                      }
                    }
                  }
                },
                child: Text(widget.categoryName.isEmpty? 'Save' : 'Update'),
              );
            },
          ),
        ],
      ),
    );
  }
}
