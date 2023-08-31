// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';

import 'RectClipper.dart';

class BeforeAfter extends StatefulWidget {
  final ImageProvider<Object> beforeImage;
  final ImageProvider<Object> afterImage;
  final double? imageHeight;
  final double? imageWidth;
  final double imageCornerRadius;
  final Color thumbColor;
  final double thumbRadius;
  final Color? overlayColor;
  final bool isVertical;

  const BeforeAfter({
    Key? key,
    required this.beforeImage,
    required this.afterImage,
    this.imageHeight,
    this.imageWidth,
    this.imageCornerRadius = 8.0,
    this.thumbColor = Colors.white,
    this.thumbRadius = 16.0,
    this.overlayColor,
    this.isVertical = false,
  })  : assert(beforeImage != null),
        assert(afterImage != null),
        super(key: key);

  @override
  _BeforeAfterState createState() => _BeforeAfterState();
}

class _BeforeAfterState extends State<BeforeAfter> {
  double _clipFactor = 0.5;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Padding(
          padding: widget.isVertical
              ? const EdgeInsets.symmetric(vertical: 0.0)
              : const EdgeInsets.symmetric(horizontal: 0.0),
          child: SizedImage(
            widget.afterImage,
            widget.imageHeight!,
            widget.imageWidth!,
            widget.imageCornerRadius,
          ),
        ),
        Padding(
          padding: widget.isVertical
              ? const EdgeInsets.symmetric(vertical: 0.0)
              : const EdgeInsets.symmetric(horizontal: 0.0),
          child: ClipPath(
            clipper: widget.isVertical
                ? RectClipperVertical(_clipFactor)
                : RectClipper(_clipFactor),
            child: SizedImage(
              widget.beforeImage,
              widget.imageHeight!,
              widget.imageWidth!,
              widget.imageCornerRadius,
            ),
          ),
        ),
        Positioned.fill(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 0.0,
              overlayColor: widget.overlayColor,
              thumbShape:
                  CustomThumbShape(widget.thumbRadius, widget.thumbColor),
            ),
            child: widget.isVertical
                ? RotatedBox(
                    quarterTurns: 1,
                    child: Slider(
                      value: _clipFactor,
                      onChanged: (double factor) =>
                          setState(() => _clipFactor = factor),
                    ),
                  )
                : Slider(
                    value: _clipFactor,
                    onChanged: (double factor) =>
                        setState(() => _clipFactor = factor),
                  ),
          ),
        ),
      ],
    );
  }
}

class SizedImage extends StatelessWidget {
  final ImageProvider<Object> _image;
  final double _height, _width, _imageCornerRadius;

  const SizedImage(
      this._image, this._height, this._width, this._imageCornerRadius,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_imageCornerRadius),
      child: SizedBox(
        height: _height,
        width: _width,
        child: Container(
          height: _height,
          width: _width,
          // child: _image,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: _image,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomThumbShape extends SliderComponentShape {
  final double _thumbRadius;
  final Color _thumbColor;

  CustomThumbShape(this._thumbRadius, this._thumbColor);

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(_thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double>? activationAnimation,
    Animation<double>? enableAnimation,
    bool? isDiscrete,
    TextPainter? labelPainter,
    RenderBox? parentBox,
    SliderThemeData? sliderTheme,
    TextDirection? textDirection,
    double? value,
    double? textScaleFactor,
    Size? sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    final Paint paint = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..color = _thumbColor
      ..style = PaintingStyle.fill;

    final Paint paintStroke = Paint()
      ..isAntiAlias = true
      ..strokeWidth = 2.0
      ..color = _thumbColor
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(
      center,
      _thumbRadius,
      paintStroke,
    );

    canvas.drawCircle(
      center,
      _thumbRadius - 8,
      paint,
    );

    canvas.drawRect(
        Rect.fromCenter(
            center: center, width: 3.0, height: parentBox!.size.height),
        paint);
  }
}
