import 'package:flutter/material.dart';

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  const ResponsivePadding({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).size.width > 650
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3.8)
          : const EdgeInsets.all(5.0),
      child: child,
    );
  }
}
