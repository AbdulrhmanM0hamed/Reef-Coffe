import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hyper_market/core/utils/constants/font_manger.dart';
import 'package:hyper_market/core/utils/constants/styles_manger.dart';
import 'package:hyper_market/core/services/service_locator.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_cubit.dart';
import 'package:hyper_market/feature/products/presentation/cubit/products_state.dart';
import 'package:hyper_market/feature/details/presentation/view/details_view.dart';

class CustomSearchTextField extends StatefulWidget {
  const CustomSearchTextField({super.key});

  @override
  State<CustomSearchTextField> createState() => _CustomSearchTextFieldState();
}

class _CustomSearchTextFieldState extends State<CustomSearchTextField> {
  final LayerLink _layerLink = LayerLink();
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  bool _showOverlay = false;
  OverlayEntry? _overlayEntry;
  late final ProductsCubit _productsCubit;

  @override
  void initState() {
    super.initState();
    _productsCubit = getIt<ProductsCubit>();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _productsCubit.getAllProducts();
        _showOverlay = true;
        _showSearchOverlay();
      } else {
        _hideSearchOverlay();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _searchController.dispose();
    _hideSearchOverlay();
    super.dispose();
  }

  void _showSearchOverlay() {
    _overlayEntry = _createOverlayEntry();
    if (!mounted) return;
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideSearchOverlay() {
    _showOverlay = false;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _resetSearch() {
    _searchController.clear();
    if (mounted) {
      _productsCubit.getAllProducts();
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(12),
            child: BlocProvider.value(
              value: _productsCubit,
              child: BlocBuilder<ProductsCubit, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoaded && _showOverlay) {
                    final products = state.products;
                    if (products.isEmpty) {
                      return Container(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'لا توجد منتجات',
                          style: getRegularStyle(
                            fontFamily: FontConstant.cairo,
                            fontSize: 14,
                          ),
                        ),
                      );
                    }
                    return Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return ListTile(
                            title: Text(
                              product.name,
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: 14,
                              ),
                            ),
                            subtitle: Text(
                              '${product.price} جنيه',
                              style: getRegularStyle(
                                fontFamily: FontConstant.cairo,
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                            onTap: () {
                              _hideSearchOverlay();
                              _focusNode.unfocus();
                              _resetSearch();
                              Navigator.pushNamed(
                                context,
                                DetailsView.routeName,
                                arguments: product,
                              );
                            },
                          );
                        },
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _productsCubit,
      child: Builder(
        builder: (context) => CompositedTransformTarget(
          link: _layerLink,
          child: TextField(
            controller: _searchController,
            focusNode: _focusNode,
            onChanged: (query) {
              if (!mounted) return;
              _productsCubit.searchProducts(query);
              if (query.isNotEmpty && !_showOverlay) {
                setState(() {
                  _showOverlay = true;
                  _showSearchOverlay();
                });
              }
            },
            decoration: InputDecoration(
              hintText: "ابحث عن الذي تريده",
              prefixIcon: SizedBox(
                width: 20,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/search_icon.svg",
                    width: 25,
                  ),
                ),
              ),
              suffixIcon: SizedBox(
                width: 20,
                child: Center(
                  child: SvgPicture.asset(
                    "assets/images/filter.svg",
                    width: 25,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
