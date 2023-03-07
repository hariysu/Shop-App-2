import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cart';

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15.0),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Spacer(),
                  Chip(
                      label: Text(
                        '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .titleMedium
                                .color),
                      ),
                      backgroundColor: Colors.purple),
                  TextButton(
                      onPressed: (cart.totalAmount <= 0 || _isLoading)
                          ? null
                          : () async {
                              setState(() {
                                _isLoading = true;
                              });
                              await Provider.of<Orders>(context, listen: false)
                                  .addOrder(cart.items.values.toList(),
                                      cart.totalAmount);
                              setState(() {
                                _isLoading = false;
                              });
                              cart.clear();
                            },
                      child: _isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              'ORDER NOW',
                              style: TextStyle(color: Colors.purple),
                            ))
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (ctx, i) {
                return CartItem(
                    id: cart.items.values.toList()[i].id,
                    productId: cart.items.keys.toList()[i],
                    price: cart.items.values.toList()[i].price,
                    quantity: cart.items.values.toList()[i].quantity,
                    title: cart.items.values.toList()[i].title);
              },
            ),
          )
        ],
      ),
    );
  }
}
