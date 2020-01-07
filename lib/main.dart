import 'package:flutter/material.dart';
import 'package:flutter_course/pages/auth.dart';
import 'package:flutter_course/pages/productpage.dart';
import 'package:flutter_course/pages/products.dart';
import 'package:flutter_course/scoped_models/mianModel.dart';

import 'package:scoped_model/scoped_model.dart';
import './pages/product_admin_page.dart';
import 'models/product.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  MainModel _model = new MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    // TODO: implement initState
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel(
      model: _model,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.deepPurple,
          brightness: Brightness.light,
          buttonColor: Colors.deepPurple,
        ),

        // home:AuthPage(),
        routes: {
          '/': (BuildContext context) => ScopedModelDescendant(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return _isAuthenticated ? ProductsPage(_model) : AuthPage();
                },
              ),
          '/admin': (BuildContext context) =>
              _isAuthenticated ? ProductsAdminPage(_model) : AuthPage(),
        },
        // ignore: missing_return
        onGenerateRoute: (RouteSettings settings) {
          if (!_isAuthenticated) {
            return MaterialPageRoute<bool>(
              builder: (BuildContext context) => AuthPage(),
            );
          }

          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1] == 'product') {
            // final int index = int.parse(pathElements[2]);
            final String productId = pathElements[2];
            final Product product =
                _model.allProducts.firstWhere((Product product) {
              return product.id == productId;
            });
            _model.setSelectedProduct(productId);
            return MaterialPageRoute<bool>(
//              builder: (BuildContext context)=> ProductPage(index)
              builder: (BuildContext context) =>
                  _isAuthenticated ? ProductPage(product) : AuthPage(),
            );
          }
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) => ProductsPage(_model),
          );
        },
      ),
    );
  }
}
