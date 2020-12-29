import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'buttons/round_button.dart';

class NavBar extends StatelessWidget {
  const NavBar({
    this.title,
    this.back,
    this.user,
  });

  final String title;
  final bool back;
  final bool user;

  @override
  Widget build(BuildContext context) {
    final _screenWidth = MediaQuery.of(context).size.width;
    final _screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: _screenWidth,
      color: Colors.transparent,
      height: 130,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Align(
              alignment: Alignment.topLeft,
              child: back
                  ? RoundButton(
                      icon: Icons.chevron_left_rounded, addMargin: true)
                  : null),
          Container(
            color: Colors.transparent,
            height: 85,
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'SF Pro Display',
                fontSize: 32,
                color: const Color(0xffffffff),
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: RoundButton(
                  icon: user ? Icons.person_rounded : Icons.refresh_rounded,
                  addMargin: true)),
        ],
      ),
    );
  }
}
