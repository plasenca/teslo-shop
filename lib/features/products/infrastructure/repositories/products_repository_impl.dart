import 'package:teslo_shop/features/products/domain/domain.dart'
    show Product, ProductsRepository, ProductsDataSource;

class ProductsRepositoryImpl extends ProductsRepository {
  final ProductsDataSource dataSource;

  ProductsRepositoryImpl(this.dataSource);

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) {
    return dataSource.createProduct(productLike);
  }

  @override
  Future<Product> getProductById(String id) {
    return dataSource.getProductById(id);
  }

  @override
  Future<List<Product>> getProductsByPage({int limit = 10, int offset = 0}) {
    return dataSource.getProductsByPage(limit: limit, offset: offset);
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    return dataSource.searchProductsByTerm(term);
  }
}
