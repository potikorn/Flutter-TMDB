import 'package:flutter/material.dart';

class AccentColorOverride extends StatelessWidget {
  const AccentColorOverride({Key key, this.color, this.child})
      : super(key: key);

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Theme(
      child: child,
      data: Theme.of(context).copyWith(
        primaryColor: color,
        hintColor: color,
        accentColor: color,
        cursorColor: color,
      ),
    );
  }
}
