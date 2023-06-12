import 'package:teslo_shop/config/config.dart' show Environment;
import 'package:teslo_shop/features/products/domain/domain.dart' show Product;
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart'
    show UserMapper;

class ProductMapper {
  static Product fromJson(Map<String, dynamic> json) => Product(
        id: json['id'],
        title: json['title'],
        price: double.tryParse(json['price'].toString()) ?? -1.0,
        description: json['description'],
        slug: json['slug'],
        stock: json['stock'],
        sizes: List<String>.from(json['sizes'].map((size) => size)),
        gender: json['gender'],
        tags: List<String>.from(json['tags'].map((size) => size)),
        images: List<String>.from(
          json['images'].map(
            (image) => image.startsWith('http')
                ? image
                : '${Environment.apiUrl}/files/product/$image',
          ),
        ),
        user: UserMapper.userJsonToEntity(json['user']),
      );

  static Map<String, dynamic> toJsonWithEntity({
    required Product product,
  }) =>
      {
        "id": product.id,
        "title": product.title,
        "price": product.price,
        "description": product.description,
        "slug": product.slug,
        "stock": product.stock,
        "sizes": product.sizes,
        "gender": product.gender,
        "tags": product.tags,
        "images": product.images,
      };
  static Map<String, dynamic> toJsonWithRaw({
    required String? id,
    required String title,
    required double price,
    required String description,
    required String slug,
    required int stock,
    required List<String> sizes,
    required String gender,
    required List<String> tags,
    required List<String> images,
  }) =>
      {
        "id": id,
        "title": title,
        "price": price,
        "description": description,
        "slug": slug,
        "stock": stock,
        "sizes": sizes,
        "gender": gender,
        "tags": tags,
        "images": images,
      };
}
