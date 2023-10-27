import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/product.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/view/base/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ProductImageScreen extends StatefulWidget {
  final Product? product;
  const ProductImageScreen({Key? key, this.product}) : super(key: key);

  @override
  State<ProductImageScreen> createState() => _ProductImageScreenState();
}

class _ProductImageScreenState extends State<ProductImageScreen> {
  int? pageIndex;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    //NetworkInfo.checkConnectivity(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Center(
        child: SizedBox(
          width: 1170,
          child: Column(children: [
            Expanded(
              child: Stack(
                children: [
                  PhotoViewGallery.builder(
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage('${Get.find<SplashController>().configModel?.baseUrls!.productImageUrl}/${widget.product?.image}'),
                        initialScale: PhotoViewComputedScale.contained,
                      );
                    },
                    backgroundDecoration: BoxDecoration(color: Theme.of(context).cardColor),
                    itemCount: 1,
                    loadingBuilder: (context, event) => Center(
                      child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null ? 0 : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                          valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                    pageController: _pageController,
                    onPageChanged: (int index) {
                      setState(() {
                        pageIndex = index;
                      });
                    },
                  ),

                  // pageIndex != 0 ? Positioned(
                  //   left: 5, top: 0, bottom: 0,
                  //   child: Container(
                  //     alignment: Alignment.center,
                  //     decoration: const BoxDecoration(
                  //       color: Colors.grey,
                  //       shape: BoxShape.circle,
                  //     ),
                  //     child: InkWell(
                  //       onTap: () {
                  //         if(pageIndex! > 0) {
                  //           _pageController!.animateToPage(pageIndex!-1, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                  //         }
                  //       },
                  //       child: const Icon(Icons.chevron_left_outlined, size: 40),
                  //     ),
                  //   ),
                  // ) : const SizedBox.shrink(),

                ],
              ),
            ),

          ]),
        ),
      ),
    );
  }
}

