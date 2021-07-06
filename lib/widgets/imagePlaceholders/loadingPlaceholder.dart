import 'package:flutter/material.dart';

class LoadingAnimationFade extends StatefulWidget {
  final BoxDecoration decoration;
  final double size;

  LoadingAnimationFade([this.decoration, this.size]);

  @override
  _LoadingAnimationFadeState createState() => _LoadingAnimationFadeState();
}

class _LoadingAnimationFadeState extends State<LoadingAnimationFade>
    with TickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 1),
        lowerBound: 0.7,
        upperBound: 1)
      ..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      child: FadeTransition(
        opacity:
            _animationController.drive(CurveTween(curve: Curves.slowMiddle)),
        child: Container(
          decoration: widget.decoration != null ? widget.decoration : null,
          color: widget.decoration != null ? null : Colors.grey,
        ),
      ),
    );
  }
}
