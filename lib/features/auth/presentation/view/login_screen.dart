import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:zlux_pos/core/theme/app_colors_ext.dart';
import 'package:zlux_pos/core/constants/app_size.dart';
import 'package:zlux_pos/core/localization/app_localizations_scope.dart';
import 'package:zlux_pos/core/error/failures.dart';
import 'package:zlux_pos/core/router/route_paths.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(loginViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null) context.go(RoutePaths.home);
        },
        error: (error, _) {
          final message = error is Failure ? error.message : 'Login failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: context.appColors.error,
            ),
          );
        },
      );
    });

    final isLoading = ref.watch(loginViewModelProvider).isLoading;

    return Scaffold(
      backgroundColor: context.appColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.strings.loginTitle,
                style: TextStyle(
                  color: context.appColors.textOnDark.withOpacity(0.6),
                  fontSize: AppSizes.fontLg,
                ),
              ),
              const SizedBox(height: AppSizes.lg),
              Center(
                child: Image.asset(
                  'assets/images/login.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              _FieldLabel(context.strings.loginEmailHint),
              const SizedBox(height: AppSizes.sm),
              _AuthTextField(
                controller: _emailController,
                hint: context.strings.loginEmailHint,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: AppSizes.md),
              _FieldLabel(context.strings.loginPasswordHint),
              const SizedBox(height: AppSizes.sm),
              _AuthTextField(
                controller: _passwordController,
                hint: context.strings.loginPasswordHint,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: context.appColors.authTextMuted,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              const SizedBox(height: AppSizes.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            ref
                                .read(loginViewModelProvider.notifier)
                                .signIn(
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );
                          },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: context.appColors.primary,
                    foregroundColor: context.appColors.badgeDark,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.md),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusFull),
                    ),
                  ),
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                          : Text(
                            context.strings.loginButton,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                ),
              ),
              const SizedBox(height: AppSizes.md),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    context.strings.forgotPassword,
                    style: TextStyle(color: context.appColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.xxl),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      color: context.appColors.textOnDark.withOpacity(0.7),
                    ),
                    children: [
                      TextSpan(text: context.strings.notHaveAccount),
                      TextSpan(
                        text: " " + context.strings.signup,
                        style: TextStyle(
                          color: context.appColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () => context.go(RoutePaths.signup),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(color: context.appColors.textOnDark.withOpacity(0.7)),
    );
  }
}

class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: context.appColors.authInputFill,
        suffixIcon: suffixIcon,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSizes.md,
          vertical: AppSizes.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
