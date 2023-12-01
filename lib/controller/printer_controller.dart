import 'package:efood_table_booking/controller/order_controller.dart';
import 'package:efood_table_booking/controller/splash_controller.dart';
import 'package:efood_table_booking/data/model/response/product_model.dart';
import 'package:efood_table_booking/helper/price_converter.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/response/config_model.dart';
import '../data/model/response/order_details_model.dart';

class PrinterController extends GetxController {
  final DateFormat formatter = DateFormat();

  @override
  void onInit() {
    print("PrinterController initiated");
    getDataFromStorages();
    // TODO: implement onInit
    super.onInit();
  }

  String removeEmptyLines(String input) {
    return input
        .replaceAll(RegExp(r'^\s*$\n', multiLine: true), '')
        .split('\n')
        .map((line) => line.trimLeft())
        .join('\n');
  }

  final String _info = "";
  String msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];
  final List<String> _options = [
    "permission bluetooth granted",
    "bluetooth enabled",
    "connection status",
    "update info"
  ];
  bool seperateByFront = false;
  bool seperateByBack = false;
  bool progress = false;
  bool openDrawer = false;

  String msjprogress = "";
  String? lastConnectDeviceAddress;
  int printCount = 1;
  int frontprintCount = 1;
  int backprintCount = 1;
  String optionprinttype = "58 mm";
  List<String> options = ["58 mm", "80 mm"];

  getDataFromStorages() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
//  image = sharedPreferences.getBool("image") ?? false;
//       CatImage = sharedPreferences.getBool("CatImage") ?? true;
//       listView = sharedPreferences.getBool("listView") ?? false;
//       gridView = sharedPreferences.getBool("gridView") ?? true;

    lastConnectDeviceAddress =
        sharedPreferences.getString("lastConnectDeviceAddress");

    optionprinttype = sharedPreferences.getString("optionprinttype") ?? "58 mm";
    printCount = sharedPreferences.getInt("printCount") ?? 1;

    openDrawer = sharedPreferences.getBool("openDrawer") ?? false;
    seperateByFront = sharedPreferences.getBool("seperateByFront") ?? false;
    seperateByBack = sharedPreferences.getBool("seperateByBack") ?? false;
    frontprintCount = sharedPreferences.getInt("frontprintCount") ?? 1;
    backprintCount = sharedPreferences.getInt("backprintCount") ?? 1;
    update();
    if (lastConnectDeviceAddress != null) {
      initPlatformState();
      getBluetoots();
      connect(lastConnectDeviceAddress ?? "");
    }
  }

  save() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("optionprinttype", optionprinttype);
    if (lastConnectDeviceAddress != null) {
      sharedPreferences.setString(
          "lastConnectDeviceAddress", lastConnectDeviceAddress ?? "");
    }
    sharedPreferences.setInt("printCount", printCount);
    sharedPreferences.setInt("frontprintCount", frontprintCount);
    sharedPreferences.setInt("backprintCount", backprintCount);
    sharedPreferences.setBool("openDrawer", openDrawer);
    sharedPreferences.setBool("seperateByFront", seperateByFront);
    sharedPreferences.setBool("seperateByBack", seperateByBack);
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    print("PrinterController initPlatformState");
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
    //  if (!mounted) return;

    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    print("bluetooth enabled: $result");
    if (result) {
      msj = "Bluetooth enabled, please search and connect";
    } else {
      msj = "Bluetooth not enabled";
    }

    PrintBluetoothThermal.connectionStatus.then((value) => {connected = value});
    // _info = "$platformVersion ($porcentbatery% battery)";

    update();
  }

  openDrawerOnClick() async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(
        optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80, profile);
    List<int> bytes = [];
    bytes += generator.drawer(pin: PosDrawer.pin2);
    bytes += generator.drawer();
    PrintBluetoothThermal.writeBytes(bytes);
  }

  Future<void> getBluetoots() async {
    print("PrinterController getBluetoots");
    progress = true;
    msjprogress = "Wait";
    items = [];
    update();
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    progress = false;

    update();
    if (listResult.isEmpty) {
      msj =
          "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      msj = "Touch an item in the list to connect";
    }

    items = listResult;

    update();
  }

  Future<void> connect(String mac) async {
    print("PrinterController connecting");
    progress = true;
    msjprogress = "Connecting...";
    connected = false;
    update();
    final bool result =
        await PrintBluetoothThermal.connect(macPrinterAddress: mac);
    print("state conected $result");
    if (result) connected = true;
    if (result) lastConnectDeviceAddress = mac;
    progress = false;

    update();
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;

    connected = false;
    update();
    print("status disconnect $status");
  }

  Future<void> printTest({bool byWaitor = false}) async {
    //  if (byWaitor) {}

    SharedPreferences pref = await SharedPreferences.getInstance();

    printCount;

    pref.setInt("printCount", printCount);
    // }
    //pref.getInt("printCount");
    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    //print("connection status: $conexionStatus");
    if (conexionStatus) {
      final profile = await CapabilityProfile.load();
      final generator = Generator(
          optionprinttype == "58 mm" ? PaperSize.mm58 : PaperSize.mm80,
          profile);

      List<int> ticket = generator.reset() + generator.drawer();
      await testTicket(
              generator: generator,
              splashController: Get.find<SplashController>(),
              orderController: Get.find<OrderController>())
          .whenComplete(() => null)
          .then((value) {
        for (int i = 0; i < printCount; i++) {
          //  ticket += generator.cut();
          ticket += value[0];
          ticket += generator.cut();
        }
        if (seperateByFront) {
          for (int i = 0; i < frontprintCount; i++) {
            //     ticket += generator.cut();
            ticket += value[1];
            ticket += generator.cut();
          }
        }
        if (seperateByBack) {
          for (int i = 0; i < backprintCount; i++) {
            //      ticket += generator.cut();
            ticket += value[2];
            ticket += generator.cut();
          }
        }
      });

      PrintBluetoothThermal.writeBytes(ticket);
    } else {
      //no conectado, reconecte
    }
  }

  Future<List<List<int>>> testTicket(
      {bool byWaitor = false,
      required Generator generator,
      required OrderController orderController,
      required SplashController splashController}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    List<int> bytes = [];
    List<int> Frontbytes = [];
    List<int> Backbytes = [];

    //double itemsPrice = 0;
    // double discount = 0;
    // double tax = 0;
    // double addOnsPrice = 0;
    late String date;
    String? name;
    int itemCount = 0;

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
        // itemsPrice =
        //     itemsPrice + (orderDetails.price! * orderDetails.quantity!.toInt());
        // discount = discount +
        //     (orderDetails.discountOnProduct! * orderDetails.quantity!.toInt());
        // tax = (tax +
        //     (orderDetails.taxAmount! * orderDetails.quantity!.toInt()) +
        //     orderDetails.addonTaxAmount!);
        date = orderController.currentOrderDetails?.order!.createdAt
                ?.replaceAll(".000000Z", "")
                .replaceAll("T", " ") ??
            "";
      }
    }

    // double total = orderController.currentOrderDetails?.order?.orderAmount ?? 0;

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

    bytes += generator.text(
        orderController.currentOrderDetails?.order?.customer_name ?? '',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.text(
        orderController.currentOrderDetails?.order?.customer_email ?? '',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    bytes += generator.text("Qty x Item info = Price");
    bytes += generator.hr(ch: "-");

    Frontbytes += generator.hr(ch: "-");

    Frontbytes += generator.text('order_summary'.tr,
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    Frontbytes += generator.text("Front Items",
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    Frontbytes += generator.text(
        '${'order'.tr}# ${orderController.currentOrderDetails?.order?.id}',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    Frontbytes += generator.text(date,
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));

    Frontbytes += generator.hr(ch: "-");
    Frontbytes += generator.text("Qty x Item info = Price");
    Frontbytes += generator.hr(ch: "-");

    Backbytes += generator.hr(ch: "-");
    Backbytes += generator.text('order_summary'.tr,
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    Backbytes += generator.text("Back Items",
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2));
    Backbytes += generator.text(
        '${'order'.tr}# ${orderController.currentOrderDetails?.order?.id}',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    Backbytes += generator.text(date,
        styles: const PosStyles(
            bold: true, align: PosAlign.center, height: PosTextSize.size1));
    Backbytes += generator.hr(ch: "-");
    Backbytes += generator.text("Qty x Item info = Price");
    Backbytes += generator.hr(ch: "-");

    orderController.currentOrderDetails?.details?.forEach((details) {
      String variationText = '';
      String? note = details.note;
      // int a = 0;
      //  String addonsName = '';
      bool takeAway = false;

      List<AddOns> addons = details.productDetails == null
          ? []
          : details.productDetails!.addOns == null
              ? []
              : details.productDetails!.addOns!;
      List<int> addQty = details.addOnQtys ?? [];
      List<int> ids = details.addOnIds ?? [];
      List<String> myAdddonData = [];
      List<String> myAdddonDataWithoutPrice = [];
      // if (ids.length == details.addOnPrices?.length &&
      //     ids.length == details.addOnQtys?.length) {
      //   for (int i = 0; i < ids.length; i++) {
      //     addOnsPrice =
      //         addOnsPrice + (details.addOnPrices![i] * details.addOnQtys![i]);
      //   }
      // }\\

      if (ids.length == details.addOnPrices?.length &&
          ids.length == details.addOnQtys?.length) {
        for (int j = 0; j < ids.length; j++) {
          int id = ids[j];

          for (var addOn in addons) {
            if (addOn.id == id) {
              myAdddonData.add(
                  "${addQty[j]} x ${addOn.name}:${PriceConverter.convertPrice(addOn.price! * addQty[j])}");
              myAdddonDataWithoutPrice.add("${addQty[j]} x ${addOn.name}");
            }
          }
          // if(){}
        }
      }
      // try {
      //   for (AddOns addOn in addons) {
      //     if (ids.contains(addOn.id)) {
      //       // "${details.quantity} x ${details.productDetails?.name ?? ''}:${PriceConverter.convertPrice(details.price! * details.quantity!)}",
      //       //  addonsName = addonsName + ('${addOn.name} (${(addQty[a])}), ');
      //       myAdddonData.add(
      //           "${addQty[a]} x ${addOn.name}:${PriceConverter.convertPrice(addOn.price! * addQty[a])}");
      //       a++;
      //     }
      //   }
      // } catch (e) {
      //   debugPrint('order details view -$e');
      // }
      if (details.variations != null && details.variations!.isNotEmpty) {
        for (Variation variation in details.variations!) {
          variationText +=
              '${variationText.isNotEmpty ? ',' : ''}${variation.name} (';
          for (VariationValue value in variation.variationValues!) {
            variationText += '${value.level}';
            //   '${variationText.endsWith('(') ? '' : ', '}${value.level}';
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
      if (variationText.contains("Order Type (Take away)")) {
        takeAway = true;
      }

      variationText = variationText
          .replaceAll("Order Type (Dine in)", "")
          .replaceAll("Order Type (Take away)", "")
          .replaceAll(",", "\n")
          .replaceAll("))", ")")
          .trimLeft();

      variationText = removeEmptyLines(variationText);

      if (details.productDetails?.printType == "front") {
        Frontbytes += generator.text(
            takeAway ? "** Take away **" : "* Eat In *",
            styles: const PosStyles(
                bold: true,
                height: PosTextSize.size1,
                width: PosTextSize.size2,
                align: PosAlign.center));

        Frontbytes += generator.text(
            myAdddonDataWithoutPrice.isNotEmpty
                ? "${details.productDetails?.name ?? ''} x ${details.quantity}"
                : "${details.quantity} x ${details.productDetails?.name ?? ''}",
            styles: const PosStyles(
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size2,
            ));

        if (myAdddonDataWithoutPrice.isNotEmpty) {
          for (var element in myAdddonDataWithoutPrice) {
            Frontbytes += generator.text(element,
                styles: const PosStyles(bold: true, height: PosTextSize.size1));
          }
        }
        if (variationText != '') {
          Frontbytes += generator.text("$variationText)",
              styles: const PosStyles(bold: true, height: PosTextSize.size1));
        }
        if (note != null && note != "null" && note != "") {
          Frontbytes += generator.text(note,
              styles: const PosStyles(bold: true, height: PosTextSize.size1));
        }
        Frontbytes += generator.hr(ch: "-");
      } else if (details.productDetails?.printType == "back") {
        Backbytes += generator.text(takeAway ? "** Take away **" : "* Eat In *",
            styles: const PosStyles(
                bold: true,
                height: PosTextSize.size1,
                width: PosTextSize.size2,
                align: PosAlign.center));

        Backbytes += generator.text(
            myAdddonDataWithoutPrice.isNotEmpty
                ? "${details.productDetails?.name ?? ''} x ${details.quantity}"
                : "${details.quantity} x ${details.productDetails?.name ?? ''}",
            styles: const PosStyles(
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size2,
            ));

        if (myAdddonDataWithoutPrice.isNotEmpty) {
          for (var element in myAdddonDataWithoutPrice) {
            Backbytes += generator.text(element,
                styles: const PosStyles(bold: true, height: PosTextSize.size1));
          }
        }
        if (variationText != '') {
          Backbytes += generator.text(variationText,
              styles: const PosStyles(bold: true, height: PosTextSize.size1));
        }
        if (note != null && note != "null" && note != "") {
          Backbytes += generator.text(note,
              styles: const PosStyles(bold: true, height: PosTextSize.size1));
        }
        Backbytes += generator.hr(ch: "-");
      }
      bytes += generator.text(takeAway ? "** Take away **" : "* Eat In *",
          styles: const PosStyles(
              bold: true,
              height: PosTextSize.size1,
              width: PosTextSize.size2,
              align: PosAlign.center));

      bytes += generator.text(
          myAdddonData.isNotEmpty
              ? "${details.productDetails?.name ?? ''} x ${details.quantity}"
              : "${details.quantity} x ${details.productDetails?.name ?? ''}:${PriceConverter.convertPrice(details.price! * details.quantity!)}",
          styles: const PosStyles(
            bold: true,
            height: PosTextSize.size1,
            width: PosTextSize.size2,
          ));

      if (myAdddonData.isNotEmpty) {
        for (var element in myAdddonData) {
          bytes += generator.text(element,
              styles: const PosStyles(bold: true, height: PosTextSize.size1));
        }
      }
      if (variationText != '') {
        bytes += generator.text("$variationText)",
            styles: const PosStyles(bold: true, height: PosTextSize.size1));
      }
      if (note != null && note != "null" && note != "") {
        bytes += generator.text(note,
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
        "${'total'.tr} : ${PriceConverter.convertPrice(orderController.currentOrderDetails?.order?.orderAmount ?? 0)}",
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
    if (orderController.currentOrderDetails?.order?.paymentMethod != null) {
      bytes += generator.text(
          "Payment Method : +${orderController.currentOrderDetails?.order?.paymentMethod ?? "hold"}");
    }
    bytes += generator.text(
        "Payment Method : +${orderController.currentOrderDetails?.order?.paymentStatus}");
    if (orderController.currentOrderDetails?.order?.paymentMethod == "cash") {
      bytes += generator.text(
          "Cash : +${PriceConverter.convertPrice(double.parse(orderController.currentOrderDetails?.order?.cash ?? "0"))}");
    }
    // PriceWithType(
    //   type: 'Cash',
    //   amount: PriceConverter.convertPrice(total +
    //       (orderController
    //               .getOrderSuccessModel()
    //               ?.firstWhere((order) =>
    //                   order.orderId ==
    //                   orderController
    //                       .currentOrderDetails
    //                       ?.order
    //                       ?.id
    //                       .toString())
    //               .changeAmount ??
    //           0)),
    // ),
    if (orderController.currentOrderDetails?.order?.paymentMethod == "split") {
      bytes += generator.text(
          "Cash : +${PriceConverter.convertPrice(double.parse(orderController.currentOrderDetails?.order?.cash ?? "0"))}");
      bytes += generator.text(
          "Card : +${PriceConverter.convertPrice(double.parse(orderController.currentOrderDetails?.order?.card ?? "0"))}");
    }

    if (orderController.currentOrderDetails?.order?.paymentMethod == "card") {
      bytes += generator.text(
          "Card : +${PriceConverter.convertPrice(double.parse(orderController.currentOrderDetails?.order?.card ?? "0"))}");
    }
    // if (orderController.currentOrderDetails?.order?.paymentMethod == "split") {
    //   bytes += generator.text(
    //       styles: const PosStyles(
    //           height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
    //       "${'change'.tr} : ${PriceConverter.convertPrice(((double.parse(orderController.currentOrderDetails?.order?.card ?? "0") + double.parse(orderController.currentOrderDetails?.order?.card ?? "0")) - (orderController.currentOrderDetails?.order?.orderAmount ?? 0)))}");
    // }
    if (orderController.currentOrderDetails?.order?.paymentMethod == "cash") {
      bytes += generator.text(
          styles: const PosStyles(
              height: PosTextSize.size1, width: PosTextSize.size1, bold: true),
          "${'change'.tr} : ${PriceConverter.convertPrice((double.parse(orderController.currentOrderDetails?.order?.cash ?? "0") - (orderController.currentOrderDetails?.order?.orderAmount ?? 0)))}");
    }

    bytes += generator.feed(2);

    // if (seperateByFront) {
    //   bytes += Frontbytes;
    // }
    // if (seperateByBack) {
    //   bytes += Backbytes;
    // }

    return [bytes, Frontbytes, Backbytes];
  }
}
