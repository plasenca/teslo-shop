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
}
