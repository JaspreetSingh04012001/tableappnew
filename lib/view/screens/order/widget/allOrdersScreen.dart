// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../../../../controller/order_controller.dart';
// import '../../../../data/model/response/order_details_model.dart';
// import '../../../base/custom_loader.dart';
// import '../../root/no_data_screen.dart';

// class AllOrdersScreen extends StatefulWidget {
//   const AllOrdersScreen({Key? key}) : super(key: key);

//   @override
//   _AllOrdersScreenState createState() => _AllOrdersScreenState();
// }

// class _AllOrdersScreenState extends State<AllOrdersScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Theme.of(context).primaryColor,
//         title: const Text(
//           overflow: TextOverflow.ellipsis,
//           "All orders",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: MediaQuery.of(context).size.width,
//         child: GetBuilder<OrderController>(builder: (orderController) {
//           List<String> orderIdList = [];
//           orderController.orderList
//               ?.map((order) => orderIdList.add('${'order'.tr}# ${order.id}'))
//               .toList();

//           return orderController.isLoading || orderController.orderList == null
//               ? Center(
//                   child: CustomLoader(
//                   color: Theme.of(context).primaryColor,
//                 ))
//               : orderController.orderList!.isNotEmpty
//                   ? SizedBox(
//                       height: MediaQuery.of(context).size.height,
//                       width: MediaQuery.of(context).size.width,
//                       //color: Colors.yellow,
//                       // margin:
//                       //     EdgeInsets.only(left: Dimensions.paddingSizeLarge),
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 20, horizontal: 10),
//                         child: GridView.builder(
//                             itemCount: orderIdList.length,
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                                     crossAxisCount: 4),
//                             itemBuilder: (context, index) {
//                               orderController.setCurrentOrderId =
//                                   orderIdList[index];
//                               orderController.getCurrentOrder(orderIdList[index]
//                                   .replaceAll('${'order'.tr}# ', ''));
//                               double itemsPrice = 0;
//                               double discount = 0;
//                               double tax = 0;
//                               double addOnsPrice = 0;
//                               List<Details> orderDetails = orderController
//                                       .currentOrderDetails?.details ??
//                                   [];
//                               if (orderController
//                                       .currentOrderDetails?.details !=
//                                   null) {
//                                 for (Details orderDetails in orderDetails) {
//                                   itemsPrice = itemsPrice +
//                                       (orderDetails.price! *
//                                           orderDetails.quantity!.toInt());
//                                   discount = discount +
//                                       (orderDetails.discountOnProduct! *
//                                           orderDetails.quantity!.toInt());
//                                   tax = (tax +
//                                       (orderDetails.taxAmount! *
//                                           orderDetails.quantity!.toInt()) +
//                                       orderDetails.addonTaxAmount!);
//                                 }
//                               }

//                               double total = itemsPrice - discount + tax;
//                               return Padding(
//                                 padding: const EdgeInsets.all(5.0),
//                                 child: Container(
//                                   color: Theme.of(context).primaryColor,
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                           overflow: TextOverflow.ellipsis,
//                                           orderIdList[index]),
//                                       Text(
//                                           overflow: TextOverflow.ellipsis,
//                                           total.toString()),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             }),
//                       ),

//                       //  FilterButtonWidget(
//                       //   type: orderController.currentOrderId == null
//                       //       ? orderIdList.first
//                       //       : orderController.currentOrderId!,
//                       //   onSelected: (id) {
//                       //     orderController.setCurrentOrderId = id;
//                       //     orderController
//                       //         .getCurrentOrder(
//                       //             id.replaceAll('${'order'.tr}# ', ''),
//                       //             isLoading: !widget.isOrderDetails)
//                       //         .then((value) {
//                       //       Get.find<OrderController>().cancelTimer();
//                       //       Get.find<OrderController>().countDownTimer();
//                       //     });
//                       //   },
//                       //   items: orderIdList,
//                       //   isBorder: true,
//                       // ),
//                     )
//                   : NoDataScreen(text: 'no_order_available'.tr);
//         }),
//       ),
//     );
//   }
// }
