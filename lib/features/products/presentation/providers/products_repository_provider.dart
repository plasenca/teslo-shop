import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:teslo_shop/features/products/products.dart';
import 'package:teslo_shop/features/auth/presentation/providers/providers.dart';

final productsRepositoryProvider = Provider<ProductsRepository>((ref) {
  final accessToken = ref.watch(authProvider).user?.token ?? '';

  final dataSource = ProductsDatasourceImpl(accessToken: accessToken);

  final productsRepository = ProductsRepositoryImpl(dataSource);

  return productsRepository;
});
