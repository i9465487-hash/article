import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustemMateral extends StatelessWidget {
  final void Function () onPressed ;
  final Widget chiled ;
  const CustemMateral({super.key, required this.onPressed, required this.chiled});

  @override
  Widget build(BuildContext context) {
    return  MaterialButton(
      color: Colors.blue,
      onPressed: onPressed,
      child:chiled ,
    );
  }
}
