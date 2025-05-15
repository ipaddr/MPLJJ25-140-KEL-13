import 'package:flutter/material.dart';

class MobileWrapper extends StatelessWidget {
  final Widget child;

  const MobileWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width < 600 ? 16 : 64),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: child,
      ),
    );
  }
}
