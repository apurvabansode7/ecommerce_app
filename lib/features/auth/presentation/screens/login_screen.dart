import 'package:ecommerce_app/components/custom_button.dart';
import 'package:ecommerce_app/components/custom_textfield.dart';
import 'package:ecommerce_app/constants/app_colors.dart';
import 'package:ecommerce_app/features/auth/bloc/login_event.dart';
import 'package:ecommerce_app/features/auth/bloc/login_state.dart';
import 'package:ecommerce_app/features/dashboard/presentation/screeens/main_dashboard_screen.dart';
import 'package:ecommerce_app/utlis/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerce_app/features/auth/bloc/login_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _hidePassword = true;

  static final _emailRegex = RegExp(r'^[\w\.\-+]+@[\w\-]+(\.[\w\-]+)+$');
  static const _savedEmailKey = 'saved_login_email';
  static const _savedPasswordKey = 'saved_login_password';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final preferences = await SharedPreferences.getInstance();
    if (!mounted) return;

    _emailCtrl.text = preferences.getString(_savedEmailKey) ?? '';
    _passCtrl.text = preferences.getString(_savedPasswordKey) ?? '';
  }

  Future<void> _saveCredentials() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_savedEmailKey, _emailCtrl.text.trim());
    await preferences.setString(_savedPasswordKey, _passCtrl.text);
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value)) return 'Enter a valid email address';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    try {
      await _saveCredentials();
    } on Exception {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text('Unable to save login details locally.'),
          ),
        );
      return;
    }

    if (!mounted) return;
    context.read<LoginBloc>().add(
          LoginSubmitted(
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {

           ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(
          content: Text('Login successful'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.sucess,
        ),
      );
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => MainDashboardScreen()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginLoading;

        return Scaffold(
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.6, 0.3),
                radius: 1.1,
                colors: [Color(0xFFFFE3CF), Colors.white],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: context.wp(6)),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Hello Again!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.sp(24),
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: context.hp(1.5)),
                          Text(
                            "Welcome back you've\nbeen missed!",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: context.sp(15),
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: context.hp(4)),
                          CustomTextField(
                            controller: _emailCtrl,
                            hint: 'Enter email',
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: _validateEmail,
                          ),
                          SizedBox(height: context.hp(2)),
                          CustomTextField(
                            controller: _passCtrl,
                            hint: 'Password',
                            obscureText: _hidePassword,
                            textInputAction: TextInputAction.done,
                            validator: _validatePassword,
                            suffix: IconButton(
                              icon: Icon(
                                _hidePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textGrey,
                                size: context.sp(20),
                              ),
                              onPressed: () => setState(
                                () => _hidePassword = !_hidePassword,
                              ),
                            ),
                          ),
                          SizedBox(height: context.hp(1.5)),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Recovery Password',
                              style: TextStyle(
                                fontSize: context.sp(12),
                                color: AppColors.textDark,
                              ),
                            ),
                          ),
                          SizedBox(height: context.hp(3)),
                          CustomButton(
                            label: 'Sign in',
                            isLoading: isLoading,
                            onPressed: _submit,
                          ),
                          SizedBox(height: context.hp(3)),
                          const _OrDivider(),
                          SizedBox(height: context.hp(3)),
                          const _SocialRow(),
                          SizedBox(height: context.hp(4)),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Not a member? ',
                                style: TextStyle(fontSize: context.sp(12)),
                              ),
                              Text(
                                'Register now',
                                style: TextStyle(
                                  fontSize: context.sp(12),
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: Colors.black54)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.wp(3)),
          child: Text(
            'or continue with',
            style: TextStyle(fontSize: context.sp(12)),
          ),
        ),
        const Expanded(child: Divider(color: Colors.black54)),
      ],
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    // Swap these Icons for your own asset images (Google/Apple/Facebook logos)
    final items = [
      (Icons.g_mobiledata, Colors.red),
      (Icons.apple, Colors.black),
      (Icons.facebook, Colors.blue),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final item in items)
          Container(
            width: context.wp(context.isTablet ? 10 : 20),
            height: context.hp(6),
            decoration: BoxDecoration(
              // color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white),
            ),
            child: Icon(item.$1, color: item.$2, size: context.sp(28)),
          ),
      ],
    );
  }
}
