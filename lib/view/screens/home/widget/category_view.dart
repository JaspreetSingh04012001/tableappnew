import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../controller/splash_controller.dart';
import '../../../../helper/responsive_helper.dart';
import '../../../../util/images.dart';
import '../../../base/custom_image.dart';

class CategoryView extends StatelessWidget {
  final Function(String id) onSelected;

  const CategoryView({super.key, required this.onSelected});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (category) {
        return category.categoryList == null
            ? const CategoryShimmer()
            : category.categoryList!.isNotEmpty
                ? ListView.builder(
                    itemCount: category.categoryList?.length,
                    padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall),
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      String name = '';
                      category.categoryList![index].name.length > 15
                          ? name =
                              '${category.categoryList![index].name.substring(0, 15)} ...'
                          : name = category.categoryList![index].name;

                      return Container(
                        decoration: category.selectedCategory ==
                                category.categoryList![index].id.toString()
                            ? BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.2),
                              )
                            : const BoxDecoration(),

                        // padding: EdgeInsets.all(
                        //   category.selectedCategory == category.categoryList![index].id.toString() ? Dimensions.PADDING_SIZE_EXTRA_SMALL : 0,
                        // ),
                        child: Container(
                          alignment: Alignment.center,
                          width: 90,
                          margin: EdgeInsets.only(
                            right: Dimensions.paddingSizeSmall,
                            top: Dimensions.paddingSizeSmall,
                            //   bottom: Dimensions.paddingSizeSmall,
                            //left: category.selectedCategory == category.categoryList![index].id.toString() ? Dimensions.PADDING_SIZE_SMALL : 0,
                            left: Dimensions.paddingSizeSmall,
                          ),
                          child: InkWell(
                            onTap: () => onSelected(
                                category.categoryList![index].id.toString()),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  category.CatImage
                                      ? ClipOval(
                                          child: CustomImage(
                                          height: ResponsiveHelper.isSmallTab()
                                              ? 45
                                              : ResponsiveHelper.isTab(context)
                                                  ? 65
                                                  : 55,
                                          width: ResponsiveHelper.isSmallTab()
                                              ? 45
                                              : ResponsiveHelper.isTab(context)
                                                  ? 65
                                                  : 55,
                                          image:
                                              '${Get.find<SplashController>().configModel?.baseUrls?.categoryImageUrl}/${category.categoryList![index].image}',
                                          placeholder: Images.placeholderImage,
                                        ))
                                      : Container(),
                                  Text(
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                    name,
                                    style: robotoRegular.copyWith(
                                        fontSize: Dimensions.fontSizeLarge),
                                    maxLines: 1,
                                    //    overflow: TextOverflow.ellipsis,
                                  ),
                                ]),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox();
      },
    );
  }
}

class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      child: ListView.builder(
        itemCount: 14,
        padding: EdgeInsets.only(left: Dimensions.paddingSizeSmall),
        physics: const BouncingScrollPhysics(),
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey[200]!,
            period: const Duration(seconds: 3),
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 20,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                //  shape: BoxShape.circle,
              ),
            ),
          );
        },
      ),
    );
  }
}

class CategoryAllShimmer extends StatelessWidget {
  const CategoryAllShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Padding(
        padding: EdgeInsets.only(right: Dimensions.paddingSizeSmall),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[200]!,
          period: const Duration(seconds: 3),
          highlightColor: Colors.grey[100]!,
          child: Column(children: [
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 5),
            Container(height: 10, width: 50, color: Colors.grey[300]),
          ]),
        ),
      ),
    );
  }
}
