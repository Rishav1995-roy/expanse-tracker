import 'package:expanse_tracker_app/core/util/string_extension.dart';
import 'package:expanse_tracker_app/features/home/presentation/bloc/user_data_bloc.dart';
import 'package:expanse_tracker_app/features/home/presentation/bloc/user_data_event.dart';
import 'package:expanse_tracker_app/features/home/presentation/bloc/user_data_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UpdateUserIncomeDialog extends StatefulWidget {
  final String userID;
  final double salary;
  const UpdateUserIncomeDialog({
    super.key,
    required this.salary,
    required this.userID,
  });

  @override
  State<UpdateUserIncomeDialog> createState() => _UpdateUserIncomeDialogState();
}

class _UpdateUserIncomeDialogState extends State<UpdateUserIncomeDialog>
    with WidgetsBindingObserver {
  double salary = 0.0;
  final _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _wasSaved = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _saveSalary();
  }

  void _saveSalary() {
    salary = widget.salary;
    _amountController.text = salary.toString().convertCurrencyInBottomSheet(
          salary,
          false,
        );
    _amountController.selection = TextSelection.collapsed(
      offset: _amountController.text.length,
    );
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _loadUserData() {
    if (!_wasSaved) return;
    if (widget.userID.isNotEmpty) {
      context
          .read<UserDataBloc>()
          .add(LoadUserDataEvent(userId: widget.userID));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataBloc, UserDataState>(
      listener: (context, state) {
        if (state is UserDataLoaded) {
          _wasSaved = true;
          _loadUserData();
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Salary updated successfully')),
          );
        }

        if (state is UserDataError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: AlertDialog(
        title: const Text('Update your salary'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
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
            ],
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
                    if (widget.userID.isNotEmpty) {
                      final amount = double.parse(
                          _amountController.text.replaceAll(",", ""));
                      context.read<UserDataBloc>().add(
                            UpdateUserSalaryEvent(
                              userId: widget.userID,
                              salary: amount,
                            ),
                          );
                    }
                  }
                },
                child: const Text('Save'),
              );
            },
          ),
        ],
      ),
    );
  }
}
