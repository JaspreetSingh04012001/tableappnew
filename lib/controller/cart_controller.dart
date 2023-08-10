import 'package:efood_table_booking/data/model/response/cart_model.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/data/repository/cart_repo.dart';
import 'package:get/get.dart';

class CartController extends GetxController implements GetxService {
  final CartRepo cartRepo;
  CartController({required this.cartRepo});

  List<CartModel> _cartList = [];
  double _amount = 0.0;
  final bool _isCartUpdate = false;
  int? _peopleNumber;
  double _totalAmount = 0.0;
  String? _customerName ;






  List<CartModel> get cartList => _cartList;
  double get amount => _amount;
  double get totalAmount => _totalAmount;
  bool get isCartUpdate => _isCartUpdate;
  int? get peopleNumber => _peopleNumber;
  String? get customerName => _customerName;

  set setPeopleNumber(int value) {
    _peopleNumber = value;
  }
  set setCustomerName(String value) {
    _customerName = value;
  }


  set setTotalAmount(double value) {
    _totalAmount = value;
  }

  void getCartData() {
    _cartList = [];
    _cartList.addAll(cartRepo.getCartList());
    for (var cart in _cartList) {
      _amount = _amount + (cart.discountedPrice! * cart.quantity!);
    }
  }

  int getCartIndex (Product product) {
    for(int index = 0; index < _cartList.length; index ++) {
      if(_cartList[index].product?.id == product.id ) {
        if( _cartList[index].product?.variations != null &&
            cartList[index].product!.variations!.isNotEmpty &&
            _cartList[index].product!.variations![0].isMultiSelect  != null){
          if(_cartList[index].product!.variations![0].isMultiSelect == product.variations![0].isMultiSelect){
            return index;
          }
        }
        else{
          return index;
        }

      }
    }
    return -1;
  }

  int getCartQty(Product product){
    int count = 0;
    for(int i= 0; i < _cartList.length; i++){
      if(product.id == _cartList[i].product?.id){
        count+=_cartList[i].quantity!;
      }
    }
    return count;
  }







  void addToCart(CartModel cartModel, int index) {
    if(index != -1) {
      _cartList.replaceRange(index, index + 1, [cartModel]);

    }else {
      _cartList.add(cartModel);
    }
    cartRepo.addToCartList(_cartList);

    update();
  }

  void removeFromCart(int index) {
    _amount = _amount - (_cartList[index].discountedPrice! * _cartList[index].quantity!);
    _cartList.removeAt(index);
    cartRepo.addToCartList(_cartList);
    update();
  }

  void clearCartData() {
    _cartList = [];
    cartRepo.clearCartData();
    update();

  }







}
