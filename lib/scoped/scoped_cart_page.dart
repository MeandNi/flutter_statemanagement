import 'package:flutter/material.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:statepro/common/widgets/cart_page.dart';
import 'package:statepro/scoped/model.dart';

class CartPage extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: ScopedModelDescendant<CartModel>(builder: (context, _, model) {
        if (model == null || model.items.isEmpty) {
          return Center(
            child: Text('Empty', style: Theme.of(context).textTheme.display1),
          );
        }
        return ListView(
            children: model.items.map((item) => ItemTile(item: item)).toList());
      }),
    );
  }
}
