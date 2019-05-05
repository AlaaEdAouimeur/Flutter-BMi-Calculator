import 'package:flutter/material.dart';
import 'package:my_flutter/utils/widget_utils.dart' show screenAwareSize;
import 'package:my_flutter/widget/CardTitle.dart';
import 'Gender.dart';
import 'package:my_flutter/inputpage/gender/GenderIcon.dart';
import 'package:my_flutter/inputpage/gender/GenderArrow.dart';
import 'dart:math' as math;

double _circleSize(BuildContext context) {
  return screenAwareSize(80.0, context);
}

const double _defaultIconAngel = math.pi / 4;

const Map<Gender, double> genderAngels = {
  Gender.female: -_defaultIconAngel,
  Gender.other: 0,
  Gender.male: _defaultIconAngel
};

class GenderCard extends StatefulWidget {
  final Gender initialGender;
  final ValueChanged<Gender> onChanged;

  const GenderCard({Key key, this.initialGender,this.onChanged}) : super(key: key);

  @override
  _GenderCardState createState() {
    return _GenderCardState();
  }
}

class _GenderCardState extends State<GenderCard> with SingleTickerProviderStateMixin {
  AnimationController _arrowAnimationController;
  Gender selectedGender;

  @override
  void initState() {
    selectedGender = widget.initialGender ?? Gender.other;
    _arrowAnimationController = new AnimationController( //<--- initialize animation controller
      vsync: this,
      lowerBound: -_defaultIconAngel,
      upperBound: _defaultIconAngel,
      value: genderAngels[selectedGender],
    );
    super.initState();
  }

  @override
  void dispose() {
    _arrowAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(top: screenAwareSize(8.0, context)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CardTitle("Gender"),
              Padding(
                padding: EdgeInsets.only(top: screenAwareSize(16.0, context)),
                child: _drawMainStack(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawMainStack(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        _drawCircleIndicator(context),
        GenderIconTranslated(gender: Gender.female),
        GenderIconTranslated(gender: Gender.other),
        GenderIconTranslated(gender: Gender.male),
        _drawGestureDetector(),
      ],
    );
  }

  Widget _drawCircleIndicator(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        GenderCircle(),
        GenderArrow(listenable: _arrowAnimationController),
      ],
    );
  }

  _drawGestureDetector() {
    return Positioned.fill(
      child: TapHandler(
        onGenderTapped: _setSelectedGender,
      ),
    );
  }

  void _setSelectedGender(Gender gender) {
    widget.onChanged(gender);
    setState(() {
      selectedGender = gender;
    });
    _arrowAnimationController.animateTo(
      genderAngels[gender],
      duration: Duration(milliseconds: 150),
    );
  }
}

class GenderCircle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: _circleSize(context),
      height: _circleSize(context),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF00154F),
      ),
    );
  }
}

class TapHandler extends StatelessWidget {
  final Function(Gender) onGenderTapped;

  const TapHandler({Key key, this.onGenderTapped}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: GestureDetector(onTap: () => onGenderTapped(Gender.female))),
        Expanded(
            child: GestureDetector(onTap: () => onGenderTapped(Gender.other))),
        Expanded(
            child: GestureDetector(onTap: () => onGenderTapped(Gender.male))),
      ],
    );
  }
}
