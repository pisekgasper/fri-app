import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AccentButton extends StatefulWidget {
  const AccentButton({this.text, this.width, this.height, this.loading});

  final String text;
  final double width;
  final double height;
  final bool loading;

  @override
  _AccentButtonState createState() => _AccentButtonState();
}

class _AccentButtonState extends State<AccentButton>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final _screenHeight = MediaQuery.of(context).size.height;
    final double _buttonFontSize = _screenHeight / 55;

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.elasticInOut,
      width: widget.width,
      height: widget.height,
      decoration: !widget.loading
          ? BoxDecoration(
              borderRadius: BorderRadius.circular(30.0),
              gradient: LinearGradient(
                begin: Alignment(-0.52, -1.0),
                end: Alignment(0.38, 1.0),
                colors: [
                  const Color(0xffee235a),
                  const Color(0xff9f2042),
                ],
                stops: [0.0, 1.0],
              ),
              border: Border.all(
                width: 1.0,
                color: const Color(0xffee235a),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffee235a),
                  offset: Offset(0, 0),
                  blurRadius: 7,
                ),
              ],
            )
          : null,
      alignment: Alignment.center,
      child: (widget.loading)
          ? SpinKitWave(
              color: Colors.white,
              size: _buttonFontSize,
              controller: AnimationController(
                vsync: this,
                duration: const Duration(milliseconds: 1200),
              ),
            )
          : Text(
              widget.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'SF Pro Text',
                fontSize: _buttonFontSize,
                color: Colors.white.withOpacity(1.0),
                fontWeight: FontWeight.w300,
              ),
            ),
    );
  }
}
