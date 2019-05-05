import 'package:flutter/material.dart';
import 'package:my_flutter/utils/widget_utils.dart' show screenAwareSize;

class GenderLine extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top:screenAwareSize(8.0, context),
        bottom: screenAwareSize(6.0, context)
      ),
      child: Container(
        height: screenAwareSize(8.0, context),
        width: 1.0,
        color: Color(0xFFF4aF1B),
      ),
    );
  }
}