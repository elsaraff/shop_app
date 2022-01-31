import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customTextFormField({
  @required TextEditingController controller,
  @required TextInputType type,
  bool isPassword = false,
  @required Function validate,
  Function onSubmit,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
}) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: Colors.white30, borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        obscureText: isPassword,
        validator: validate,
        onFieldSubmitted: onSubmit,
        decoration: InputDecoration(
          hintText: label,
          prefixIcon: Icon(
            prefix,
            color: Colors.red,
          ),
          suffixIcon: suffix != null
              ? IconButton(
                  onPressed: suffixPressed,
                  icon: Icon(
                    suffix,
                    color: Colors.red,
                  ),
                )
              : null,
          border: const OutlineInputBorder(),
        ),
      ),
    );
