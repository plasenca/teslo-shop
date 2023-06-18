import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/products/products.dart'
    show Product, ProductsRepository, productsRepositoryProvider;

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductsNotifier(productsRepository: productsRepository);
});

class ProductsNotifier extends StateNotifier<ProductsState> {
  final ProductsRepository productsRepository;

  ProductsNotifier({
    required this.productsRepository,
  }) : super(ProductsState()) {
    loadNextPage();
  }

  Future<bool> createOrUpdateProduct(Map<String, dynamic> productLike) async {
    try {
      final product = await productsRepository.createProduct(productLike);

      final isProductExists = state.products.any((p) => p.id == product.id);

      if (!isProductExists) {
        state = state.copyWith(
          products: [...state.products, product],
        );
        return true;
      }

      // Bring the Update o Create Product to the top of the list
      state = state.copyWith(
        products: state.products.map((p) {
          if (p.id == product.id) {
            return product;
          }
          return p;
        }).toList(),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future loadNextPage() async {
    if (state.isLoading || state.isLastPage) return;

    state = state.copyWith(isLoading: true);

    final products = await productsRepository.getProductsByPage(
      limit: state.limit,
      offset: state.offset,
    );

    if (products.isEmpty) {
      state = state.copyWith(isLastPage: true, isLoading: false);
    } else {
      state = state.copyWith(
        isLastPage: false,
        isLoading: false,
        offset: state.offset + 5,
        products: [...state.products, ...products],
      );
    }
  }
}

class ProductsState {
  final bool isLastPage;
  final int limit;
  final int offset;
  final bool isLoading;
  final List<Product> products;

  ProductsState({
    this.isLastPage = false,
    this.limit = 10,
    this.offset = 0,
    this.isLoading = false,
    this.products = const [],
  });

  ProductsState copyWith({
    bool? isLastPage,
    int? limit,
    int? offset,
    bool? isLoading,
    List<Product>? products,
  }) =>
      ProductsState(
        isLastPage: isLastPage ?? this.isLastPage,
        limit: limit ?? this.limit,
        offset: offset ?? this.offset,
        isLoading: isLoading ?? this.isLoading,
        products: products ?? this.products,
      );
}
