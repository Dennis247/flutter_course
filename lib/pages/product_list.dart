import 'package:flutter/material.dart';
import 'package:flutter_course/pages/product_save.dart';
import 'package:flutter_course/scoped_models/mianModel.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListpage extends StatefulWidget {
  final MainModel model;
  ProductListpage(this.model);
  @override
  _ProductListpageState createState() => _ProductListpageState();
}

class _ProductListpageState extends State<ProductListpage> {
  @override
  initState() {
    widget.model.fetchProduct(onlyForUser: true);
    super.initState();
  }

  Widget buildEditIcon(BuildContext context, int index, MainModel model) {
    return IconButton(
        icon: Icon(Icons.edit),
        onPressed: () {
          model.setSelectedProduct(model.allProducts[index].id);
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (BuildContext context) {
            return ProductSavePage();
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.setSelectedProduct(model.allProducts[index].id);
                  model.deleteProduct();
                } else if (direction == DismissDirection.startToEnd) {
                } else {}
              },
              key: Key(model.allProducts[index].title),
              background: Container(
                color: Colors.red,
              ),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(model.allProducts[index].image),
                    ),
                    title: Text(model.allProducts[index].title),
                    subtitle:
                        Text("\$${model.allProducts[index].price.toString()}"),
                    trailing: buildEditIcon(context, index, model),
                  ),
                  Divider()
                ],
              ),
            );
          },
          itemCount: model.allProducts.length,
        );
      },
    );
  }
}
