import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/widgets/ui_elemets/title_default.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  ProductPage(this.product);

//  _showWarningDialog(BuildContext context){
//    showDialog(context: context,builder: (BuildContext context){
//      return AlertDialog(
//        title: Text("Are You Sure You Want To delete"),
//        content: Text("This ACTION cannot be undone!"),
//        actions: <Widget>[
//          FlatButton(child: Text("DELETE"),onPressed: (){
//            Navigator.pop(context);
//            Navigator.pop(context,true);
//          },),
//          FlatButton (child: Text("CANCEL") ,onPressed: (){
//            Navigator.pop(context);
//          },)
//        ],
//      );
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(product.title),
            centerTitle: true,
          ),
          body: Center(
              child: Column(
            children: <Widget>[
              FadeInImage(
                image: NetworkImage(product.image),
                placeholder: AssetImage('images/background.jpg'),
                height: 300,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TitleDefault(product.title),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Union Square, San Francisco',
                    style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(
                      '|',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    '\$' + product.price.toString(),
                    style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  product.description,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          )),
        ));
  }
}
