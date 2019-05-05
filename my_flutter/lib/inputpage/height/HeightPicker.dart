import 'package:flutter/material.dart';
import 'HeightSlider.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;
import 'package:my_flutter/utils/widget_utils.dart' show screenAwareSize;

const TextStyle labelsTextStyle = const TextStyle(
  color: labelsGrey,
  fontSize: labelsFontSize,
);

const double labelsFontSize = 13.0;

const Color labelsGrey = Color.fromRGBO(77, 123, 243, 1.0) ;

const double circleSize = 32.0;
const double marginBottom = circleSize / 2;
const double marginTop = 26.0;

double marginBottomAdapted(BuildContext context) =>
    screenAwareSize(marginBottom, context);

double marginTopAdapted(BuildContext context) =>
    screenAwareSize(marginTop, context);

class HeightPicker extends StatefulWidget {
  final int maxHeight;

  final int minHeight;

  final int height;

  final double widgetHeight;

  //数据变化的回调
  final ValueChanged<int> onChange;

  int get totalUnits => maxHeight - minHeight;

  const HeightPicker(
      {Key key,
      this.height,
      this.widgetHeight,
      this.onChange,
      this.maxHeight = 190,
      this.minHeight = 145})
      : super(key: key);

  @override
  _HeightPickerState createState() {
    return _HeightPickerState();
  }
}

class _HeightPickerState extends State<HeightPicker> {

  double startDragYOffset;

  int startDragHeight;

  double get _drawingHeight {
    double totalHeight = widget.widgetHeight;
    double marginBottom = marginBottomAdapted(context);
    double marginTop = marginTopAdapted(context);
    return totalHeight - (marginBottom + marginTop + labelsFontSize);
  }

  double get _pixelsPerUnit {
    return _drawingHeight / widget.totalUnits;
  }

  double get _sliderPosition {
    double halfOfBottomLabel = labelsFontSize / 2;
    int unitsFromBottom = widget.height - widget.minHeight;
    return halfOfBottomLabel + unitsFromBottom * _pixelsPerUnit;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: _onTapDown,
      onVerticalDragStart: _onVerticalDragStart,
      onVerticalDragUpdate: _onVerticalDragUpdate,
      child: Stack(
        children: <Widget>[
          _drawSlider(),
          _drawLabels(),
          _drawPersonImage(),
        ],
      ),
    );
  }

  _onVerticalDragStart(DragStartDetails details){
    int newHeight = _globalOffsetToHeight(details.globalPosition);
    widget.onChange(newHeight);
    setState(() {
      startDragYOffset = details.globalPosition.dy;
      startDragHeight = newHeight;
    });
  }

  _onVerticalDragUpdate(DragUpdateDetails details){
    double currentYOffset = details.globalPosition.dy;
    double verticalDifference = startDragYOffset - currentYOffset;
    int diffHeight = verticalDifference ~/ _pixelsPerUnit;
    int height = _normalizedHeight(startDragHeight+diffHeight);
    setState(() {
      widget.onChange(height);
    });
  }

  _onTapDown(TapDownDetails details){
    int height = _globalOffsetToHeight(details.globalPosition);
    widget.onChange(_normalizedHeight(height));
  }

  int _normalizedHeight(int height){
    return math.max(widget.minHeight, math.min(widget.maxHeight, height));
  }

  int _globalOffsetToHeight(Offset globalOffset){
    RenderBox renderBox = context.findRenderObject();
    Offset localPosition = renderBox.globalToLocal(globalOffset);
    double dy = localPosition.dy;
    dy = dy - marginTopAdapted(context) - labelsFontSize / 2;
    int height = widget.maxHeight - (dy ~/ _pixelsPerUnit);
    return height;
  }

  Widget _drawPersonImage() {
    double personImageHeight = _sliderPosition + marginBottomAdapted(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SvgPicture.asset(
        "images/person.svg",
        height: personImageHeight,
        width: personImageHeight / 3,
      ),
    );
  }

  Widget _drawSlider() {
    return Positioned(
      child: HeightSlider(
        height: widget.height,
      ),
      left: 0.0,
      right: 0.0,
      bottom: _sliderPosition,
    );
  }

  /// 绘制右侧的身高列表，~/ - 除法操作符，返回除法的取整结果
  Widget _drawLabels() {
    int labelsToDisplay = widget.totalUnits ~/ 5 + 1;
    List<Widget> labels = List.generate(labelsToDisplay, (idx) {
      return Text(
        "${widget.maxHeight - 5 * idx}",
        style: labelsTextStyle,
      );
    });

    return Align(
      alignment: Alignment.centerRight,
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.only(
              top: marginTopAdapted(context),
              bottom: marginBottomAdapted(context),
              right: screenAwareSize(12.0, context)),
          child: Column(
            children: labels,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
      ),
    );
  }
}
