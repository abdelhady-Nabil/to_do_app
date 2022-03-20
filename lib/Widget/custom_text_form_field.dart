import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  @required final Function validator;
  @required final TextEditingController controller;
  @required final String label;
  @required final String hintText;
  @required final TextInputType inputType;
  final IconData prefixIcon;
  final Function onFieldSubmitted;
  final Function onChanged;
  final Function onTap;

  CustomTextFormField({
    this.validator,
    this.controller,
    this.inputType,
    this.label,
    this.hintText,
    this.onChanged,
    this.onFieldSubmitted,
    this.prefixIcon,
    this.onTap,
});


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20),
        child: TextFormField(
          validator: validator,
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(prefixIcon),
            hintText: hintText,
            border: OutlineInputBorder(),

          ),
          keyboardType: TextInputType.emailAddress,
          onFieldSubmitted:onFieldSubmitted,
          onChanged:onChanged,
          onTap: onTap,
        ),
      ),
    );
  }
}
