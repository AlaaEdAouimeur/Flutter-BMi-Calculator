import 'package:flutter/material.dart';
import 'package:my_flutter/utils/widget_utils.dart' show screenAwareSize;
import 'package:my_flutter/utils/widget_utils.dart' show appBarHeight;
import 'package:my_flutter/inputpage/gender/GenderCard.dart';
import 'package:my_flutter/inputpage/weight/WeightCard.dart';
import 'package:my_flutter/inputpage/height/HeightCard.dart';
import 'package:my_flutter/appbar/BmiAppBar.dart';
import 'package:my_flutter/inputpage/gender/Gender.dart';
import 'package:my_flutter/inputpage/inputsummary/InputSummaryCard.dart';
import 'package:my_flutter/bottombar/PacmanSlider.dart';
import 'package:my_flutter/bottombar/TransitionDot.dart';
import 'package:my_flutter/resultpage/ResultPage.dart';
import 'package:my_flutter/FadeRote.dart';

class InputPage extends StatefulWidget {
  @override
  State createState() {
    return new InputPageState();
  }
}

class InputPageState extends State<InputPage> with TickerProviderStateMixin{
  Gender gender = Gender.other;
  int height = 170;
  int weight = 70;

  AnimationController submitAnimationController;


  @override
  void initState() {
    super.initState();
    submitAnimationController = AnimationController(vsync: this,duration: Duration(seconds: 2));
    submitAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _goToResultPage().then((_) => submitAnimationController.reset());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
         backgroundColor: Color(0XFF0244a1),
          appBar: PreferredSize(
              child: BmiAppBar(),
              preferredSize: Size.fromHeight(appBarHeight(context))),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InputSummaryCard(
                gender: gender,
                weight: weight,
                height: height,
              ),
              Expanded(child: _buildCards(context)),
              _buildBottom(context),
            ],
          ),
        ),
        TransitionDot(animation:submitAnimationController),
      ],
    );
  }

  Widget _buildBottom(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: screenAwareSize(16.0, context),
        right: screenAwareSize(16.0, context),
        bottom: screenAwareSize(22.0, context),
        top: screenAwareSize(14.0, context),
      ),
      child: Container(
        height: screenAwareSize(52.0, context),
        child: PacmanSlider(
          onSubmit: onPacmanSubmit,
          submitAnimationController: submitAnimationController,
        ),
      ),
    );
  }

  Widget _buildCards(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Column(
            children: <Widget>[
              Expanded(
                  child: GenderCard(
                initialGender: gender,
                onChanged: (val) => setState(() => gender = val),
              )),
              Expanded(
                  child: WeightCard(
                initialWeight: weight,
                onChanged: (val) => setState(() => weight = val),
              )),
            ],
          ),
        ),
        Expanded(
          child: HeightCard(
            height: height,
            onChanged: (val) => setState(() => height = val),
          ),
        )
      ],
    );
  }

  void onPacmanSubmit() {
    submitAnimationController.forward();
  }

  _goToResultPage() async {
    return Navigator.of(context).push(FadeRoute(
      builder: (context) => ResultPage(
        weight: weight,
        height: height,
        gender: gender,
      ),
    ));
  }

  @override
  void dispose() {
    submitAnimationController.dispose();
    super.dispose();
  }
}
