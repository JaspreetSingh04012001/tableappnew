import 'package:efood_table_booking/controller/product_controller.dart';
import 'package:efood_table_booking/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../helper/responsive_helper.dart';
import '../../util/styles.dart';
import 'custom_button.dart';

class AskViewDialog extends StatefulWidget {
  const AskViewDialog({Key? key}) : super(key: key);

  @override
  _AskViewDialogState createState() => _AskViewDialogState();
}

class _AskViewDialogState extends State<AskViewDialog> {
  late bool image;
  late bool CatImage;
  late bool listView;
  late bool gridView;
  late List x;
  @override
  void initState() {
    image = Get.find<ProductController>().image;
    CatImage = Get.find<ProductController>().CatImage;
    listView = Get.find<ProductController>().listView;
    gridView = Get.find<ProductController>().gridView;
    x = [listView, gridView];
    // TODO: implement grid view
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(builder: (productController) {
      return Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(
            overflow: TextOverflow.ellipsis,
            'Select View for Items',
            style: robotoMedium.copyWith(
                fontSize: Dimensions.fontSizeExtraLarge + 2),
          ),
          Row(
            children: [
              Checkbox(
                value: gridView,
                activeColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusSmall)),
                onChanged: (newValue) {
                  setState(() {
                    gridView = newValue ?? listView;
                    if (gridView) {
                      listView = false;
                    } else {
                      gridView = true;
                    }
                  });
                },
                visualDensity:
                    const VisualDensity(horizontal: -3, vertical: -3),
              ),
              const Icon(Icons.grid_view_rounded),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  'Grid View',
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge + 2),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: listView,
                activeColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusSmall)),
                onChanged: (newValue) {
                  setState(() {
                    listView = newValue ?? listView;
                    if (listView) {
                      gridView = false;
                    } else {
                      listView = true;
                    }
                  });
                },
                visualDensity:
                    const VisualDensity(horizontal: -3, vertical: -3),
              ),
              const Icon(Icons.view_list_rounded),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  'List View',
                  style: robotoMedium.copyWith(
                      fontSize: Dimensions.fontSizeExtraLarge + 2),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                'Images of Categories',
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge + 2),
              ),
              Checkbox(
                value: CatImage,
                activeColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusSmall)),
                onChanged: (bool? newValue) {
                  setState(() {
                    CatImage = newValue ?? CatImage;
                  });
                },
                visualDensity:
                    const VisualDensity(horizontal: -3, vertical: -3),
              )
            ],
          ),
          Row(
            children: [
              Text(
                overflow: TextOverflow.ellipsis,
                'Images of Items',
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeExtraLarge + 2),
              ),
              Checkbox(
                value: image,
                activeColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radiusSmall)),
                onChanged: (bool? newValue) {
                  setState(() {
                    image = newValue ?? image;
                  });
                },
                visualDensity:
                    const VisualDensity(horizontal: -3, vertical: -3),
              )
            ],
          ),
          CustomButton(
            margin: EdgeInsets.all(ResponsiveHelper.isSmallTab()
                ? 5
                : Dimensions.paddingSizeSmall),
            buttonText: "Save",
            onPressed: () {
              productController.image = image;
              productController.CatImage = CatImage;
              productController.gridView = gridView;
              productController.listView = listView;

              productController.save();
              Navigator.pop(context);
            },
          )
        ]),
      );
    });
  }
}
