import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../account.dart';

class RoundButton extends StatefulWidget {

  const RoundButton({
    this.icon,
  });

  final IconData icon;

  @override
  _ButtonUserState createState() => _ButtonUserState();
}

class _ButtonUserState extends State<RoundButton> {

  bool _isPressed = false;

  // We're only really interested in down and up events,
  // for now.
  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
    if(widget.icon == Icons.chevron_left_rounded)
      Navigator.pop(context);
    else if (widget.icon == Icons.person_rounded)
      Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPage()));
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            width: 50,
            height: 50,
            margin: EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: const Color(0xff2c2f34),
              boxShadow: _isPressed ? null : [
                BoxShadow(
                  color: const Color(0xff212327),
                  offset: Offset(0.07 * 0.35 * _screenWidth / 2, 0.07 * 0.35 * _screenWidth / 2),
                  blurRadius: 0.056 * _screenWidth / 3,
                ),
              ],
            ),
          ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            width: 50,
            height: 50,
            margin: EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              gradient: LinearGradient(
                begin: Alignment(0.94, 0.92),
                end: Alignment(-0.88, -0.89),
                colors: _isPressed ? [const Color(0xff2c2f34), const Color(0xff2c2f34)] : [const Color(0xff282a2f), const Color(0xff2f3238)],
                stops: [0.0, 1.0],
              ),
              boxShadow: _isPressed ? null : [
                BoxShadow(
                  color: const Color(0xff373b41),
                  offset: Offset(-0.07 * 0.35 * _screenWidth / 2, -0.07 * 0.35 * _screenWidth / 2),
                  blurRadius: 0.056 * _screenWidth / 3,
                ),
              ],
            ),
          ),

          Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(top: 60.0, right: 20.0, left: 20.0),
            color: Colors.transparent,
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: (widget.icon == Icons.chevron_left_rounded) ? 30.0 : 25.0,
            ),
          ),

        ],
      ),
    );
  }
}