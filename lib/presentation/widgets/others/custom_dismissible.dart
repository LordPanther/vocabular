// ignore_for_file: overridden_fields

import 'package:flutter/material.dart';

class CustomDismissible extends StatelessWidget {
  final Function(DismissDirection) onDismissed;
  final Widget child;
  final Icon? removeIcon;
  @override
  final Key key;

  const CustomDismissible({
    required this.key,
    required this.onDismissed,
    required this.child,
    this.removeIcon,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: key,
      direction: DismissDirection.endToStart,
      onDismissed: onDismissed,
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        decoration: const BoxDecoration(color: Color(0xFFFFE6E6)),
        child: Row(
          children: [
            const Spacer(),
            removeIcon != null ? removeIcon! : const Icon(Icons.remove),
          ],
        ),
      ),
      child: child,
    );
  }
}
