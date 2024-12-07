import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/dashboard/presentation/view/categories/categories_view.dart';
import 'package:hyper_market/feature/dashboard/presentation/view_model/categories/categories_cubit.dart';
import 'package:hyper_market/feature/dashboard/presentation/widgets/drawer_widget.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم'),
      ),
      drawer: const DrawerWidget(),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _buildDashboardCard(
            context,
            icon: Icons.category,
            title: 'الفئات',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BlocProvider(
                  create: (context) => CategoriesCubit()..loadCategories(),
                  child: const CategoriesView(),
                ),
              ),
            ),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.shopping_bag,
            title: 'المنتجات',
            onTap: () => Navigator.pushNamed(context, '/products'),
          ),
          _buildDashboardCard(
            context,
            icon: Icons.people,
            title: 'المستخدمين',
            onTap: () {
              // TODO: Navigate to users
            },
          ),
          _buildDashboardCard(
            context,
            icon: Icons.shopping_cart,
            title: 'الطلبات',
            onTap: () {
              // TODO: Navigate to orders
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48),
            const SizedBox(height: 8),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
