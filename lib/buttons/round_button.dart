import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:provider/provider.dart';
import '../account.dart';
import '../authentication_service.dart';

class RoundButton extends StatefulWidget {
  const RoundButton({this.icon});

  final IconData icon;

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    final double _buttonSize = _screenWidth / 9;
    final double _iconSize = _screenWidth / 16;
    final double _iconSizeLeft = _screenWidth / 14;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: (PointerUpEvent event) {
        setState(() {
          _isPressed = false;
        });
        FocusScope.of(context).unfocus();
        if (widget.icon == Icons.chevron_left_rounded)
          Navigator.pop(context);
        else if (widget.icon == Icons.person_rounded)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AccountPage()));
        else if (widget.icon == Icons.refresh_rounded)
          Navigator.popAndPushNamed(context, '/BusPage');
      },
      child: Neumorphic(
        duration: const Duration(milliseconds: 80),
        style: NeumorphicStyle(
            depth: !_isPressed ? 5.0 : 0.0,
            boxShape: NeumorphicBoxShape.circle()),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.94, 0.92),
              end: Alignment(-0.88, -0.89),
              colors: _isPressed
                  ? [const Color(0xff2c2f34), const Color(0xff2c2f34)]
                  : [const Color(0xff282a2f), const Color(0xff2f3238)],
              stops: [0.0, 1.0],
            ),
          ),
          width: _buttonSize,
          height: _buttonSize,
          child: Icon(widget.icon,
              color: Colors.white,
              size: (widget.icon == Icons.chevron_left_rounded)
                  ? _iconSizeLeft
                  : _iconSize),
        ),
      ),
    );
  }
}
