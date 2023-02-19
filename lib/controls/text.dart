import 'package:flutter/material.dart';

enum TextProps { small, normal, medium, large }

class TextControl extends StatefulWidget {
  final dynamic text;
  final TextProps size;
  final bool? isBold;
  final Color? color;

  const TextControl({this.text, this.size = TextProps.normal, this.isBold = false, this.color});
  @override
  State<TextControl> createState() => _TextControlState();
}

class _TextControlState extends State<TextControl> {
  TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    switch (widget.size) {
      case TextProps.small:
        textStyle = TextStyle(
          fontSize: 8,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      case TextProps.normal:
        textStyle = TextStyle(
          fontSize: 12,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      case TextProps.medium:
        textStyle = TextStyle(
          fontSize: 16,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      case TextProps.large:
        textStyle = TextStyle(
          fontSize: 20,
          fontWeight: widget.isBold == true ? FontWeight.bold : FontWeight.normal,
          color: widget.color ?? Colors.black,
        );
        break;
      default:
    }
    return Text(
      widget.text.toString(),
      style: textStyle,
    );
  }
}
