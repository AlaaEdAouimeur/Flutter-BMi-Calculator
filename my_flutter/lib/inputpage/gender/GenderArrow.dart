import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import 'package:my_flutter/utils/widget_utils.dart' show screenAwareSize;

const double _defaultIconAngel = math.pi / 4;

class GenderArrow extends AnimatedWidget {

  const GenderArrow({Key key, Listenable listenable}) : super(key: key,listenable: listenable);

  double _arrowLength(BuildContext context) => screenAwareSize(32.0, context);

  double _translationOffset(BuildContext context) => _arrowLength(context) * -0.4;

  @override
  Widget build(BuildContext context) {
    Animation animation = listenable;
    return Transform.rotate(
        angle: animation.value,
        child: Transform.translate(
          offset: Offset(0.0, _translationOffset(context)),
          child: Transform.rotate(
              angle: -_defaultIconAngel,
              child: SvgPicture.asset(
                "images/gender_arrow.svg",
                height: _arrowLength(context),
                width: _arrowLength(context),
              )
          ),
        )
    );
  }
}
