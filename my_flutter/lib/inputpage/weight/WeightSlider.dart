import 'package:flutter/material.dart';
import 'dart:math' as math;

class WeightSlider extends StatelessWidget {
  //最小值
  final int minValue;

  //最大值
  final int maxValue;

  //宽度
  final double width;

  final int value;
  final ValueChanged<int> onChanged;

  ScrollController scrollController;

  //显示三个数据在可视区域内
  double get itemExtent => width / 3;

  WeightSlider(
      {Key key,
      @required this.minValue,
      @required this.maxValue,
      @required this.value,
      @required this.onChanged,
      @required this.width})
      : super(key: key) {
    scrollController = new ScrollController(
      initialScrollOffset: (value - minValue) * width / 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    int itemCount = maxValue - minValue + 3;
    return new NotificationListener(
        onNotification: onNotification,
        child: ListView.builder(
            controller: scrollController,
            scrollDirection: Axis.horizontal,
            itemExtent: itemExtent,
            itemCount: itemCount,
            physics: BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final int value = indexToValue(index);
              bool isExtra = index == 0 || index == itemCount - 1;
              return isExtra
                  ? new Container()
                  : GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () => _animateTo(value, durationMillis: 50),
                      child: FittedBox(
                        child: new Text(
                          value.toString(),
                          style: getTextStyle(value),
                        ),
                        fit: BoxFit.scaleDown,
                      ),
                    );
            }));
  }

  _animateTo(int valueToSelect, {int durationMillis = 200}) {
    double targetExtent = (valueToSelect - minValue) * itemExtent;
    scrollController.animateTo(
      targetExtent,
      duration: new Duration(milliseconds: durationMillis),
      curve: Curves.decelerate,
    );
  }

  int offsetToMiddleIndex(double offset) {
    return (offset + width / 2) ~/ itemExtent;
  }

  int _offsetToMiddleValue(double offset) {
    int indexOfMiddleElement = offsetToMiddleIndex(offset);
    int middleValue = indexToValue(indexOfMiddleElement);
    middleValue = math.max(minValue, math.min(maxValue, middleValue));
    return middleValue;
  }

  bool onNotification(Notification notification) {
    if (notification is ScrollNotification) {
      int middleValue = _offsetToMiddleValue(notification.metrics.pixels);

      if (notification is ScrollEndNotification) {
        _animateTo(middleValue);
      }

      if (middleValue != value) {
        onChanged(middleValue);
      }
    }
    return true;
  }

  int indexToValue(int index) {
    return minValue + (index - 1);
  }

  TextStyle _getDefaultTextStyle() {
    return new TextStyle(
      color: Color(0xFFF4aF1B),
      fontSize: 14.0,
    );
  }

  TextStyle _getHighlightTextStyle() {
    return new TextStyle(
      color: Color.fromRGBO(77, 123, 243, 1.0),
      fontSize: 28.0,
    );
  }

  TextStyle getTextStyle(int itemValue) {
    return itemValue == value
        ? _getHighlightTextStyle()
        : _getDefaultTextStyle();
  }
}
