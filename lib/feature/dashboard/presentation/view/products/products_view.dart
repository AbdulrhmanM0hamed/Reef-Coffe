import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/feature/dashboard/data/models/product_model.dart';
import 'package:hyper_market/feature/dashboard/presentation/view/products/add_product_view.dart';
import 'package:hyper_market/feature/dashboard/presentation/view/products/edit_product_view.dart';
import 'package:hyper_market/feature/dashboard/presentation/view_model/categories/categories_cubit.dart';
import 'package:hyper_market/feature/dashboard/presentation/view_model/products/products_cubit.dart';

class ProductsView extends StatelessWidget {
  const ProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductsCubit()..loadProducts(),
      child: Builder(
        builder: (context) => BlocBuilder<ProductsCubit, ProductsState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('المنتجات'),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              BlocProvider(
                                create: (context) => ProductsCubit(),
                              ),
                              BlocProvider(
                                create: (context) => CategoriesCubit()..loadCategories(),
                              ),
                            ],
                            child: const AddProductView(),
                          ),
                        ),
                      ).then((_) {
                        BlocProvider.of<ProductsCubit>(context).loadProducts();
                      });
                    },
                  ),
                ],
              ),
              body: _buildBody(context, state),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductsState state) {
    if (state is ProductsLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is ProductsError) {
      return Center(child: Text(state.message));
    }
    if (state is ProductsFetched) {
      if (state.products.isEmpty) {
        return const Center(child: Text('لا توجد منتجات'));
      }
      return ListView.builder(
        itemCount: state.products.length,
        itemBuilder: (context, index) => _buildProductCard(context, state.products[index]),
      );
    }
    return const SizedBox();
  }

  Widget _buildProductCard(BuildContext context, ProductModel product) {
    final productsCubit = BlocProvider.of<ProductsCubit>(context);
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product.imageUrl != null)
            Image.network(
              product.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 200),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(product.description),
                const SizedBox(height: 8),
                Text('السعر: ${product.price} ريال'),
                Text('الكمية: ${product.stock}'),
                if (product.discountPercentage != null)
                  Text('نسبة الخصم: ${product.discountPercentage}%'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (_) => ProductsCubit(),
                              child: EditProductView(product: product),
                            ),
                          ),
                        ).then((_) {
                          productsCubit.loadProducts();
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('تأكيد الحذف'),
                            content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('إلغاء'),
                              ),
                              TextButton(
                                onPressed: () {
                                  productsCubit.deleteProduct(product.id);
                                  Navigator.pop(context);
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
