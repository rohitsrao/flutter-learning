import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/products.dart';
import '../screens/cart_screen.dart';
import '../widgets/badge.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen>{

  bool _showOnlyFavorites = false;
  bool _isInit = false;
  bool _isLoading = false;

  @override
  void initState() {
    //Future.delayed(Duration.zero)
    //  .then(() {
    //    Provider.of<context>.fetchAndSetProducts();
    //  });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
        .fetchAndSetProducts()
        .then((_) {
          setState(() {
            _isLoading = false;
          });
        });
    }
    _isInit = true;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context){
    return (
      Scaffold(
        appBar: AppBar(
          title: Text('My Shop'),
          actions: <Widget>[
            Consumer<Cart>(
              builder: (_, cart, child) => Badge(
                  child: child==null ? Text('No Child') : child,
                  value: cart.itemCount.toString(),
              ),
              child: IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CartScreen.routeName,
                  );
                },
              ),
            ),
            PopupMenuButton(
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(child: Text('Only Favorites'), value: FilterOptions.Favorites),
                PopupMenuItem(child: Text('Show All'), value: FilterOptions.All),
              ],
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  }
                  else {
                    _showOnlyFavorites = false;
                  }
                });
              },
            ),
          ],
        ),
        drawer: AppDrawer(),
        body: _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ProductsGrid(_showOnlyFavorites),
      )
    );
  }
}
