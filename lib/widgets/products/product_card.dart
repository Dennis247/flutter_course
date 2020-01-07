import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped_models/mianModel.dart';
import 'package:flutter_course/widgets/products/price_tag.dart';
import 'package:flutter_course/widgets/ui_elemets/title_default.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductCard extends StatelessWidget {

  final Product product;
  final int index;

  ProductCard(this.product,this.index);

  @override
  Widget build(BuildContext context) {
    return Card(child: Column(
      children: <Widget>[
        FadeInImage(image: NetworkImage(product.image),
          placeholder:AssetImage('images/background.jpg'),
        height: 300,
        fit: BoxFit.cover,),
        SizedBox(height: 10.0),
        Row( mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
          TitleDefault(product.title),
          SizedBox(width: 5.0),
          PriceTag(product.price)
        ],),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.5,vertical: 4.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Text("Dennis International High"),
        ),
        Text(product.userEmail),
    _buildActionButtons(context),
      ],
    ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.info),
                color: Theme.of(context).accentColor,
                onPressed: () => Navigator
                    .pushNamed<bool>(context,
                    '/product/' + model.allProducts[index].id),
              ),
              IconButton(
                icon: Icon(model.allProducts[index].isFavourite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Colors.red,
                onPressed: () {
                  model.setSelectedProduct(model.allProducts[index].id);
                  model.toogleIsProductFavourite();
                },
              ),
            ]);
      },
    );
  }

}
