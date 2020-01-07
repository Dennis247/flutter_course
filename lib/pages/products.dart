import 'package:flutter/material.dart';
import 'package:flutter_course/scoped_models/mianModel.dart';
import 'package:flutter_course/widgets/products/products.dart';
import 'package:flutter_course/widgets/ui_elemets/logout_list_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsPage extends StatefulWidget {
  final MainModel model;
  ProductsPage(this.model);
  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  void initState() {
    widget.model.fetchProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Select Item'),
              ),
              ListTile(
                leading: Icon(Icons.edit),
                title: Text("Manage Product"),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/admin');
                },
              ),
              Divider(),
              LogoutListTile()
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Products"),
          centerTitle: true,
          actions: <Widget>[
            ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                  icon: Icon(
                    model.displayFavouriteOnly
                        ? Icons.favorite
                        : Icons.favorite_border,
                  ),
                  color: Colors.white,
                  onPressed: () {
                    model.toogleShowFavourites();
                  });
            })
          ],
        ),
        body: _buildProductList());
  }

  Widget _buildProductList() {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        Widget content = Center(
          child: Text("No Products Found!"),
        );
        if (model.getDisplayedProducts().length > 0 && !model.isLoading) {
          {
            content = Products();
          }
        } else if (model.isLoading) {
          content = Center(
            child: CircularProgressIndicator(),
          );
        }
        return RefreshIndicator(
          child: content,
          onRefresh: model.fetchProduct,
        );
      },
    );
  }
}
