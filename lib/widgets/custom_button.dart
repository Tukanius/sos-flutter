import 'package:flutter/material.dart';
import 'package:sos/widgets/colors.dart';

class CustomButton extends StatefulWidget {
  final Function()? onClick;
  final String labelText;
  final Color? color;
  final double height;
  final Color textColor;
  final double fontSize;
  final Color borderColor;
  final double radius;
  final FontWeight bold;
  final double? width;
  final Widget? customWidget;

  const CustomButton({
    this.onClick,
    Key? key,
    this.labelText = "",
    this.color,
    this.textColor = Colors.white,
    this.height = 48,
    this.fontSize = 12,
    this.borderColor = Colors.transparent,
    this.radius = 10,
    this.width,
    this.customWidget,
    this.bold = FontWeight.w600,
  }) : super(key: key);

  @override
  _CustomButtonState createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ElevatedButton(
        onPressed: widget.onClick,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shadowColor: white,
          primary: widget.color, // background
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(
              color: widget.borderColor,
            ),
          ),
        ),
        child: widget.customWidget ??
            Text(
              widget.labelText,
              style: TextStyle(
                color: widget.textColor,
                // fontSize: widget.fontSize,
                fontSize: 14,
                fontWeight: widget.bold,
              ),
            ),
      ),
    );
  }
}
