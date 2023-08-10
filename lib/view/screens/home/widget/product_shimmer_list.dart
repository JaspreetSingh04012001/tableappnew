import 'package:efood_table_booking/helper/responsive_helper.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmerList extends StatelessWidget {
  const ProductShimmerList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isBig = (Get.height / Get.width) > 1 && (Get.height / Get.width) < 1.7;
    return IgnorePointer(
      child: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        itemCount: 12,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ResponsiveHelper.isTab(context) || isBig ? 3 : 2,
          crossAxisSpacing: Dimensions.paddingSizeDefault,
          mainAxisSpacing: Dimensions.paddingSizeDefault,
        ),

        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Theme.of(context).shadowColor,
            period: const Duration(seconds: 3),
            highlightColor: Colors.grey[100]!,
            child: Stack(
              children: [
                Column(children: [

                  const SizedBox(height: 5),

                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(width: 100,height: 20, color: Colors.red),
                    ),
                  ),

                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                      child: Stack(
                        children: [
                          Stack(
                            children: const [
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: CustomImage(
                                  height: double.infinity, width: double.infinity,
                                  image: '',
                                  fit: BoxFit.cover,
                                ),
                              ),

                            ],
                          ),


                        ],
                      ),
                    ),
                  ),



                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
