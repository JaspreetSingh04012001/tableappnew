import 'package:efood_table_booking/controller/printer_controller.dart';
import 'package:efood_table_booking/view/screens/home/widget/quantity_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../util/dimensions.dart';
import '../../../../util/styles.dart';

class InvoicePrintScreen extends StatefulWidget {
  bool ismobile;
  InvoicePrintScreen({Key? key, this.ismobile = false}) : super(key: key);

  @override
  _InvoicePrintScreenState createState() => _InvoicePrintScreenState();
}

class _InvoicePrintScreenState extends State<InvoicePrintScreen> {
  int itemCount = 0;

  @override
  void initState() {
    super.initState();
    if (Get.find<PrinterController>().connected) {
    } else {
      Get.find<PrinterController>().initPlatformState();
      // initPlatformState();
      // Get.find<PrinterController>().getBluetoots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PrinterController>(initState: (state) {
      print("PrinterController fuck");
    }, builder: (printerController) {
      return Scaffold(
        appBar: AppBar(
          leading: Container(),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.cancel,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: Text(
            "Printer Setup",
            style:
                robotoMedium.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "You're Printing Using D2home App",
                style: robotoMedium.copyWith(
                    fontSize: Dimensions.fontSizeLarge + 4),
              ),
              //  Text('info: $_info\n '),
              Text(printerController.msj),
              widget.ismobile
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Type print",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge + 4),
                            ),
                            const Gap(15),
                            DropdownButton<String>(
                              value: printerController.optionprinttype,
                              items: printerController.options
                                  .map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                printerController.optionprinttype = newValue!;
                                printerController.update();
                              },
                            ),
                          ],
                        ),
                        const Gap(5),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Copies",
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge + 4),
                              ),
                            ),
                            QuantityButton(
                                isIncrement: true,
                                onTap: () {
                                  printerController.printCount =
                                      printerController.printCount + 1;
                                  printerController.update();
                                }),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${printerController.printCount}",
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge + 4),
                              ),
                            ),
                            QuantityButton(
                                isIncrement: false,
                                onTap: () {
                                  if (printerController.printCount > 1) {
                                    printerController.printCount =
                                        printerController.printCount - 1;
                                    printerController.update();
                                  }
                                }),
                            const SizedBox(
                              width: 15,
                            ),
                            Text(
                              "Open Drawer",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge + 4),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CupertinoSwitch(
                                // This bool value toggles the switch.
                                value: printerController.openDrawer,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.

                                  printerController.openDrawer = value;
                                  printerController.update();
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Type print",
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge + 4),
                        ),
                        const SizedBox(width: 10),
                        DropdownButton<String>(
                          value: printerController.optionprinttype,
                          items: printerController.options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            printerController.optionprinttype = newValue!;
                            printerController.update();
                          },
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Copies",
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge + 4),
                          ),
                        ),
                        QuantityButton(
                            isIncrement: true,
                            onTap: () {
                              printerController.printCount =
                                  printerController.printCount + 1;
                              printerController.update();
                            }),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${printerController.printCount}",
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeLarge + 4),
                          ),
                        ),
                        QuantityButton(
                            isIncrement: false,
                            onTap: () {
                              if (printerController.printCount > 1) {
                                printerController.printCount =
                                    printerController.printCount - 1;
                                printerController.update();
                              }
                            }),
                        const SizedBox(
                          width: 15,
                        ),
                        Text(
                          "Open Drawer",
                          style: robotoMedium.copyWith(
                              fontSize: Dimensions.fontSizeLarge + 4),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: CupertinoSwitch(
                            // This bool value toggles the switch.
                            value: printerController.openDrawer,
                            activeColor: Theme.of(context).primaryColor,
                            onChanged: (bool value) {
                              // This is called when the user toggles the switch.

                              printerController.openDrawer = value;
                              printerController.update();
                            },
                          ),
                        ),
                      ],
                    ),

              widget.ismobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Print Front Items Separate",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge + 4),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CupertinoSwitch(
                                // This bool value toggles the switch.
                                value: printerController.seperateByFront,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.

                                  printerController.seperateByFront = value;
                                  printerController.update();
                                },
                              ),
                            ),
                          ],
                        ),
                        if (printerController.seperateByFront)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Front Copies",
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge + 4),
                              ),
                              QuantityButton(
                                  isIncrement: true,
                                  onTap: () {
                                    printerController.frontprintCount =
                                        printerController.frontprintCount + 1;
                                    printerController.update();
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${printerController.frontprintCount}",
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge + 4),
                                ),
                              ),
                              QuantityButton(
                                  isIncrement: false,
                                  onTap: () {
                                    if (printerController.frontprintCount > 1) {
                                      printerController.frontprintCount =
                                          printerController.frontprintCount - 1;
                                      printerController.update();
                                    }
                                  }),
                            ],
                          ),
                        Row(
                          children: [
                            Text(
                              "Print Back Items Separate",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge + 4),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: CupertinoSwitch(
                                // This bool value toggles the switch.
                                value: printerController.seperateByBack,
                                activeColor: Theme.of(context).primaryColor,
                                onChanged: (bool value) {
                                  // This is called when the user toggles the switch.

                                  printerController.seperateByBack = value;
                                  printerController.update();
                                },
                              ),
                            )
                          ],
                        ),
                        if (printerController.seperateByBack)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Back Copies",
                                style: robotoMedium.copyWith(
                                    fontSize: Dimensions.fontSizeLarge + 4),
                              ),
                              QuantityButton(
                                  isIncrement: true,
                                  onTap: () {
                                    printerController.backprintCount =
                                        printerController.backprintCount + 1;
                                    printerController.update();
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "${printerController.backprintCount}",
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge + 4),
                                ),
                              ),
                              QuantityButton(
                                  isIncrement: false,
                                  onTap: () {
                                    if (printerController.backprintCount > 1) {
                                      printerController.backprintCount =
                                          printerController.backprintCount - 1;
                                      printerController.update();
                                    }
                                  }),
                            ],
                          ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 25,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Print Front Items Separate",
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge + 4),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CupertinoSwitch(
                                    // This bool value toggles the switch.
                                    value: printerController.seperateByFront,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (bool value) {
                                      // This is called when the user toggles the switch.

                                      printerController.seperateByFront = value;
                                      printerController.update();
                                    },
                                  ),
                                ),
                              ],
                            ),
                            if (printerController.seperateByFront)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Front Copies",
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge + 4),
                                  ),
                                  QuantityButton(
                                      isIncrement: true,
                                      onTap: () {
                                        printerController.frontprintCount =
                                            printerController.frontprintCount +
                                                1;
                                        printerController.update();
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${printerController.frontprintCount}",
                                      style: robotoMedium.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeLarge + 4),
                                    ),
                                  ),
                                  QuantityButton(
                                      isIncrement: false,
                                      onTap: () {
                                        if (printerController.frontprintCount >
                                            1) {
                                          printerController.frontprintCount =
                                              printerController
                                                      .frontprintCount -
                                                  1;
                                          printerController.update();
                                        }
                                      }),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Print Back Items Separate",
                                  style: robotoMedium.copyWith(
                                      fontSize: Dimensions.fontSizeLarge + 4),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: CupertinoSwitch(
                                    // This bool value toggles the switch.
                                    value: printerController.seperateByBack,
                                    activeColor: Theme.of(context).primaryColor,
                                    onChanged: (bool value) {
                                      // This is called when the user toggles the switch.

                                      printerController.seperateByBack = value;
                                      printerController.update();
                                    },
                                  ),
                                )
                              ],
                            ),
                            if (printerController.seperateByBack)
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Back Copies",
                                    style: robotoMedium.copyWith(
                                        fontSize: Dimensions.fontSizeLarge + 4),
                                  ),
                                  QuantityButton(
                                      isIncrement: true,
                                      onTap: () {
                                        printerController.backprintCount =
                                            printerController.backprintCount +
                                                1;
                                        printerController.update();
                                      }),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${printerController.backprintCount}",
                                      style: robotoMedium.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeLarge + 4),
                                    ),
                                  ),
                                  QuantityButton(
                                      isIncrement: false,
                                      onTap: () {
                                        if (printerController.backprintCount >
                                            1) {
                                          printerController.backprintCount =
                                              printerController.backprintCount -
                                                  1;
                                          printerController.update();
                                        }
                                      }),
                                ],
                              ),
                          ],
                        ),
                      ],
                    ),
              const Gap(5),
              ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                        Theme.of(context).primaryColor)),
                onPressed: () {
                  printerController.getBluetoots();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: printerController.progress,
                      child: const SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator.adaptive(
                            strokeWidth: 1, backgroundColor: Colors.white),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      printerController.progress
                          ? printerController.msjprogress
                          : "Search Printers",
                      style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeLarge + 4),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: printerController.progress
                    ? Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ))
                    : printerController.items.isNotEmpty
                        ? ListView.builder(
                            itemCount: printerController.items.isNotEmpty
                                ? printerController.items.length
                                : 0,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () {
                                  String mac =
                                      printerController.items[index].macAdress;
                                  printerController.connect(mac);
                                },
                                title: Text(
                                    'Name: ${printerController.items[index].name}'),
                                subtitle: Text(
                                    "macAddress: ${printerController.items[index].macAdress}"),
                              );
                            },
                          )
                        : Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Search Printers",
                              style: robotoMedium.copyWith(
                                  fontSize: Dimensions.fontSizeLarge + 4),
                            ),
                          ),
              ),
              if (printerController.connected)
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                          Theme.of(context).primaryColor)),
                  onPressed: printerController.connected
                      ? () {
                          // printerController.
                          printerController.save();
                          Navigator.pop(context);
                        }
                      : null,
                  child: Text(
                    "Save and Print",
                    style: robotoMedium.copyWith(
                        fontSize: Dimensions.fontSizeLarge + 4),
                  ),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    });
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
