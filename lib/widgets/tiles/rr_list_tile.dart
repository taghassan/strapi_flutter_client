import 'package:flutter/cupertino.dart';

class RRShape extends StatelessWidget {
  final BorderRadius borderRadius;
  final Widget child;

  const RRShape({Key key, this.borderRadius, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(6),
      child: child,
    );
  }
}
