import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: Colors.deepPurple,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: const [
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.houseChimney),
          label: 'Accueil',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.compass),
          label: 'Discover',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.mapLocationDot),
          label: 'Map',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.users),
          label: 'Communities',
        ),
        BottomNavigationBarItem(
          icon: FaIcon(FontAwesomeIcons.commentDots),
          label: 'Chat',
        ),
      ],
    );
  }
}
