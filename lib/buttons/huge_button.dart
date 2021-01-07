import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class HugeButton extends StatefulWidget {
  const HugeButton({this.icon});

  final IconData icon;

  @override
  _HugeButtonState createState() => _HugeButtonState();
}

class _HugeButtonState extends State<HugeButton> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
    if (widget.icon == Icons.calendar_today_rounded) {
      Navigator.pushNamed(context, '/Schedule');
    } else if (widget.icon == Icons.directions_bus_rounded) {
      Navigator.pushNamed(context, '/BusPage');
    } else if (widget.icon == Icons.fastfood_rounded) {
      Navigator.pushNamed(context, '/DailyMenu');
    } else if (widget.icon == Icons.sticky_note_2_rounded) {
      Navigator.pushNamed(context, '/Grades');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Align(
        alignment: Alignment.center,
        child: Neumorphic(
          duration: const Duration(milliseconds: 80),
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(
              BorderRadius.circular(50.0),
            ),
            depth: _isPressed ? 0.0 : 5.0,
          ),
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
            width: (_screenWidth / 2) - (_screenWidth / 10),
            height: (_screenWidth / 2) - (_screenWidth / 10),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 0.35 * _screenWidth / 2,
            ),
          ),
        ),
      ),
    );
  }
}
