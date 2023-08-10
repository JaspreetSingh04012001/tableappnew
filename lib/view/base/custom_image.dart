import 'package:cached_network_image/cached_network_image.dart';
import 'package:efood_table_booking/util/images.dart';
import 'package:flutter/material.dart';


class CustomImage extends StatelessWidget {
  final String image;
  final double? height;
  final double? width;
  final BoxFit fit;
  final String placeholder;


  const CustomImage(
      {super.key,
      required this.image,
      this.height,
      this.width,
      this.fit = BoxFit.cover,
      this.placeholder = Images.placeholderImage});

  @override
  Widget build(BuildContext context) {
    // final cacheManager = DefaultCacheManager();

    return CachedNetworkImage(
//cacheManager: cacheManager,
      // progressIndicatorBuilder: (context, url, downloadProgress) {
      //   return LinearProgressIndicator(value: downloadProgress.progress);
      // },
      imageUrl: image,
      height: height,
      width: width,
      fit: fit,
      placeholder: (context, url) => Image.asset(
        placeholder,
        height: height,
        width: width,
        fit: fit,
        filterQuality: FilterQuality.low,
      ),
      errorWidget: (context, url, error) => Image.asset(
        placeholder,
        height: height,
        width: width,
        fit: fit,
        filterQuality: FilterQuality.low,
      ),
    );

    //  FadeInImage.assetNetwork(

    //   image: image, height: height, width: width, fit: fit,
    //   placeholder: placeholder,

    //   imageErrorBuilder: (context, url, error) =>
    //   Image.asset(placeholder, height: height, width: width, fit: fit, filterQuality: FilterQuality.low,),

    // );
  }
}
