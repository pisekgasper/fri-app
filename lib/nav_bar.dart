import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'buttons/round_button.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    this.title,
    this.back,
    this.user,
    this.refresh,
  });

  final String title;
  final bool back;
  final bool user;
  final bool refresh;

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;
    final double _statusBarHeight = MediaQuery.of(context).padding.top;

    final double _headingFontSize = _screenHeight / 30;
    final double _buttonPadding = (_screenWidth / 10) / 2;

    return Container(
      width: _screenWidth,
      color: Colors.transparent,
      margin: EdgeInsets.only(
        top: _statusBarHeight + (_screenHeight / 70),
        bottom: _buttonPadding,
      ),
      height: _screenWidth / 9,
      child: Stack(
        children: [
          Visibility(
            visible: back,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: _buttonPadding),
                child: RoundButton(icon: Icons.chevron_left_rounded),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: _headingFontSize,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Visibility(
            visible: user,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: _buttonPadding),
                child: RoundButton(icon: Icons.person_rounded),
              ),
            ),
          ),
          Visibility(
            visible: refresh,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: _buttonPadding),
                child: RoundButton(icon: Icons.refresh_rounded),
              ),
            ),
          )
        ],
      ),
    );
  }
}
