import 'package:carousel_slider/carousel_slider.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/config_model.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/view/base/custom_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSlider extends StatelessWidget {
  final List<BranchPromotion> branchPromotionList;
  const CustomSlider({Key? key, required this.branchPromotionList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5))),
      height: Get.height,
      width: Get.width,
      child: CarouselSlider.builder(
        options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          disableCenter: true,
          viewportFraction: 1,
          autoPlayInterval: const Duration(seconds: 7),
          // onPageChanged: (index, reason) {
          //   bannerController.setCurrentIndex(index, true);
          // },
        ),
        itemCount: branchPromotionList.length,
        itemBuilder: (context, index, _) {
          String image = '';
          try{
            image = '${Get.find<SplashController>().configModel?.baseUrls?.promotionalUrl}/';
            if(branchPromotionList.isNotEmpty) {
              image =  '$image${branchPromotionList[index].promotionName ?? ''}';
            }
          }catch(e){
            debugPrint('custom slider $e');
          }
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              boxShadow: [BoxShadow(color: Theme.of(context).cardColor, spreadRadius: 1, blurRadius: 5)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
              child: GetBuilder<SplashController>(builder: (splashController) {
                return CustomImage(
                  fit: BoxFit.cover,
                  image: image,
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
