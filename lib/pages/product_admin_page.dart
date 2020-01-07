import 'package:flutter/material.dart';
import './product_save.dart';
import './product_list.dart';
import '../scoped_models/mianModel.dart';

class ProductsAdminPage extends StatelessWidget {
  final MainModel model;
  ProductsAdminPage(this.model);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: Column(
            children: <Widget>[
              AppBar(
                automaticallyImplyLeading: false,
                title: Text('Choose'),
              ),
              ListTile(
                leading: Icon(Icons.shop),
                title: Text('All Products'),
                onTap: () {
                  Navigator.pushReplacementNamed(context, "/");
                },
              )
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('Manage Products'),
          bottom: TabBar(tabs: <Widget>[
            Tab(
              text: "Manage Product",
              icon: Icon(Icons.edit),
            ),
            Tab(text: "My Products", icon: Icon(Icons.list))
          ]),
        ),
        body: TabBarView(
          children: <Widget>[ProductSavePage(), ProductListpage(model)],
        ),
      ),
    );
  }
}
