import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_product_screen.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {

  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    print('entered _refreshProducts');
    await Provider.of<Products>(context, listen: false).fetchAndSetProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context){
    return (
      Scaffold(
        appBar: AppBar(
          title: const Text('Your Products'),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.add
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
            )
          ]
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: _refreshProducts(context),
          builder: (context, snapshot) => snapshot.connectionState == ConnectionState.waiting 
          ? Center(
              child: CircularProgressIndicator()
            )
          : RefreshIndicator(
              child: Consumer<Products>(
                builder: (ctx, productsData, _) => Padding(
                  padding: EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: productsData.items.length,
                    itemBuilder: (_, i) => Column(
                      children: <Widget>[
                        UserProductItem(
                          productsData.items[i].id,
                          productsData.items[i].title,
                          productsData.items[i].imageUrl,
                        ),
                        Divider()
                      ]
                    ),
                  ),
                ),
              ),
              onRefresh: () => _refreshProducts(context)
            ),
        ),
      )
    );
  }
}
