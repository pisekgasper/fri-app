import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:fri_app/get_bus.dart';
import 'package:provider/provider.dart';
import '../account.dart';
import '../authentication_service.dart';

class RoundButton extends StatefulWidget {
  const RoundButton({this.icon, this.addMargin});

  final IconData icon;
  final bool addMargin;

  @override
  _RoundButtonState createState() => _RoundButtonState();
}

class _RoundButtonState extends State<RoundButton> {
  bool _isPressed = false;

  // We're only really interested in down and up events,
  // for now.
  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
    if (widget.icon == Icons.chevron_left_rounded)
      Navigator.pop(context);
    else if (widget.icon == Icons.person_rounded)
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AccountPage()));
    else if (widget.icon == Icons.logout) {
      context.read<AuthenticationService>().signOut();
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (widget.icon == Icons.refresh_rounded) {
      Navigator.popAndPushNamed(context, '/BusPage');
    }
  }

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Neumorphic(
        duration: const Duration(milliseconds: 80),
        margin: widget.addMargin
            ? EdgeInsets.only(
                top: _screenHeight / 15,
                right: _screenWidth / 22,
                left: _screenWidth / 22)
            : null,
        style: NeumorphicStyle(
            depth: !_isPressed ? 7.0 : 0.0,
            boxShape: NeumorphicBoxShape.circle()),
        child: Container(
          width: _screenWidth / 9,
          height: _screenHeight / 9,
          child: Icon(widget.icon,
              color: Colors.white,
              size: (widget.icon == Icons.chevron_left_rounded)
                  ? _screenHeight / 18
                  : _screenHeight / 22),
        ),
      ),
    );
  }
}
