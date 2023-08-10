import 'package:efood_table_booking/view/base/custom_app_bar.dart';
import 'package:efood_table_booking/view/screens/cart/widget/cart_detais.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CartScreen extends StatefulWidget {
  final bool isOrderDetails;
  const CartScreen({Key? key, this.isOrderDetails = false}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);



    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(onBackPressed: null, showCart: false),
      body: CartDetails(showButton: !widget.isOrderDetails),
    );
  }
}
