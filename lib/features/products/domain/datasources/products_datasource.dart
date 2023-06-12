import 'package:teslo_shop/features/products/domain/entities/entities.dart';

abstract class ProductsDataSource {
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0});
  Future<Product> getProductById(String id);

  Future<List<Product>> searchProductsByTerm(String term);
  Future<Product> createProduct(Map<String, dynamic> productLike);
}
