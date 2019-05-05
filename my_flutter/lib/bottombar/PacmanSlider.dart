import 'package:flutter/material.dart';
import 'package:my_flutter/utils/widget_utils.dart' show screenAwareSize;
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

const double _pacmanWidth = 21.0;
const double _sliderHorizontalMargin = 24.0;
const double _doytsLeftMargin = 8.0;

class PacmanSlider extends StatefulWidget {
  final VoidCallback onSubmit;
  final AnimationController submitAnimationController;

  const PacmanSlider({Key key, this.onSubmit, this.submitAnimationController})
      : super(key: key);

  @override
  _PacmanSliderState createState() {
    return _PacmanSliderState();
  }
}

class _PacmanSliderState extends State<PacmanSlider>
    with TickerProviderStateMixin {
  double _pacmanPosition = 24.0;
  AnimationController animationController;
  Animation<double> animation;

  Animation<BorderRadius> _bordersAnimation;
  Animation<double> _submitWidthAnimation;

  double get width => _submitWidthAnimation?.value ?? 0.0;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _bordersAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(8.0),
      end: BorderRadius.circular(50.0),
    ).animate(CurvedAnimation(
      parent: widget.submitAnimationController,
      curve: Interval(0.0, 0.07),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _submitWidthAnimation = Tween<double>(
        begin: constraints.maxWidth,
        end: screenAwareSize(52.0, context),
      ).animate(CurvedAnimation(
        parent: widget.submitAnimationController,
        curve: Interval(0.05, 0.15),
      ));
      return AnimatedBuilder(
          animation: widget.submitAnimationController,
          builder: (context, child) {
            Decoration decoration = BoxDecoration(
              borderRadius: _bordersAnimation.value,
              color: Color(0xFF00154F),
            );

            return Center(
              child: Container(
                height: screenAwareSize(52.0, context),
                width: width,
                decoration: decoration,
                child: _submitWidthAnimation.isDismissed
                    ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => _animatePacmanToEnd(),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            AnimatedDots(),
                            _drawDotCurtain(decoration),
                            _drawPacman(),
                          ],
                        ),
                      )
                    : Container(),
              ),
            );
          });
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget _drawDotCurtain(Decoration decoration) {
    if (width == 0) {
      return Container();
    }
    double marginRight =
        width - _pacmanPosition - screenAwareSize(_pacmanWidth / 2, context);
    return Positioned.fill(
      right: marginRight,
      child: Container(decoration: decoration),
    );
  }

  Widget _drawPacman() {
    if (animation == null && width != 0.0) {
      animation = _initPacmanAnimation(width);
    }
    return Positioned(
      left: _pacmanPosition,
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => _onPacmanDrag(width, details),
        onHorizontalDragEnd: (details) => _onPacmanDragEnd(width, details),
        child: PacmanIcon(),
      ),
    );
  }

  Animation<double> _initPacmanAnimation(double width) {
    Animation<double> animation = Tween(
      begin: _pacmanMinPosition(),
      end: _pacmanMaxPosition(width),
    ).animate(animationController);

    animation.addListener(() {
      setState(() {
        _pacmanPosition = animation.value;
      });
      if (animation.status == AnimationStatus.completed) {
        _onPacmanSubmited();
      }
    });
    return animation;
  }

  _onPacmanSubmited() {
    widget?.onSubmit();
    Future.delayed(Duration(seconds: 1), () => _resetPacman());
  }

  _onPacmanDragEnd(double width, DragEndDetails details) {
    bool isOverHalf =
        _pacmanPosition + screenAwareSize(_pacmanWidth / 2, context) >
            width * 0.5;
    if (isOverHalf) {
      _animatePacmanToEnd(width: width);
    } else {
      _resetPacman();
    }
  }

  _animatePacmanToEnd({double width}) {
    animationController.forward(
        from: _pacmanPosition / _pacmanMaxPosition(width));
  }

  _resetPacman() {
    setState(() {
      _pacmanPosition = _pacmanMinPosition();
    });
  }

  _onPacmanDrag(double width, DragUpdateDetails details) {
    setState(() {
      _pacmanPosition += details.delta.dx;
      _pacmanPosition = math.max(_pacmanMinPosition(),
          math.min(_pacmanMaxPosition(width), _pacmanPosition));
    });
  }

  double _pacmanMinPosition() {
    return screenAwareSize(_sliderHorizontalMargin, context);
  }

  double _pacmanMaxPosition(double width) {
    return width -
        screenAwareSize(_sliderHorizontalMargin / 2 + _pacmanWidth, context);
  }
}

class AnimatedDots extends StatefulWidget {
  @override
  _AnimatedDotsState createState() {
    return _AnimatedDotsState();
  }
}

class _AnimatedDotsState extends State<AnimatedDots>
    with TickerProviderStateMixin {
  final int numOfDots = 10;
  final double minOpacity = 0.1;
  final double maxOpacity = 0.5;

  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    initAnimationController();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  initAnimationController() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(Duration(milliseconds: 800), () {
          animationController.forward(from: 0.0);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: screenAwareSize(
              _sliderHorizontalMargin + _pacmanWidth + _doytsLeftMargin,
              context),
          right: screenAwareSize(_sliderHorizontalMargin, context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(numOfDots, _generateDot)
          ..add(Opacity(
            opacity: maxOpacity,
            child: Dot(size: 14.0),
          )),
      ),
    );
  }

  Widget _generateDot(int dotNumber) {
    Animation animation = _initDotAnimation(dotNumber);
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) =>
          Opacity(opacity: animation.value, child: child),
      child: Dot(size: 9.0),
    );
  }

  Animation<double> _initDotAnimation(int dotNum) {
    double lastDotStartTime = 0.3;
    double dotAnimationDuration = 0.6;
    double begin = lastDotStartTime * dotNum / numOfDots;
    double end = begin + dotAnimationDuration;
    return SinusoidalAnimation(min: minOpacity, max: maxOpacity)
        .animate(CurvedAnimation(
      parent: animationController,
      curve: Interval(begin, end),
    ));
  }
}

class Dot extends StatelessWidget {
  final double size;

  const Dot({Key key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenAwareSize(size, context),
      width: screenAwareSize(size, context),
      decoration: BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF4aF1B)),
    );
  }
}

class PacmanIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: screenAwareSize(16.0, context)),
      child: SvgPicture.asset(
        "images/pacman.svg",
        height: screenAwareSize(25.0, context),
        width: screenAwareSize(21.0, context),
      ),
    );
  }
}

class SinusoidalAnimation extends Animatable<double> {
  SinusoidalAnimation({this.min, this.max});

  final double min;
  final double max;

  @protected
  double lerp(double t) {
    return min + (max - min) * math.sin(math.pi * t);
  }

  @override
  double transform(double t) {
    return (t == 0.0 || t == 1.0) ? min : lerp(t);
  }
}
