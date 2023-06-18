import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/config/config.dart';

import 'package:teslo_shop/features/shared/shared.dart';
import 'package:teslo_shop/features/products/products.dart';

final productFormProvider = StateNotifierProvider.autoDispose
    .family<ProductFormNotifier, ProductFormState, Product>(
  (ref, product) {
    // final createUpdateCallback = ref.watch(productsRepositoryProvider);
    final createUpdateCallback =
        ref.watch(productsProvider.notifier).createOrUpdateProduct;

    return ProductFormNotifier(
      product: product,
      onSubmitt: createUpdateCallback,
    );
  },
);

class ProductFormNotifier extends StateNotifier<ProductFormState> {
  final Future<bool> Function(Map<String, dynamic> productLike)? onSubmitt;

  ProductFormNotifier({
    this.onSubmitt,
    required Product product,
  }) : super(
          ProductFormState(
            id: product.id,
            title: Title.dirty(product.title),
            slug: Slug.dirty(product.slug),
            price: Price.dirty(product.price),
            inStock: Stock.dirty(product.stock),
            tags: product.tags.join(', '),
            description: product.description,
            gender: product.gender,
            images: product.images,
            sizes: product.sizes,
          ),
        );

  void updateProductImage(String path) {
    state = state.copyWith(images: [...state.images, path]);
  }

  Future<bool> onFormSubmit() async {
    _touchedEverything();

    if (!state.isFormValid) return false;

    if (onSubmitt == null) return false;

    final productLike = ProductMapper.toJsonWithRaw(
      id: state.id == "new" ? null : state.id,
      description: state.description,
      gender: state.gender,
      price: state.price.value,
      sizes: state.sizes,
      slug: state.slug.value,
      stock: state.inStock.value,
      tags: state.tags.split(', '),
      title: state.title.value,
      images: state.images
          .map(
            (image) =>
                image.replaceAll('${Environment.apiUrl}/files/product/', ''),
          )
          .toList(),
    );

    try {
      return await onSubmitt!(productLike);
    } catch (e) {
      return false;
    }
  }

  void _touchedEverything() {
    state = state.copyWith(
      isFormValid: Formz.validate([
        Title.dirty(state.title.value),
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onTitleChanged(String value) {
    final title = Title.dirty(value);
    state = state.copyWith(
      title: title,
      isFormValid: Formz.validate([
        title,
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onSlugChanged(String value) {
    final slug = Slug.dirty(value);
    state = state.copyWith(
      slug: slug,
      isFormValid: Formz.validate([
        slug,
        Title.dirty(state.title.value),
        Price.dirty(state.price.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onPriceChanged(double value) {
    final price = Price.dirty(value);
    state = state.copyWith(
      price: price,
      isFormValid: Formz.validate([
        price,
        Slug.dirty(state.slug.value),
        Title.dirty(state.title.value),
        Stock.dirty(state.inStock.value),
      ]),
    );
  }

  void onStockChanged(int value) {
    final stock = Stock.dirty(value);
    state = state.copyWith(
      inStock: stock,
      isFormValid: Formz.validate([
        stock,
        Slug.dirty(state.slug.value),
        Price.dirty(state.price.value),
        Title.dirty(state.title.value),
      ]),
    );
  }

  void onSizedChanged(List<String> value) {
    state = state.copyWith(
      sizes: value,
    );
  }

  void onGenderChanged(String gender) {
    state = state.copyWith(
      gender: gender,
    );
  }

  void onDescriptionChanged(String description) {
    state = state.copyWith(
      description: description,
    );
  }

  void onTagsChanged(String tags) {
    state = state.copyWith(
      tags: tags,
    );
  }
}

class ProductFormState {
  final bool isFormValid;
  final String? id;
  final Title title;
  final Slug slug;
  final Price price;
  final Stock inStock;
  final String tags;
  final List<String> sizes;
  final String gender;
  final String description;
  final List<String> images;

  ProductFormState({
    this.isFormValid = false,
    this.id,
    this.title = const Title.pure(),
    this.slug = const Slug.pure(),
    this.price = const Price.pure(),
    this.inStock = const Stock.pure(),
    this.tags = '',
    this.sizes = const [],
    this.gender = 'men',
    this.description = '',
    this.images = const [],
  });

  ProductFormState copyWith({
    bool? isFormValid,
    String? id,
    Title? title,
    Slug? slug,
    Price? price,
    Stock? inStock,
    String? tags,
    List<String>? sizes,
    String? gender,
    String? description,
    List<String>? images,
  }) =>
      ProductFormState(
        description: description ?? this.description,
        gender: gender ?? this.gender,
        id: id ?? this.id,
        images: images ?? this.images,
        inStock: inStock ?? this.inStock,
        isFormValid: isFormValid ?? this.isFormValid,
        price: price ?? this.price,
        sizes: sizes ?? this.sizes,
        slug: slug ?? this.slug,
        tags: tags ?? this.tags,
        title: title ?? this.title,
      );
}
