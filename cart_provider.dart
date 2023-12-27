import 'package:cart/db_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_model.dart';

class CartProvider with ChangeNotifier{
  DBHelper db = DBHelper();
  int _counter = 0;
  int get counter =>_counter;


  double _totalPrice = 0.0;
  double get totalPrice=> _totalPrice ;

  late Future<List<Cart>> _cart;
  Future<List<Cart>> get cart=> _cart;
  Future<List<Cart>> getData()async{
 _cart = db.getCartList();
 return _cart;
  }

  void _setPrefItem()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_Item', _counter);
    prefs.setDouble('total_Price',_totalPrice);
    notifyListeners();
  }
  void _getPrefItem()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_Item')??0;
    _totalPrice = prefs.getDouble('total_Price')??0.0;

    notifyListeners();
  }
  void addCounter(){
    _counter++;
    _setPrefItem();
    notifyListeners();
  }
  void removeCounter(){
    _counter--;
    _setPrefItem();
    notifyListeners();
  }
  int getCounter(){
    _getPrefItem();
    return _counter--;
  }

  void addTotalPrice(double productPrice){
    _totalPrice = _totalPrice + productPrice;
    _setPrefItem();
    notifyListeners();
  }
  void removeTotalPrice(double productPrice){
    _totalPrice = _totalPrice - productPrice;
    _setPrefItem();
    notifyListeners();
  }
  double getTotalPrice(){
    _getPrefItem();
    return _totalPrice;
  }
}