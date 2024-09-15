import 'package:flutter/material.dart';

class CloseButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const CloseButtonWidget({required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 20,
      left: 20,
      child: IconButton(
        icon: const Icon(Icons.close),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}