import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:zlux_pos/features/auth/presentation/view/login_screen.dart';
import 'package:zlux_pos/features/auth/presentation/view/signup_screen.dart';
import 'package:zlux_pos/features/home/presentation/view/home_screen.dart';
import 'package:zlux_pos/features/onboarding/presentation/view/onboarding_screen.dart';
import 'package:zlux_pos/features/order/edit/presentation/view/order_edit_screen.dart';
import 'package:zlux_pos/features/order/history/presentation/view/history_order_screen.dart';
import 'package:zlux_pos/features/order/history/presentation/view/history_screen.dart';
import 'package:zlux_pos/features/settings/presentation/view/setting_screen.dart';
import 'package:zlux_pos/features/setup/income/form/presentation/view/new_income_screen.dart';
import 'package:zlux_pos/features/setup/income/list/view/setup_income_screen.dart';
import 'package:zlux_pos/features/setup/merchant/presentation/view/setup_merchant_screen.dart';
import 'package:zlux_pos/features/setup/presentation/view/setup_screen.dart';
import 'package:zlux_pos/features/setup/product/form/presentation/view/edit_product_screen.dart';
import 'package:zlux_pos/features/setup/product/form/presentation/view/new_product_screen.dart';
import 'package:zlux_pos/features/setup/product/list/presentation/view/setup_product_screen.dart';
import 'package:zlux_pos/features/splash/presentation/view/splash_screen.dart';
import 'package:zlux_pos/features/transaction/presentation/view/transaction_screen.dart';

import '../../features/expense_entry/form/presentation/view/new_expense_entry_screen.dart';
import '../../features/expense_entry/list/view/expense_entry_list_screen.dart';
import '../../features/income_entry/form/presentation/view/new_income_entry_screen.dart';
import '../../features/income_entry/list/view/income_entry_list_screen.dart';
import '../../features/setup/expense/form/presentation/view/new_expense_screen.dart';
import '../../features/setup/expense/list/view/setup_expense_screen.dart';
import 'route_paths.dart';
part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) {
  return GoRouter(
    initialLocation: RoutePaths.splash,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: RoutePaths.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutePaths.onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: RoutePaths.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: RoutePaths.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: RoutePaths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutePaths.setting,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: RoutePaths.transaction,
        builder: (context, state) => const TransactionScreen(),
      ),
      GoRoute(
        path: RoutePaths.incomeEntries,
        builder: (context, state) => const IncomeEntryListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewIncomeEntryScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.expenseEntries,
        builder: (context, state) => const ExpenseEntryListScreen(),
        routes: [
          GoRoute(
            path: 'new',
            builder: (context, state) => const NewExpenseEntryScreen(),
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.setup,
        builder: (context, state) => const SetupScreen(),
        routes: [
          GoRoute(
            path: 'merchant',
            builder: (context, state) => const SetupMerchantScreen(),
          ),
          GoRoute(
            path: 'product',
            builder: (context, state) => const SetupProductScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const NewProductScreen(),
              ),
              GoRoute(
                path: 'edit/:id',
                builder:
                    (context, state) => EditProductScreen(
                      productId: state.pathParameters['id']!,
                    ),
              ),
            ],
          ),
          GoRoute(
            path: 'income',
            builder: (context, state) => const SetupIncomeScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const NewIncomeScreen(),
              ),
            ],
          ),
          GoRoute(
            path: 'expense',
            builder: (context, state) => SetupExpenseScreen(),
            routes: [
              GoRoute(
                path: 'new',
                builder: (context, state) => const NewExpenseScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RoutePaths.history,
        builder: (context, state) => const HistoryScreen(),
        routes: [
          GoRoute(
            path: 'order/:date',
            builder: (context, state) {
              final date = DateTime.parse(state.pathParameters['date']!);
              return HistoryOrderScreen(date: date);
            },
          ),
          GoRoute(
            path: 'order-edit/:id',
            builder:
                (context, state) =>
                    OrderEditScreen(orderId: state.pathParameters['id']!),
          ),
        ],
      ),
    ],
  );
}
