import 'package:flutter/material.dart';

class ErrorPlaceholder extends StatelessWidget {
  final BoxDecoration decoration;
  double size = double.infinity;
  ErrorPlaceholder([this.decoration, this.size]);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        child: Icon(Icons.error),
        decoration: decoration == null
            ? BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(8),
              )
            : decoration);
  }
}
