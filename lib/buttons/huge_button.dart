import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HugeButton extends StatefulWidget {
  const HugeButton({
    this.icon,
  });

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
    if (widget.icon == Icons.calendar_today_rounded) {
      Navigator.pushNamed(context, '/Schedule');
    } else if (widget.icon == Icons.directions_bus_rounded) {
      Navigator.pushNamed(context, '/BusPage');
    } else if (widget.icon == Icons.fastfood_rounded) {
      Navigator.pushNamed(context, '/DailyMenu');
    }
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
            width: 0.35 * _screenWidth,
            height: 0.35 * _screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              color: const Color(0xff2c2f34),
              boxShadow: _isPressed
                  ? null
                  : [
                      BoxShadow(
                        color: const Color(0xff212327),
                        offset: Offset(0.07 * 0.35 * _screenWidth,
                            0.07 * 0.35 * _screenWidth),
                        blurRadius: 0.056 * _screenWidth,
                      ),
                    ],
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 70),
            width: 0.35 * _screenWidth,
            height: 0.35 * _screenWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40.0),
              gradient: LinearGradient(
                begin: Alignment(0.94, 0.92),
                end: Alignment(-0.88, -0.89),
                colors: _isPressed
                    ? [const Color(0xff2c2f34), const Color(0xff2c2f34)]
                    : [const Color(0xff282a2f), const Color(0xff2f3238)],
                stops: [0.0, 1.0],
              ),
              boxShadow: _isPressed
                  ? null
                  : [
                      BoxShadow(
                        color: const Color(0xff373b41),
                        offset: Offset(-0.07 * 0.35 * _screenWidth,
                            -0.07 * 0.35 * _screenWidth),
                        blurRadius: 0.056 * _screenWidth,
                      ),
                    ],
            ),
          ),
          Container(
            width: 0.50 * _screenWidth / 2,
            height: 0.50 * _screenWidth / 2,
            color: Colors.transparent,
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: 0.35 * _screenWidth / 2,
            ),
          ),
        ],
      ),
    );
  }
}
