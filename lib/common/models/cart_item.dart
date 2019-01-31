import 'package:statepro/common/models/product.dart';

/// A single line in the cart.
class CartItem {
  final int count;
  final Product product;

  const CartItem(this.count, this.product);

  @override
  String toString() => "${product.name} ✕ $count";
}
