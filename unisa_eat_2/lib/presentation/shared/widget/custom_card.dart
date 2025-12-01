import 'package:flutter/material.dart';



class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double elevation;


  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.borderRadius = 12,
    this.elevation = 6,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      
      elevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(),
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
