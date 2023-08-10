import 'package:efood_table_booking/util/dimensions.dart';
import 'package:efood_table_booking/util/styles.dart';
import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData suffixIcon;
  final Function iconPressed;
  final Function(String) onSubmit;
  final Function(String) onChanged;
  const SearchField({super.key, 
    required this.controller,
    required this.hint,
    required this.suffixIcon,
    required this.iconPressed,
    required this.onSubmit,
    required this.onChanged,
  });

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: robotoRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        filled: true,
        fillColor: Theme.of(context).primaryColor.withOpacity(0.02),
        isDense: true,
        suffixIcon: IconButton(
          onPressed:()=> widget.iconPressed(),
          icon: Icon(widget.suffixIcon, color: Theme.of(context).hintColor,),
        ),

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1),
        ),
      ),
      onSubmitted:(pattern)=> widget.onSubmit(pattern),
      onChanged:(pattern)=> widget.onChanged(pattern),
    );
  }
}
