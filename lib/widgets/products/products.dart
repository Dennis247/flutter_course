import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped_models/mianModel.dart';
import 'package:flutter_course/widgets/products/product_card.dart';
import 'package:scoped_model/scoped_model.dart';





class Products extends StatelessWidget {

  Widget _buildProductList( List<Product> products){
    Widget productCards = Center(child: Text("There are currently no produts in the list"),);
    if(products.length > 0){
      productCards = ListView.builder(
        itemBuilder: (BuildContext context,int index)=>ProductCard(products[index],index),
        itemCount: products.length,
      );
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(builder: (context,child, model){
         return  _buildProductList(model.getDisplayedProducts());
    },) ;
  }



}
