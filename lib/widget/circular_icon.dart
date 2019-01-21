import 'package:flutter/material.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class CircularIcon extends StatefulWidget {
  final IconData icon;
  final double radius;
  final onTap;

  CircularIcon({
    Key key,
    @required this.icon,
    @required this.radius,
    this.onTap,
  }) : super(key: key);

  @override
  _CircularIconState createState() => _CircularIconState();
}

class _CircularIconState extends State<CircularIcon> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap ?? () {},
      customBorder: CircleBorder(),
      child: CircularPercentIndicator(
        radius: widget.radius,
        lineWidth: 3.0,
        backgroundColor: Colors.white,
        center: Icon(widget.icon, color: Colors.white),
      ),
    );
  }
}
