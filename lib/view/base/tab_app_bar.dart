// ignore_for_file: recursive_getters

import 'package:flutter/material.dart';

class TabAppBar extends StatelessWidget implements PreferredSize{
  const TabAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).cardColor.withOpacity(0.1), offset: const Offset(0, 6), blurRadius: 12, spreadRadius: -3,
            ),
          ]),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw PreferredSize(preferredSize: preferredSize, child: child);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw PreferredSize(preferredSize: preferredSize, child: child);
}
