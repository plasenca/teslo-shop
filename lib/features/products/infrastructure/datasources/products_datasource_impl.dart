import 'package:dio/dio.dart';
import 'package:teslo_shop/config/config.dart';
import 'package:teslo_shop/features/products/products.dart'
    show Product, ProductsDataSource, ProductNotFound, ProductMapper;

class ProductsDatasourceImpl extends ProductsDataSource {
  late final Dio dio;
  final String accessToken;

  ProductsDatasourceImpl({
    required this.accessToken,
  }) : dio = Dio(
          BaseOptions(
            baseUrl: Environment.apiUrl,
            headers: {
              'Authorization': 'Bearer $accessToken',
            },
          ),
        );

  @override
  Future<Product> createProduct(Map<String, dynamic> productLike) {
    // TODO: implement createProduct
    throw UnimplementedError();
  }

  @override
  Future<Product> getProductById(String id) async {
    try {
      final response = await dio.get<Map<String, dynamic>>('/products/$id');
      final products = ProductMapper.fromJson(response.data ?? {});

      return products;
    } on DioError catch (e) {
      if (e.response?.statusCode == 404) throw ProductNotFound();
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Product>> getProductsByPage(
      {int limit = 10, int offset = 0}) async {
    final response = await dio.get<List>('/products', queryParameters: {
      'limit': limit,
      'offset': offset,
    });

    final List rawProducts = response.data ?? [];

    final products = rawProducts
        .map((rawProduct) => ProductMapper.fromJson(rawProduct))
        .toList();

    return products;
  }

  @override
  Future<List<Product>> searchProductsByTerm(String term) {
    // TODO: implement searchProductsByTerm
    throw UnimplementedError();
  }
}
