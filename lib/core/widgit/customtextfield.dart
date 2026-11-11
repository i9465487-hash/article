
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final String labeltext;
  final TextEditingController? myController;
  final bool obscuretext;
  final bool isObscure;
  final VoidCallback? onToggle;
  final bool show;
  final TextInputType type0;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.hintText,
    required this.labeltext,
    required this.myController,
    required this.obscuretext,
    required this.type0,
    required this.show,
    required this.isObscure,
    this.onToggle,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(

        keyboardType: type0,
        obscureText: obscuretext && isObscure,
        controller: myController,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          label: Text(labeltext),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Colors.black),
          ),
          suffixIcon: show
              ? IconButton(
            icon: Icon(
              isObscure
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: onToggle,
          )
              : null,
        ),
      ),
    );
  }
}