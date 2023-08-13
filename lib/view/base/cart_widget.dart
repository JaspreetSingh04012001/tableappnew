import 'package:efood_table_booking/controller/cart_controller.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CartWidget extends StatelessWidget {
  final Color color;
  final double size;
  const CartWidget({super.key, required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Stack(clipBehavior: Clip.none, children: [
      Icon(
        Icons.shopping_cart,
        size: size,
        color: color,
      ),
      GetBuilder<CartController>(builder: (cartController) {
        return cartController.cartList.isNotEmpty
            ? Positioned(
                top: -5,
                right: -5,
                child: Container(
                  height: size < 20 ? 10 : size / 1.5,
                  width: size < 20 ? 10 : size / 1.5,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                    border: Border.all(
                        width: size < 20 ? 0.7 : 1,
                        color: Theme.of(context).cardColor),
                  ),
                  child: Text(
                    overflow: TextOverflow.ellipsis,
                    '${cartController.cartList.length}',
            
                    style: robotoRegular.copyWith(
                      fontSize: size / 2.8,
                      color: Colors.black,
                    ),
                  ),
                ),
              )
            : const SizedBox();
      }),
    ]);
  }
}
