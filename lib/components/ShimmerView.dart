import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerView extends StatelessWidget {
  late final double height;
  late final double width;
  late final double radius;

  ShimmerView({
    required this.height,
    required this.width,
    this.radius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Shimmer.fromColors(
          baseColor: Color(0xffEAEAEA),
          highlightColor: Color(0xffD4D8D8),
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(radius))),
          )),
    );
  }
}
