import 'package:flutter/material.dart';
import 'package:flutter_course/models/product.dart';
import 'package:flutter_course/scoped_models/mianModel.dart';
import 'package:scoped_model/scoped_model.dart';

//class ProductCreatePage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: Center(child: RaisedButton(onPressed: (){
//          showModalBottomSheet(context: context, builder: (BuildContext context){
//            return Center(child: Text("This is a Modal"),);
//          });
//      },child: Text("SAVE"),),),
//    );
//  }
//}

class ProductSavePage extends StatefulWidget {
  @override
  _ProductSavePageState createState() => _ProductSavePageState();
}

class _ProductSavePageState extends State<ProductSavePage> {
  String _titleValue = "";
  String _description = "";
  double _price = 0;
  final GlobalKey<FormState> _formkey = new GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Title"),
      initialValue: product == null ? "" : product.title,
      onSaved: (String value) {
        _titleValue = value;
      },
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty || value.length < 5) {
          return 'Title is required and should be 5+ characters long.';
        }
      },
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Description"),
      maxLines: 4,
      onSaved: (String value) {
        _description = value;
      },
      initialValue: product == null ? "" : product.description,
      // ignore: missing_return
      validator: (String value) {
        if (value.isEmpty || value.length < 10) {
          return 'Description is required and should be 10+ characters long.';
        }
      },
    );
  }

  Widget _buildAmountTextField(Product product) {
    return TextFormField(
      decoration: InputDecoration(labelText: "Price"),
      keyboardType: TextInputType.number,
      onSaved: (String value) {
        _price = double.parse(value);
      },
      initialValue: product == null ? "" : product.price.toString(),
      // ignore: missing_return
      validator: (String value) {
        // if (value.trim().length <= 0) {
        if (value.isEmpty ||
            !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
          return 'Price is required and should be a number.';
        }
      },
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return model.isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RaisedButton(
              child: Text(
                "SAVE",
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
              onPressed: () {
                saveProduct(model.addProduct, model.updateProduct,
                    model.setSelectedProduct, model.selectedProductIndex);
              },
            );
    });
  }

  void saveProduct(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) {
    if (!_formkey.currentState.validate()) {
      return;
    }

    _formkey.currentState.save();
    //final  Product product = new Product(title: _titleValue, description: _description,image: 'images/food.png', price: _price);

    if (selectedProductIndex == -1) {
      addProduct(_titleValue, _description, 'images/food.png', _price)
          .then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Something went wrong"),
                  content: Text("Please Try again"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Okay"),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                );
              });
        }
      });
    } else {
      updateProduct(_titleValue, _description, 'images/food.png', _price).then(
          (_) => Navigator.pushReplacementNamed(context, '/products')
              .then((_) => setSelectedProduct(null)));
    }
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(20.0),
        child: Form(
          key: _formkey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildAmountTextField(product),
              SizedBox(
                height: 10.0,
              ),
              //  LocationInput(),
              SizedBox(
                height: 10.0,
              ),
              _buildSubmitButton()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == -1
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text("Edit Product"),
                  centerTitle: true,
                ),
                body: pageContent,
              );
      },
    );
  }
}
