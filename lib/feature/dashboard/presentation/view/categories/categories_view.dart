import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/dashboard/data/models/category_model.dart';
import 'package:hyper_market/feature/dashboard/presentation/view/categories/add_category_view.dart';
import 'package:hyper_market/feature/dashboard/presentation/view/categories/edit_category_view.dart';
import 'package:hyper_market/feature/dashboard/presentation/view_model/categories/categories_cubit.dart';

class CategoriesView extends StatelessWidget {
  const CategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفئات'),
        actions: [
          BlocBuilder<CategoriesCubit, CategoriesState>(
            builder: (context, state) {
              if (state is CategoriesLoading) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  final cubit = context.read<CategoriesCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider.value(
                        value: cubit,
                        child: const AddCategoryView(),
                      ),
                    ),
                  ).then((_) {
                    cubit.loadCategories();
                  });
                },
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CategoriesCubit, CategoriesState>(
        builder: (context, state) {
          if (state is CategoriesInitial) {
            context.read<CategoriesCubit>().loadCategories();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CategoriesLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CategoriesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      final cubit = context.read<CategoriesCubit>();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: cubit,
                            child: const AddCategoryView(),
                          ),
                        ),
                      ).then((_) {
                        cubit.loadCategories();
                      });
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة فئة جديدة'),
                  ),
                ],
              ),
            );
          }

          if (state is CategoriesLoaded) {
            final categories = state.categories;

            if (categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('لا توجد فئات'),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        final cubit = context.read<CategoriesCubit>();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: cubit,
                              child: const AddCategoryView(),
                            ),
                          ),
                        ).then((_) {
                          cubit.loadCategories();
                        });
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('إضافة فئة جديدة'),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<CategoriesCubit>().loadCategories();
              },
              child: ListView.builder(
                itemCount: categories.length,
                padding: const EdgeInsets.all(8),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return _buildCategoryCard(context, category);
                },
              ),
            );
          }

          return const Center(child: Text('حالة غير معروفة'));
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, CategoryModel category) {
    final cubit = context.read<CategoriesCubit>();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: category.imageUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  category.imageUrl!,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.image_not_supported);
                  },
                ),
              )
            : const Icon(Icons.category),
        title: Text(category.name),
        subtitle: Text(category.description),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                      value: cubit,
                      child: EditCategoryView(category: category),
                    ),
                  ),
                ).then((_) {
                  cubit.loadCategories();
                });
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('حذف الفئة'),
                    content: const Text('هل أنت متأكد من حذف هذه الفئة؟'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          cubit.deleteCategory(category.id!);
                        },
                        child: const Text('حذف'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
