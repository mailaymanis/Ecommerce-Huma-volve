import 'package:ecommerce_app_huma_volve/core/constants/app_constants.dart';
import 'package:ecommerce_app_huma_volve/core/theme/app_theme.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_cubit.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/cubit/home_states.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/widgets/category_chip.dart';
import 'package:ecommerce_app_huma_volve/features/home/presentation/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..getCategories()
        ..getProducts(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  // Distance from the bottom of the grid that triggers the next page.
  static const double _loadMoreThreshold = 300;

  int _selectedCategoryIndex = 0;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter < _loadMoreThreshold) {
      context.read<HomeCubit>().loadMoreProducts();
    }
  }

  void _selectCategory(HomeCubit cubit, int index) {
    if (_selectedCategoryIndex == index) return;
    setState(() {
      _selectedCategoryIndex = index;
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    cubit.getProducts(categoryId: cubit.categories[index].id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: AppTheme.primary,
                          ),
                        ),
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            AppConstants.placeholderAvatarUrl,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      'Explore',
                      style: Theme.of(context).textTheme.displayLarge
                          ?.copyWith(fontSize: 36),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Best trendy collection!',
                      style: Theme.of(context).textTheme.bodyMedium
                          ?.copyWith(fontSize: 18),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.05),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search clothes...',
                          hintStyle: TextStyle(color: Colors.grey.shade400),
                          prefixIcon: const Icon(
                            Icons.search,
                            color: Colors.grey,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.primary,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.tune,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    BlocBuilder<HomeCubit, HomeStates>(
                      builder: (context, state) {
                        final cubit = context.read<HomeCubit>();
                        if (state is CategoryLoadingState) {
                          return const SizedBox(
                            height: 44,
                            child: Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppTheme.primary,
                                ),
                              ),
                            ),
                          );
                        }
                        if (state is CategoryErrorState) {
                          return SizedBox(
                            height: 44,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Failed to load categories: ${state.message}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.red.shade300,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: cubit.getCategories,
                                  child: const Text('Retry'),
                                ),
                              ],
                            ),
                          );
                        }
                        if (cubit.categories.isEmpty) {
                          return SizedBox(
                            height: 44,
                            child: Center(
                              child: Text(
                                'No categories found',
                                style: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          height: 44,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: cubit.categories.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 12),
                            itemBuilder: (context, index) {
                              return CategoryChip(
                                label: cubit.categories[index].name,
                                isSelected: _selectedCategoryIndex == index,
                                onTap: () => _selectCategory(cubit, index),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  final cubit = context.read<HomeCubit>();
                  if (state is ProductsLoadingState) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 80),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    );
                  }
                  if (state is ProductsErrorState) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Column(
                          children: [
                            Text(
                              'Failed to load products: ${state.message}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red.shade300,
                                fontSize: 13,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                final selectedCategory =
                                    cubit.categories.isNotEmpty
                                    ? cubit.categories[_selectedCategoryIndex]
                                    : null;
                                cubit.getProducts(
                                  categoryId: selectedCategory?.id,
                                );
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  if (cubit.products.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(child: Text('No products found')),
                      ),
                    );
                  }
                  return SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return ProductCard(product: cubit.products[index]);
                    }, childCount: cubit.products.length),
                  );
                },
              ),
            ),
            SliverToBoxAdapter(
              child: BlocBuilder<HomeCubit, HomeStates>(
                builder: (context, state) {
                  final cubit = context.read<HomeCubit>();
                  if (cubit.products.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  if (cubit.isLoadingMore) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTheme.primary,
                          ),
                        ),
                      ),
                    );
                  }
                  final loadMoreError = cubit.loadMoreError;
                  if (loadMoreError != null) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        children: [
                          Text(
                            'Failed to load more products: $loadMoreError',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.red.shade300,
                              fontSize: 13,
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                cubit.loadMoreProducts(retry: true),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  if (cubit.hasReachedEnd) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No more products',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
