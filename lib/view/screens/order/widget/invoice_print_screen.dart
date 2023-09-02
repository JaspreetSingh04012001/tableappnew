// // import 'dart:async';
// // import 'dart:developer';
// // import 'dart:io';

// // import 'package:esc_pos_utils/esc_pos_utils.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// // import '../../../../controller/order_controller.dart';
// // import '../../../../controller/splash_controller.dart';
// // import '../../../../data/model/response/config_model.dart';
// // import '../../../../data/model/response/order_details_model.dart';
// // import '../../../../data/model/response/product_model.dart';
// // import '../../../../helper/price_converter.dart';
// // import '../../../../util/dimensions.dart';
// // import '../../../../util/styles.dart';

// // class BluetoothPrinter {
// //   int? id;
// //   String? deviceName;
// //   String? address;
// //   String? port;
// //   String? vendorId;
// //   String? productId;
// //   bool isBle;

// //   PrinterType typePrinter;
// //   bool? state;

// //   BluetoothPrinter({
// //     this.deviceName,
// //     this.address,
// //     this.port,
// //     this.state,
// //     this.vendorId,
// //     this.productId,
// //     this.typePrinter = PrinterType.bluetooth,
// //     this.isBle = false,
// //   });
// // }

// // class InVoicePrintScreen extends StatefulWidget {
// //   const InVoicePrintScreen({super.key});

// //   @override
// //   State<InVoicePrintScreen> createState() => _InVoicePrintScreenState();
// // }

// // class _InVoicePrintScreenState extends State<InVoicePrintScreen> {
// //   int itemCount = 0;
// //   PrinterType _defaultPrinterType = PrinterType.bluetooth;
// //   final bool _isBle = GetPlatform.isIOS;
// //   final PrinterManager _printerManager = PrinterManager.instance;
// //   final List<BluetoothPrinter> _devices = <BluetoothPrinter>[];
// //   StreamSubscription<PrinterDevice>? _subscription;
// //   StreamSubscription<BTStatus>? _subscriptionBtStatus;
// //   BTStatus _currentStatus = BTStatus.none;
// //   List<int>? pendingTask;
// //   String _ipAddress = '';
// //   String _port = '9100';
// //   final bool _paper80MM = true;
// //   final TextEditingController _ipController = TextEditingController();
// //   final TextEditingController _portController = TextEditingController();
// //   BluetoothPrinter? _selectedPrinter;
// //   bool _searchingMode = true;
// //   String removeEmptyLines(String input) {
// //     return input
// //         .replaceAll(RegExp(r'^\s*$\n', multiLine: true), '')
// //         .split('\n')
// //         .map((line) => line.trimLeft())
// //         .join('\n');
// //   }

// //   @override
// //   void initState() {
// //     if (Platform.isWindows) _defaultPrinterType = PrinterType.usb;
// //     super.initState();
// //     _portController.text = _port;
// //     _scan();

// //     // subscription to listen change status of bluetooth connection
// //     _subscriptionBtStatus =
// //         PrinterManager.instance.stateBluetooth.listen((status) {
// //       log(' ----------------- status bt $status ------------------ ');
// //       _currentStatus = status;

// //       if (status == BTStatus.connected && pendingTask != null) {
// //         Future.delayed(const Duration(milliseconds: 1000), () {
// //           PrinterManager.instance
// //               .send(type: PrinterType.bluetooth, bytes: pendingTask!);
// //           pendingTask = null;
// //         });
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _subscription?.cancel();
// //     _subscriptionBtStatus?.cancel();
// //     _portController.dispose();
// //     _ipController.dispose();
// //     super.dispose();
// //   }

// //   // method to scan devices according PrinterType
// //   void _scan() {
// //     _devices.clear();
// //     _subscription = _printerManager
// //         .discovery(type: _defaultPrinterType, isBle: _isBle)
// //         .listen((device) {
// //       _devices.add(BluetoothPrinter(
// //         deviceName: device.name,
// //         address: device.address,
// //         isBle: _isBle,
// //         vendorId: device.vendorId,
// //         productId: device.productId,
// //         typePrinter: _defaultPrinterType,
// //       ));
// //       setState(() {});
// //     });
// //   }

// //   void _setPort(String value) {
// //     if (value.isEmpty) value = '9100';
// //     _port = value;
// //     var device = BluetoothPrinter(
// //       deviceName: value,
// //       address: _ipAddress,
// //       port: _port,
// //       typePrinter: PrinterType.network,
// //       state: false,
// //     );
// //     _selectDevice(device);
// //   }

// //   void _setIpAddress(String value) {
// //     _ipAddress = value;
// //     BluetoothPrinter device = BluetoothPrinter(
// //       deviceName: value,
// //       address: _ipAddress,
// //       port: _port,
// //       typePrinter: PrinterType.network,
// //       state: false,
// //     );
// //     _selectDevice(device);
// //   }

// //   void _selectDevice(BluetoothPrinter device) async {
// //     if (_selectedPrinter != null) {
// //       if ((device.address != _selectedPrinter!.address) ||
// //           (device.typePrinter == PrinterType.usb &&
// //               _selectedPrinter!.vendorId != device.vendorId)) {
// //         await PrinterManager.instance
// //             .disconnect(type: _selectedPrinter!.typePrinter);
// //       }
// //     }

// //     _selectedPrinter = device;
// //     setState(() {});
// //   }

// //   Future _printReceipt() async {
// //    // _selectedPrinter.
// //     OrderController orderController = Get.find<OrderController>();
// //     SplashController splashController = Get.find<SplashController>();

// // //orderController.currentOrderDetails.details;
// //     double itemsPrice = 0;
// //     double discount = 0;
// //     double tax = 0;
// //     double addOnsPrice = 0;
// //     late String date;
// //     String? name;
// //     SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
// //     // sharedPreferences.setString("branchName", value.name.toString());
// //     name = sharedPreferences.getString("branchName");

// //     splashController.configModel?.branch?.forEach((Branch value) async {
// //       if (splashController.selectedBranchId == value.id) {
// //         name = value.name;
// //         //splashController.updateBranchId(value.id);
// //       }
// //     });
// //     List<Details> orderDetails =
// //         orderController.currentOrderDetails?.details ?? [];
// //     if (orderController.currentOrderDetails?.details != null) {
// //       for (Details orderDetails in orderDetails) {
// //         itemCount += orderDetails.quantity!.toInt();
// //         itemsPrice =
// //             itemsPrice + (orderDetails.price! * orderDetails.quantity!.toInt());
// //         discount = discount +
// //             (orderDetails.discountOnProduct! * orderDetails.quantity!.toInt());
// //         tax = (tax +
// //             (orderDetails.taxAmount! * orderDetails.quantity!.toInt()) +
// //             orderDetails.addonTaxAmount!);
// //         date = orderDetails.createdAt!.replaceAll("T", " ");
// //       }
// //     }

// //     double total = itemsPrice - discount + tax;

// //     // widget.order;
// //     // widget.orderDetails;
// //     // var date =
// //     //     DateConverter.dateTimeStringToMonthAndTime(widget.order!.createdAt!);
// //     CapabilityProfile profile = await CapabilityProfile.load();
// //     Generator generator = Generator(PaperSize.mm58, profile);
// //     //  Generator(_paper80MM ? PaperSize.mm80 : PaperSize.mm58, profile);
// //     List<int> bytes = [];

// //     // bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,"EFood",
// //     //     styles: const PosStyles(
// //     //         bold: true,
// //     //         align: PosAlign.center,
// //     //         height: PosTextSize.size3,
// //     //         width: PosTextSize.size3));

// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,name ?? " ",
// //         styles: const PosStyles(
// //             bold: true,
// //             align: PosAlign.center,
// //             height: PosTextSize.size2,
// //             width: PosTextSize.size2));
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,'order_summary'.tr,
// //         styles: const PosStyles(
// //             bold: true,
// //             align: PosAlign.center,
// //             height: PosTextSize.size2,
// //             width: PosTextSize.size2));
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //         '${'order'.tr}# ${orderController.currentOrderDetails?.order?.id}',
// //         styles: const PosStyles(
// //             bold: true, align: PosAlign.center, height: PosTextSize.size1));
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,date,
// //         styles: const PosStyles(
// //             bold: true, align: PosAlign.center, height: PosTextSize.size1));
// //     // bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //     //     '${'table'.tr} ${Get.find<SplashController>().getTable(
// //     //           orderController.currentOrderDetails?.order?.tableId,
// //     //           branchId: orderController.currentOrderDetails?.order?.branchId,
// //     //         )?.number} |',
// //     //     styles: const PosStyles(
// //     //         bold: true, align: PosAlign.center, height: PosTextSize.size1));
// //     // bytes += generator.Text(
// //overflow: TextOverflow.ellipsis,
// //     //     '${orderController.currentOrderDetails?.order?.numberOfPeople ?? 'add'.tr} ${'people'.tr}',
// //     //     styles: const PosStyles(
// //     //         bold: true, align: PosAlign.center, height: PosTextSize.size1));
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //         orderController.currentOrderDetails?.order?.customer_name ?? '',
// //         styles: const PosStyles(
// //             bold: true, align: PosAlign.center, height: PosTextSize.size1));
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,"Qty x Item info = Price");
// //     bytes += generator.hr(ch: "-");

// //     orderController.currentOrderDetails?.details?.forEach((details) {
// //       String variationText = '';
// //       int a = 0;
// //       String addonsName = '';
// //       bool takeAway = false;

// //       List<AddOns> addons = details.productDetails == null
// //           ? []
// //           : details.productDetails!.addOns == null
// //               ? []
// //               : details.productDetails!.addOns!;
// //       List<int> addQty = details.addOnQtys ?? [];
// //       List<int> ids = details.addOnIds ?? [];
// //       if (ids.length == details.addOnPrices?.length &&
// //           ids.length == details.addOnQtys?.length) {
// //         for (int i = 0; i < ids.length; i++) {
// //           addOnsPrice =
// //               addOnsPrice + (details.addOnPrices![i] * details.addOnQtys![i]);
// //         }
// //       }
// //       try {
// //         for (AddOns addOn in addons) {
// //           if (ids.contains(addOn.id)) {
// //             addonsName = addonsName + ('${addOn.name} (${(addQty[a])}), ');
// //             a++;
// //           }
// //         }
// //       } catch (e) {
// //         debugPrint('order details view -$e');
// //       }
// //       if (details.variations != null && details.variations!.isNotEmpty) {
// //         for (Variation variation in details.variations!) {
// //           variationText +=
// //               '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
// //           for (VariationValue value in variation.variationValues!) {
// //             variationText +=
// //                 '${variationText.endsWith('(') ? '' : ', '}${value.level}';
// //           }
// //           variationText += ')';
// //         }
// //       } else if (details.oldVariations != null &&
// //           details.oldVariations!.isNotEmpty) {
// //         List<String> variationTypes = details.oldVariations![0].type != null
// //             ? details.oldVariations![0].type!.split('-')
// //             : [];

// //         if (variationTypes.length ==
// //             details.productDetails?.choiceOptions?.length) {
// //           int index = 0;
// //           details.productDetails?.choiceOptions?.forEach((choice) {
// //             // choice.
// //             variationText =
// //                 '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
// //             index = index + 1;
// //           });
// //         } else {
// //           variationText = details.oldVariations?[0].type ?? '';
// //         }
// //       }
// //       if (variationText.contains("Order Type (Take Away)")) {
// //         takeAway = true;
// //       }
// //       print("Jass $variationText");
// //       variationText = variationText
// //           .replaceAll("Choose ()", "")
// //           .replaceAll("optiona (", "")
// //           .replaceAll("Order Type (Dining)", "")
// //           .replaceAll("Order Type (Take Away)", "")
// //           .replaceAll("Choose (", "\n")
// //           .replaceAll("Choose One (", "\n")
// //           .replaceAll(")", "")
// //           .replaceAll(",", "\n");
// //       variationText = removeEmptyLines(variationText);
// //       // variationText.

// //       bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,takeAway ? "** Take Away **" : "* Eat In *",
// //           styles: const PosStyles(
// //               bold: true,
// //               height: PosTextSize.size1,
// //               width: PosTextSize.size2,
// //               align: PosAlign.center));

// //       bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //           "${details.quantity} x ${details.productDetails?.name ?? ''} : ${PriceConverter.convertPrice(details.price! * details.quantity!)}",
// //           styles: const PosStyles(
// //             bold: true,
// //             height: PosTextSize.size1,
// //             width: PosTextSize.size2,
// //           ));

// //       if (addonsName.isNotEmpty) {
// //         bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,'${'addons'.tr}: $addonsName',
// //             styles: const PosStyles(bold: true, height: PosTextSize.size1));
// //       }
// //       if (variationText != '') {
// //         bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,variationText,
// //             styles: const PosStyles(bold: true, height: PosTextSize.size1));
// //       }
// //       bytes += generator.hr(ch: "-");
// //     });

// //     orderController.currentOrderDetails?.order?.orderNote != null
// //         ? bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //             'Note : ${orderController.currentOrderDetails?.order?.orderNote ?? ''}',
// //             styles: const PosStyles(
// //                 height: PosTextSize.size1,
// //                 width: PosTextSize.size2,
// //                 bold: true))
// //         : null;
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,"${'Item Count'} : $itemCount",
// //         styles: const PosStyles(
// //             height: PosTextSize.size1, width: PosTextSize.size2));
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //         "${'item_price'.tr} : ${PriceConverter.convertPrice(itemsPrice)}");
// //     // bytes += generator
// //     //     .Text(
//             overflow: TextOverflow.ellipsis,"${'discount'.tr} : -${PriceConverter.convertPrice(discount)}");

// //     // bytes += generator
// //     //     .Text(
//             overflow: TextOverflow.ellipsis,"${'vat_tax'.tr} : +${PriceConverter.convertPrice(tax)}");
// //     bytes += generator
// //         .Text(
//             overflow: TextOverflow.ellipsis,"${'add_ons'.tr} : +${PriceConverter.convertPrice(addOnsPrice)}");
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //         "${'total'.tr} : ${PriceConverter.convertPrice(total + addOnsPrice)}",
// //         styles: const PosStyles(
// //             height: PosTextSize.size2, width: PosTextSize.size2));

// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //         styles: const PosStyles(
// //             height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
// //         "${'${'paid_amount'.tr}${orderController.currentOrderDetails?.order?.paymentMethod != null ?
// //             //'(${orderController.currentOrderDetails?.order?.paymentMethod})' : ' (${'un_paid'.tr}) '}',
// //             '(${orderController.currentOrderDetails?.order?.paymentMethod})' : ''}'} : ${PriceConverter.convertPrice(orderController.currentOrderDetails?.order?.paymentStatus != 'unpaid' ? orderController.currentOrderDetails?.order?.orderAmount ?? 0 : 0)}");
// //     // bytes +=
// //     //     generator.Text(
//             overflow: TextOverflow.ellipsis,"${'vat_tax'.tr} : \$${widget.order!.totalTaxAmount!}");
// //     bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //         styles: const PosStyles(
// //             height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
// //         "${'change'.tr} : ${PriceConverter.convertPrice(orderController.getOrderSuccessModel()?.firstWhere((order) => order.orderId == orderController.currentOrderDetails?.order?.id.toString()).changeAmount ?? 0)}");
// //     // bytes += generator.hr(ch: "-");
// //     // bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,
// //     //     "${'total_amount'.tr} : \$${widget.order!.orderAmount!}",
// //     //     styles: const PosStyles(
// //     //         align: PosAlign.center, bold: true, height: PosTextSize.size1));
// //     // bytes += generator.Text(
//             overflow: TextOverflow.ellipsis,'thank_you'.tr,
// //     //     styles: const PosStyles(
// //     //         align: PosAlign.center, bold: true, height: PosTextSize.size1));

// //     _printEscPos(bytes, generator);
// //   }

// //   /// print ticket
// //   void _printEscPos(List<int> bytes, Generator generator) async {
// //     if (_selectedPrinter == null) return;
// //     var bluetoothPrinter = _selectedPrinter!;

// //     switch (bluetoothPrinter.typePrinter) {
// //       case PrinterType.usb:
// //         bytes += generator.feed(2);
// //         bytes += generator.cut();
// //         await _printerManager.connect(
// //           type: bluetoothPrinter.typePrinter,
// //           model: UsbPrinterInput(
// //             name: bluetoothPrinter.deviceName,
// //             productId: bluetoothPrinter.productId,
// //             vendorId: bluetoothPrinter.vendorId,
// //           ),
// //         );
// //         break;
// //       case PrinterType.bluetooth:
// //         bytes += generator.cut();
// //         await _printerManager.connect(
// //           type: bluetoothPrinter.typePrinter,
// //           model: BluetoothPrinterInput(
// //             name: bluetoothPrinter.deviceName,
// //             address: bluetoothPrinter.address!,
// //             isBle: bluetoothPrinter.isBle,
// //           ),
// //         );
// //         pendingTask = null;
// //         if (Platform.isIOS || Platform.isAndroid) pendingTask = bytes;
// //         break;
// //       case PrinterType.network:
// //         bytes += generator.feed(2);
// //         bytes += generator.cut();
// //         await _printerManager.connect(
// //           type: bluetoothPrinter.typePrinter,
// //           model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!),
// //         );
// //         break;
// //       default:
// //     }
// //     if (bluetoothPrinter.typePrinter == PrinterType.bluetooth) {
// //       try {
// //         if (kDebugMode) {
// //           print('------$_currentStatus');
// //         }
// //         _printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
// //         pendingTask = null;
// //       } catch (_) {}
// //     } else {
// //       _printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return
// //         // _searchingMode ?
// //         SingleChildScrollView(
// //       //  padding: const EdgeInsets.all(Dimensions.fontSizeLarge),
// //       child: Column(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           // Text(
//             overflow: TextOverflow.ellipsis,'paper_size'.tr, style: robotoMedium),
// //           // Row(children: [
// //           //   Expanded(
// //           //       child: RadioListTile(
// //           //     title: Text(
//             overflow: TextOverflow.ellipsis,'80_mm'.tr),
// //           //     groupValue: _paper80MM,
// //           //     dense: true,
// //           //     contentPadding: EdgeInsets.zero,
// //           //     value: true,
// //           //     onChanged: (bool? value) {
// //           //       _paper80MM = true;
// //           //       setState(() {});
// //           //     },
// //           //   )),
// //           //   Expanded(
// //           //       child: RadioListTile(
// //           //     title: Text(
//             overflow: TextOverflow.ellipsis,'58_mm'.tr),
// //           //     groupValue: _paper80MM,
// //           //     contentPadding: EdgeInsets.zero,
// //           //     dense: true,
// //           //     value: false,
// //           //     onChanged: (bool? value) {
// //           //       _paper80MM = false;
// //           //       setState(() {});
// //           //     },
// //           //   )),
// //           // ]),
// //           SizedBox(height: Dimensions.paddingSizeSmall),
// //           ListView.builder(
// //             itemCount: _devices.length,
// //             shrinkWrap: true,
// //             physics: const NeverScrollableScrollPhysics(),
// //             itemBuilder: (context, index) {
// //               return Padding(
// //                 padding: EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
// //                 child: InkWell(
// //                   onTap: () {
// //                     _selectDevice(_devices[index]);
// //                     setState(() {
// //                       _searchingMode = false;
// //                     });
// //                     _printReceipt();
// //                     Navigator.of(context).pop();
// //                   },
// //                   child: Stack(children: [
// //                     Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(
//             overflow: TextOverflow.ellipsis,'${_devices[index].deviceName}'),
// //                           Platform.isAndroid &&
// //                                   _defaultPrinterType == PrinterType.usb
// //                               ? const SizedBox()
// //                               : Visibility(
// //                                   visible: !Platform.isWindows,
// //                                   child: Text(
//             overflow: TextOverflow.ellipsis,"${_devices[index].address}"),
// //                                 ),
// //                           index != _devices.length - 1
// //                               ? Divider(color: Theme.of(context).disabledColor)
// //                               : const SizedBox(),
// //                         ]),
// //                     (_selectedPrinter != null &&
// //                             ((_devices[index].typePrinter == PrinterType.usb &&
// //                                         Platform.isWindows
// //                                     ? _devices[index].deviceName ==
// //                                         _selectedPrinter!.deviceName
// //                                     : _devices[index].vendorId != null &&
// //                                         _selectedPrinter!.vendorId ==
// //                                             _devices[index].vendorId) ||
// //                                 (_devices[index].address != null &&
// //                                     _selectedPrinter!.address ==
// //                                         _devices[index].address)))
// //                         ? const Positioned(
// //                             top: 5,
// //                             right: 5,
// //                             child: Icon(Icons.check, color: Colors.green),
// //                           )
// //                         : const SizedBox(),
// //                   ]),
// //                 ),
// //               );
// //             },
// //           ),
// //           Visibility(
// //             visible: _defaultPrinterType == PrinterType.network &&
// //                 Platform.isWindows,
// //             child: Padding(
// //               padding: const EdgeInsets.only(top: 10.0),
// //               child: TextFormField(
// //                 controller: _ipController,
// //                 keyboardType:
// //                     const TextInputType.numberWithOptions(signed: true),
// //                 decoration: InputDecoration(
// //                   label: Text(
//             overflow: TextOverflow.ellipsis,'ip_address'.tr),
// //                   prefixIcon: const Icon(Icons.wifi, size: 24),
// //                 ),
// //                 onChanged: _setIpAddress,
// //               ),
// //             ),
// //           ),
// //           Visibility(
// //             visible: _defaultPrinterType == PrinterType.network &&
// //                 Platform.isWindows,
// //             child: Padding(
// //               padding: const EdgeInsets.only(top: 10.0),
// //               child: TextFormField(
// //                 controller: _portController,
// //                 keyboardType:
// //                     const TextInputType.numberWithOptions(signed: true),
// //                 decoration: InputDecoration(
// //                   label: Text(
//             overflow: TextOverflow.ellipsis,'port'.tr),
// //                   prefixIcon: const Icon(Icons.numbers_outlined, size: 24),
// //                 ),
// //                 onChanged: _setPort,
// //               ),
// //             ),
// //           ),
// //           Visibility(
// //             visible: _defaultPrinterType == PrinterType.network &&
// //                 Platform.isWindows,
// //             child: Padding(
// //               padding: const EdgeInsets.only(top: 10.0),
// //               child: OutlinedButton(
// //                 onPressed: () async {
// //                   if (_ipController.text.isNotEmpty) {
// //                     _setIpAddress(_ipController.text);
// //                   }
// //                   setState(() {
// //                     _searchingMode = false;
// //                   });
// //                 },
// //                 child: Padding(
// //                   padding:
// //                       const EdgeInsets.symmetric(vertical: 4, horizontal: 50),
// //                   child: Text(
//             overflow: TextOverflow.ellipsis,"print_ticket".tr, textAlign: TextAlign.center),
// //                 ),
// //               ),
// //             ),
// //           )
// //         ],
// //       ),
// //     );
// //     // : Container();
// //     // InvoiceDialog(
// //     //     order: widget.order,
// //     //     orderDetails: widget.orderDetails,
// //     //     onPrint: (i.Image? image) => _printReceipt(image!),
// //     //   );
// //   }
// // }

// // class PriceWidget extends StatelessWidget {
// //   final String title;
// //   final String value;
// //   final double fontSize;
// //   const PriceWidget(
// //       {Key? key,
// //       required this.title,
// //       required this.value,
// //       required this.fontSize})
// //       : super(key: key);

// //   @override
// //   Widget build(BuildContext context) {
// //     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
// //       Text(
//             overflow: TextOverflow.ellipsis,title, style: robotoRegular.copyWith(fontSize: fontSize)),
// //       Text(
//             overflow: TextOverflow.ellipsis,value, style: robotoMedium.copyWith(fontSize: fontSize)),
// //     ]);
// //   }
// // }
import 'package:efood_table_booking/view/screens/home/widget/quantity_button.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../controller/order_controller.dart';
import '../../../../controller/splash_controller.dart';
import '../../../../data/model/response/config_model.dart';
import '../../../../data/model/response/order_details_model.dart';
import '../../../../data/model/response/product_model.dart';
import '../../../../helper/price_converter.dart';

class InvoicePrintScreen extends StatefulWidget {
  const InvoicePrintScreen({Key? key}) : super(key: key);

  @override
  _InvoicePrintScreenState createState() => _InvoicePrintScreenState();
}

class _InvoicePrintScreenState extends State<InvoicePrintScreen> {
  int itemCount = 0;
  String removeEmptyLines(String input) {
    return input
        .replaceAll(RegExp(r'^\s*$\n', multiLine: true), '')
        .split('\n')
        .map((line) => line.trimLeft())
        .join('\n');
  }

  final String _info = "";
  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];
  final List<String> _options = [
    "permission bluetooth granted",
    "bluetooth enabled",
    "connection status",
    "update info"
  ];

  final String _selectSize = "2";
  final _txtText = TextEditingController(text: "Hello developer");
  bool _progress = false;
  String _msjprogress = "";
  int printCount = 1;
  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getBluetoots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            //  Text('info: $_info\n '),
            Text(_msj),
            Row(
              children: [
                const Text("Type print"),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: optionprinttype,
                  items: options.map((String option) {
                    return DropdownMenuItem<String>(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      optionprinttype = newValue!;
                    });
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Copies"),
                ),
                QuantityButton(
                    isIncrement: true,
                    onTap: () {
                      setState(() {
                        printCount = printCount + 1;
                      });
                    }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("$printCount"),
                ),
                QuantityButton(
                    isIncrement: false,
                    onTap: () {
                      if (printCount > 1) {
                        setState(() {
                          printCount = printCount - 1;
                        });
                      }
                    }),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll(Theme.of(context).primaryColor)),
              onPressed: () {
                getBluetoots();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: _progress,
                    child: const SizedBox(
                      width: 25,
                      height: 25,
                      child: CircularProgressIndicator.adaptive(
                          strokeWidth: 1, backgroundColor: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(_progress ? _msjprogress : "Search Printers"),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: items.isNotEmpty
                  ? ListView.builder(
                      itemCount: items.isNotEmpty ? items.length : 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            String mac = items[index].macAdress;
                            connect(mac);
                          },
                          title: Text('Name: ${items[index].name}'),
                          subtitle:
                              Text("macAddress: ${items[index].macAdress}"),
                        );
                      },
                    )
                  : Container(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      )),
            ),
            if (connected)
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).primaryColor)),
                onPressed: connected ? printTest : null,
                child: const Text("Save and Print"),
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Future<void> initPlatformState() async {
    String platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PrintBluetoothThermal.platformVersion;
      print("patformversion: $platformVersion");
      // porcentbatery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    print("bluetooth enabled: $result");
    if (result) {
      _msj = "Bluetooth enabled, please search and connect";
    } else {
      _msj = "Bluetooth not enabled";
    }

    setState(() {
      PrintBluetoothThermal.connectionStatus
          .then((value) => {connected = value});
      // _info = "$platformVersion ($porcentbatery% battery)";
    });
  }

  Future<void> getBluetoots() async {
    setState(() {
      _progress = true;
      _msjprogress = "Wait";
      items = [];
    });
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    setState(() {
      _progress = false;
    });

    if (listResult.isEmpty) {
      _msj =
          "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      _msj = "Touch an item in the list to connect";
    }

    setState(() {
      items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    setState(() {
      _progress = true;
      _msjprogress = "Connecting...";
      connected = false;
    });
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) connected = true;
    setState(() {
      _progress = false;
    });
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      connected = false;
    });
    print("status disconnect $status");
  }

  Future<void> printTest() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    print(printCount);
    printCount;
    // if(pref.getInt("printCount") == null){
    pref.setInt("printCount", printCount);
    // }
    //pref.getInt("printCount");
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
      List<int> ticket = await testTicket();
      for (int i = 0; i < printCount; i++) {
        PrintBluetoothThermal.writeBytes(ticket);
      }
    } else {
      //no conectado, reconecte
    }
    Navigator.pop(context);
  }

  // }

  Future<List<int>> testTicket() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    bytes += generator.drawer(pin: PosDrawer.pin2);
    bytes += generator.drawer();

    //bytes += generator.setGlobalFont(PosFontType.fontA);
    bytes += generator.reset();

    OrderController orderController = Get.find<OrderController>();
    SplashController splashController = Get.find<SplashController>();

//orderController.currentOrderDetails.details;
    double itemsPrice = 0;
    double discount = 0;
    double tax = 0;
    double addOnsPrice = 0;
    late String date;
    String? name;
    //SharedPreferences sharedPref//erences = await SharedPreferences.getInstance();
    // sharedPreferences.setString("branchName", value.name.toString());
    name = sharedPreferences.getString("branchName");

    splashController.configModel?.branch?.forEach((Branch value) async {
      if (splashController.selectedBranchId == value.id) {
        name = value.name;
        //splashController.updateBranchId(value.id);
      }
    });
    List<Details> orderDetails =
        orderController.currentOrderDetails?.details ?? [];
    if (orderController.currentOrderDetails?.details != null) {
      for (Details orderDetails in orderDetails) {
        itemCount += orderDetails.quantity!.toInt();
        itemsPrice =
            itemsPrice + (orderDetails.price! * orderDetails.quantity!.toInt());
        discount = discount +
            (orderDetails.discountOnProduct! * orderDetails.quantity!.toInt());
        tax = (tax +
            (orderDetails.taxAmount! * orderDetails.quantity!.toInt()) +
            orderDetails.addonTaxAmount!);
        date = orderDetails.createdAt!.replaceAll("T", " ");
      }
    }

    double total = itemsPrice - discount + tax;

    // widget.order;
    // widget.orderDetails;
    // var date =
    //     DateConverter.dateTimeStringToMonthAndTime(widget.order!.createdAt!);

    // bytes += generator.text("EFood",
    //     styles: const PosStyles(
    //         bold: true,
    //         align: PosAlign.center,
    //         height: PosTextSize.size3,
    //         width: PosTextSize.size3));

    bytes += generator.text(name ?? " ",
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    bytes += generator.text('order_summary'.tr,
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    bytes += generator.text(
        '${'order'.tr}# ${orderController.currentOrderDetails?.order?.id}',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.text(date,
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    // bytes += generator.text(
    //     '${'table'.tr} ${Get.find<SplashController>().getTable(
    //           orderController.currentOrderDetails?.order?.tableId,
    //           branchId: orderController.currentOrderDetails?.order?.branchId,
    //         )?.number} |',
    //     styles: const PosStyles(
    //         bold: true, align: PosAlign.center, height: PosTextSize.size1));
    // bytes += generator.text(
    //     '${orderController.currentOrderDetails?.order?.numberOfPeople ?? 'add'.tr} ${'people'.tr}',
    //     styles: const PosStyles(
    //         bold: true, align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.text(
        orderController.currentOrderDetails?.order?.customer_name ?? '',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.text("Qty x Item info = Price");
    bytes += generator.hr(ch: "-");

    orderController.currentOrderDetails?.details?.forEach((details) {
      String variationText = '';
      int a = 0;
      String addonsName = '';
      bool takeAway = false;

      List<AddOns> addons = details.productDetails == null
          ? []
          : details.productDetails!.addOns == null
              ? []
              : details.productDetails!.addOns!;
      List<int> addQty = details.addOnQtys ?? [];
      List<int> ids = details.addOnIds ?? [];
      if (ids.length == details.addOnPrices?.length &&
          ids.length == details.addOnQtys?.length) {
        for (int i = 0; i < ids.length; i++) {
          addOnsPrice =
              addOnsPrice + (details.addOnPrices![i] * details.addOnQtys![i]);
        }
      }
      try {
        for (AddOns addOn in addons) {
          if (ids.contains(addOn.id)) {
            addonsName = addonsName + ('${addOn.name} (${(addQty[a])}), ');
            a++;
          }
        }
      } catch (e) {
        debugPrint('order details view -$e');
      }
      if (details.variations != null && details.variations!.isNotEmpty) {
        for (Variation variation in details.variations!) {
          variationText +=
              '${variationText.isNotEmpty ? ', ' : ''}${variation.name} (';
          for (VariationValue value in variation.variationValues!) {
            variationText +=
                '${variationText.endsWith('(') ? '' : ', '}${value.level}';
          }
          variationText += ')';
        }
      } else if (details.oldVariations != null &&
          details.oldVariations!.isNotEmpty) {
        List<String> variationTypes = details.oldVariations![0].type != null
            ? details.oldVariations![0].type!.split('-')
            : [];

        if (variationTypes.length ==
            details.productDetails?.choiceOptions?.length) {
          int index = 0;
          details.productDetails?.choiceOptions?.forEach((choice) {
            // choice.
            variationText =
                '$variationText${(index == 0) ? '' : ',  '}${choice.title} - ${variationTypes[index]}';
            index = index + 1;
          });
        } else {
          variationText = details.oldVariations?[0].type ?? '';
        }
      }
      if (variationText.contains("Order Type (Take Away)")) {
        takeAway = true;
      }
      print("Jass $variationText");
      variationText = variationText
          .replaceAll("Choose ()", "")
          .replaceAll("optiona (", "")
          .replaceAll("Order Type (Dining)", "")
          .replaceAll("Order Type (Take Away)", "")
          .replaceAll("Choose (", "\n")
          .replaceAll("Choose One (", "\n")
          .replaceAll(")", "")
          .replaceAll(",", "\n");
      variationText = removeEmptyLines(variationText);
      // variationText.

      bytes += generator.text(takeAway ? "** Take Away **" : "* Eat In *",
          styles: const PosStyles(
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size2,
              align: PosAlign.center));

      bytes += generator.text(
          "${details.quantity} x ${details.productDetails?.name ?? ''} : ${PriceConverter.convertPrice(details.price! * details.quantity!)}",
          styles: const PosStyles(
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size2,
          ));

      if (addonsName.isNotEmpty) {
        bytes += generator.text('${'addons'.tr}: $addonsName',
            styles: const PosStyles(bold: true, height: PosTextSize.size1));
      }
      if (variationText != '') {
        bytes += generator.text(variationText,
            styles: const PosStyles(bold: true, height: PosTextSize.size1));
      }
      bytes += generator.hr(ch: "-");
    });

    orderController.currentOrderDetails?.order?.orderNote != null
        ? bytes += generator.text(
            'Note : ${orderController.currentOrderDetails?.order?.orderNote ?? ''}',
            styles: const PosStyles(
                height: PosTextSize.size1,
                width: PosTextSize.size2,
                bold: true))
        : null;
    bytes += generator.text("${'Item Count'} : $itemCount",
        styles: const PosStyles(
            height: PosTextSize.size1, width: PosTextSize.size2));
    bytes += generator.text(
        "${'item_price'.tr} : ${PriceConverter.convertPrice(itemsPrice)}");
    // bytes += generator
    //     .text("${'discount'.tr} : -${PriceConverter.convertPrice(discount)}");

    // bytes += generator
    //     .text("${'vat_tax'.tr} : +${PriceConverter.convertPrice(tax)}");
    bytes += generator
        .text("${'add_ons'.tr} : +${PriceConverter.convertPrice(addOnsPrice)}");
    bytes += generator.text(
        "${'total'.tr} : ${PriceConverter.convertPrice(total + addOnsPrice)}",
        styles: const PosStyles(
            height: PosTextSize.size2, width: PosTextSize.size2));

    bytes += generator.text(
        styles: const PosStyles(
            height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
        "${'${'paid_amount'.tr}${orderController.currentOrderDetails?.order?.paymentMethod != null ?
            //'(${orderController.currentOrderDetails?.order?.paymentMethod})' : ' (${'un_paid'.tr}) '}',
            '(${orderController.currentOrderDetails?.order?.paymentMethod})' : ''}'} : ${PriceConverter.convertPrice(orderController.currentOrderDetails?.order?.paymentStatus != 'unpaid' ? orderController.currentOrderDetails?.order?.orderAmount ?? 0 : 0)}");
    // bytes +=
    //     generator.text("${'vat_tax'.tr} : \$${widget.order!.totalTaxAmount!}");
    bytes += generator.text(
        styles: const PosStyles(
            height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
        "${'change'.tr} : ${PriceConverter.convertPrice(orderController.getOrderSuccessModel()?.firstWhere((order) => order.orderId == orderController.currentOrderDetails?.order?.id.toString()).changeAmount ?? 0)}");
    bytes += generator.drawer();
    bytes += generator.drawer(pin: PosDrawer.pin5);
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }

  // Future<void> printWithoutPackage() async {
  //   //impresion sin paquete solo de PrintBluetoothTermal
  //   bool connectionStatus = await PrintBluetoothThermal.connectionStatus;
  //   if (connectionStatus) {
  //     String text = "${_txtText.text}\n";
  //     bool result = await PrintBluetoothThermal.writeString(
  //         printText: PrintTextSize(size: int.parse(_selectSize), text: text ,));
  //     print("status print result: $result");
  //     setState(() {
  //       _msj = "printed status: $result";
  //     });
  //   } else {
  //     //no conectado, reconecte
  //     setState(() {
  //       _msj = "no connected device";
  //     });
  //     print("no conectado");
  //   }
  // }
}
