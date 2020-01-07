import 'package:flutter_course/models/auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

mixin ConnectedProductsModel on Model {
  List<Product> _products = [];
  User _authenticatedUser;
  final String url = "https://flutter-course-91b23.firebaseio.com/";
  final String apiKey = "AIzaSyDhZQ6CkZ44gYiOQAWiOCM3btyQksUNJDA";
  final String productlink =
      "https://flutter-course-91b23.firebaseio.com/products/";
  //int  _currentSelectedProductIndex;
  String _currentSelectedProductId;
  bool _isLoading = false;
}

mixin ProductModel on ConnectedProductsModel {
  // List<Product> _products =[];
  bool _showFavourites = false;
  List<Product> get allProducts {
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products.indexWhere((Product product) {
      return product.id == _currentSelectedProductId;
    });
  }

  Future<Null> fetchProduct({onlyForUser = false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(url + 'products.json?auth=${_authenticatedUser.token}')
        .then<Null>((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      final List<Product> fetchedProductlist = [];
      Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId'],
            isFavourite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id));

        fetchedProductlist.add(product);
      });
      _products = onlyForUser
          ? fetchedProductlist.where((Product product) {
              return product.userId == _authenticatedUser.id;
            }).toList()
          : fetchedProductlist;
      _isLoading = false;
      notifyListeners();
      _currentSelectedProductId = null;
      return;
    }).catchError((error) {
      {
        _isLoading = false;
        notifyListeners();
        return;
      }
    });
  }

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> product = {
      'title': title,
      'description': description,
      'image':
          'https://www.klondikebar.com/wp-content/uploads/sites/49/2018/03/choco-taco-ice-cream.png',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response response = await http.post(
          url + 'products.json?auth=${_authenticatedUser.token}',
          body: json.encode(product));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateDaa = {
      'title': title,
      'description': description,
      'image':
          'https://www.klondikebar.com/wp-content/uploads/sites/49/2018/03/choco-taco-ice-cream.png',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };

    try {
      final http.Response response = await http.put(
          url +
              'products/' +
              selectedProduct.id +
              '.json?auth=${_authenticatedUser.token}',
          body: json.encode(updateDaa));
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      _isLoading = false;
      final Product updatedProduct = new Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    final String deletedProductId = selectedProduct.id;
    _products.removeAt(selectedProductIndex);
    _currentSelectedProductId = null;
    //  notifyListeners();
    return http
        .delete(url +
            'products/$deletedProductId.json?auth=${_authenticatedUser.token}')
        .then((http.Response response) {
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    });
  }

//  void setSelectedProduct(int index){
//    _currentSelectedProductIndex = index;
//    notifyListeners();
//  }

  void setSelectedProduct(String productId) {
    _currentSelectedProductId = productId;
    notifyListeners();
  }

  String get selectedProductId {
    return _currentSelectedProductId;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products.firstWhere((Product product) {
      return product.id == _currentSelectedProductId;
    });
  }

  void toogleIsProductFavourite() async {
    final bool isCurrentlyFavourite = selectedProduct.isFavourite;
    final bool newfavouriteStatus = !isCurrentlyFavourite;
    http.Response response;

    final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        isFavourite: newfavouriteStatus,
        userId: selectedProduct.userId,
        userEmail: selectedProduct.userEmail);

    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();

    if (newfavouriteStatus) {
      response = await http.put(
          productlink +
              "${selectedProduct.id}/wishListusers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}",
          body: jsonEncode(true));
    } else {
      response = await http.delete(productlink +
          "${selectedProduct.id}/wishListusers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}");
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: selectedProduct.title,
          description: selectedProduct.description,
          price: selectedProduct.price,
          image: selectedProduct.image,
          isFavourite: !newfavouriteStatus,
          userId: selectedProduct.userId,
          userEmail: selectedProduct.userEmail);

      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void toogleShowFavourites() {
    _showFavourites = !_showFavourites;
    notifyListeners();
  }

  List<Product> getDisplayedProducts() {
    if (_showFavourites) {
      return _products.where((Product product) => product.isFavourite).toList();
    }
    return List.from(_products);
  }

  bool get displayFavouriteOnly {
    return _showFavourites;
  }
}

mixin UserModel on ConnectedProductsModel {
  PublishSubject<bool> _userSubject = PublishSubject();
  Timer _authTimer;

  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$apiKey",
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    } else {
      response = await http.post(
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$apiKey",
        body: json.encode(authData),
        headers: {'Content-Type': 'application/json'},
      );
    }

    // ignore: unused_local_variable
    String message = "Something went wrong";
    // ignore: unused_local_variable
    bool hasError = true;
    final Map<String, dynamic> responseData = json.decode(response.body);
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = "Authentication Succceeded";
      _authenticatedUser = new User(
          id: responseData["localId"],
          email: email,
          token: responseData["idToken"]);
      //emit event that user has been authenticate
      _userSubject.add(true);
      setAuthTimeOut(int.parse(responseData['expiresIn']));
      final DateTime now = DateTime.now();
      final expiryTime =
          now.add(Duration(seconds: int.parse(responseData["expiresIn"])));
      _userSubject.add(true);
      final SharedPreferences preferences =
          await SharedPreferences.getInstance();
      preferences.setString('token', responseData['idToken']);
      preferences.setString('userEmail', email);
      preferences.setString('userId', responseData['localId']);
      preferences.setString('expiryTime', expiryTime.toIso8601String());
    } else if (responseData['error']['message'] == "EMAIL_NOT_FOUND") {
      message = "Email Not Found";
      hasError = true;
    } else if (responseData['error']['message'] == "INVALID_PASSWORD") {
      message = "Password is not Valid";
      hasError = true;
    } else if (responseData['error']['message'] == "EMAIL_EXISTS") {
      message = "The email already exists";
      hasError = true;
    }
    _isLoading = false;
    notifyListeners();
    return {'sucess': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    final String token = preferences.get('token');
    final String expiryTimeString = preferences.get('expiryTime');
    final expiryTime = DateTime.parse(expiryTimeString);
    if (token != null) {
      final DateTime now = DateTime.now();
      if (expiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
      }
      final String userEmail = preferences.getString('userEmail');
      final String userId = preferences.getString('userId');
      final int tokenLifeSpan = expiryTime.difference(now).inSeconds;
      _authenticatedUser = new User(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeOut(tokenLifeSpan);
      notifyListeners();
    }
  }

  void logOut() async {
    print("i am  logging out");
    _authenticatedUser = null;
    _authTimer.cancel();
    final SharedPreferences preference = await SharedPreferences.getInstance();
    preference.remove('token');
    preference.remove('userEmail');
    preference.remove('userId');

    //This shows a user has logged out
    _userSubject.add(false);
  }

  void setAuthTimeOut(int time) async {
    _authTimer = Timer(Duration(seconds: time), () {
      logOut();
    });
  }
}

mixin UtiltyModel on ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
