import 'package:expanse_tracker_app/core/util/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({super.key});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _salaryController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void onChangeSalary(String amount) {
    if (amount.isNotEmpty) {
      double value = double.parse(amount.replaceAll(",", ""));
      _salaryController.text =
          amount.convertCurrencyInBottomSheet(value, false);
      _salaryController.selection = TextSelection.collapsed(
        offset: _salaryController.text.length,
      );
    } else {
      _salaryController.clear();
    }
    if (mounted) setState(() {});
  }

  String? _validateSalary(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your salary';
    }
    if (double.tryParse(value.replaceAll(",", "")) == null) {
      return 'Please enter a valid number';
    }
    if (double.parse(value.replaceAll(",", "")) <= 0) {
      return 'Salary must be greater than 0';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            SignUpWithEmailPasswordEvent(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
              salary: double.parse(_salaryController.text.trim().replaceAll(",", "")),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'Sign up to get started',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                validator: _validatePassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                validator: _validateConfirmPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _salaryController,
                decoration: InputDecoration(
                  labelText: 'Monthly Salary',
                  prefixIcon: _salaryController.text.isEmpty
                      ? Icon(Icons.attach_money)
                      : null,
                  prefix: _salaryController.text.isEmpty
                      ? IgnorePointer()
                      : Text(
                          '₹ ',
                          style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                            fontSize: 18,
                          ),
                        ),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  onChangeSalary(value);
                },
                validator: _validateSalary,
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Sign In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
