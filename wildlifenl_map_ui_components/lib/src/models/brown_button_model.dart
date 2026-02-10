import 'package:flutter/material.dart';

class BrownButtonModel {
  static const double defaultButtonHeight = 48.0;
  static const double defaultArrowIconSize = 24.0;
  static const double defaultRegularIconSize = 38.0;
  static const double defaultLeftIconPadding = 0.0;
  static const double defaultElevation = 4.0;

  final String? text;
  final String? rightIconPath;
  final String? leftIconPath;
  final double rightIconSize;
  final double leftIconSize;
  final double height;
  final double? width;
  final double? fontSize;
  final double leftIconPadding;
  final double elevation;
  final Color? backgroundColor;

  BrownButtonModel({
    this.text,
    this.rightIconPath,
    this.leftIconPath,
    double? rightIconSize,
    double? leftIconSize,
    double? height,
    this.width,
    this.fontSize,
    double? leftIconPadding,
    double? elevation,
    this.backgroundColor,
  })  : rightIconSize =
            rightIconSize ??
            (rightIconPath?.contains('arrow') == true
                ? defaultArrowIconSize
                : defaultRegularIconSize),
        leftIconSize = leftIconSize ?? defaultRegularIconSize,
        height = height ?? defaultButtonHeight,
        leftIconPadding = leftIconPadding ?? defaultLeftIconPadding,
        elevation = elevation ?? defaultElevation;

  Map<String, dynamic> toMap() => {
        'text': text,
        'rightIconPath': rightIconPath,
        'leftIconPath': leftIconPath,
        'rightIconSize': rightIconSize,
        'leftIconSize': leftIconSize,
        'height': height,
        'width': width,
        'fontSize': fontSize,
        'leftIconPadding': leftIconPadding,
        'elevation': elevation,
        'backgroundColor': backgroundColor,
      };

  factory BrownButtonModel.fromMap(Map<String, dynamic> map) {
    return BrownButtonModel(
      text: map['text'] as String?,
      rightIconPath: map['rightIconPath'] as String?,
      leftIconPath: map['leftIconPath'] as String?,
      rightIconSize: map['rightIconSize'] as double?,
      leftIconSize: map['leftIconSize'] as double?,
      height: map['height'] as double?,
      width: map['width'] as double?,
      fontSize: map['fontSize'] as double?,
      leftIconPadding: map['leftIconPadding'] as double?,
      elevation: map['elevation'] as double?,
      backgroundColor: map['backgroundColor'] as Color?,
    );
  }

  @override
  String toString() =>
      'BrownButtonModel(text: $text, rightIconPath: $rightIconPath, leftIconPath: $leftIconPath)';
}
