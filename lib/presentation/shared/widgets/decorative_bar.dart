import 'package:flutter/material.dart';

class DecorativeBar extends StatelessWidget {
  const DecorativeBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5, 
      width: 40,
      margin: const EdgeInsets.only(top: 8, bottom: 5),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(10), 
      ),
    );
  }
}