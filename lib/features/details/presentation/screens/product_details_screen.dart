import 'package:ecommerce_app_huma_volve/core/navigation/app_router.dart';
import 'package:ecommerce_app_huma_volve/core/theme/app_theme.dart';
import 'package:ecommerce_app_huma_volve/core/widgets/primary_button.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/cubit/product_details_states.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/widgets/color_selector.dart';
import 'package:ecommerce_app_huma_volve/features/details/presentation/widgets/size_selector.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/entities/product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Product details for a [Product] the caller already holds (home grid) or for
/// a product id coming from a deep link.
class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({super.key, required Product this.product})
    : productId = null;

  /// Entry point used by [AppRouter] for `/product/<id>` links.
  const ProductDetailsScreen.fromLink({super.key, required int this.productId})
    : product = null;

  final Product? product;
  final int? productId;

  @override
  Widget build(BuildContext context) {
    final product = this.product;

    // The home grid already holds the product, so only links need a request.
    if (product != null) {
      return _ProductDetailsView(product: product);
    }

    return BlocProvider(
      create: (context) => ProductDetailsCubit()..getProduct(productId!),
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsStates>(
        builder: (context, state) {
          final cubit = context.read<ProductDetailsCubit>();
          if (state is ProductDetailsErrorState) {
            return _ProductDetailsErrorView(
              message: state.message,
              onRetry: () => cubit.getProduct(productId!),
            );
          }
          final loadedProduct = cubit.product;
          if (loadedProduct == null) {
            return const _ProductDetailsLoadingView();
          }
          return _ProductDetailsView(product: loadedProduct);
        },
      ),
    );
  }
}

class _ProductDetailsView extends StatefulWidget {
  final Product product;

  const _ProductDetailsView({required this.product});

  @override
  State<_ProductDetailsView> createState() => _ProductDetailsViewState();
}

class _ProductDetailsViewState extends State<_ProductDetailsView> {
  // The API has no variants, so the screen shows a fixed set of options.
  static const List<Color> _colors = [Colors.white, Colors.black, Colors.grey];
  static const List<String> _sizes = ['S', 'M', 'L', 'XL'];

  late Color _selectedColor = _colors.first;
  late String _selectedSize = _sizes.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: AppTheme.background,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back_ios_new, size: 16),
              ),
              onPressed: () => AppRouter.back(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 18),
                ),
                onPressed: () {},
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: 'product-${widget.product.id}',
                child: Image.network(
                  widget.product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.image_outlined,
                      color: Colors.grey,
                      size: 48,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              ),
              transform: Matrix4.translationValues(0.0, -32.0, 0.0),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.product.name,
                            style: Theme.of(context).textTheme.headlineLarge
                                ?.copyWith(fontSize: 28, height: 1.2),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: AppTheme.primary, fontSize: 24),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.product.description,
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(height: 1.6, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Select Color',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ColorSelector(
                      colors: _colors,
                      selectedColor: _selectedColor,
                      onColorSelected: (color) {
                        setState(() {
                          _selectedColor = color;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Select Size',
                      style: Theme.of(context).textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    SizeSelector(
                      sizes: _sizes,
                      selectedSize: _selectedSize,
                      onSizeSelected: (size) {
                        setState(() {
                          _selectedSize = size;
                        });
                      },
                    ),
                    const SizedBox(height: 32),
                    PrimaryButton(
                      text: 'Add to Cart',
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${widget.product.name} added to cart',
                            ),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: AppTheme.primary,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductDetailsLoadingView extends StatelessWidget {
  const _ProductDetailsLoadingView();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppTheme.background,
      body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
    );
  }
}

class _ProductDetailsErrorView extends StatelessWidget {
  const _ProductDetailsErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 16),
          onPressed: () => AppRouter.back(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Failed to load this product: $message',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade300, fontSize: 13),
            ),
            const SizedBox(height: 16),
            PrimaryButton(text: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
