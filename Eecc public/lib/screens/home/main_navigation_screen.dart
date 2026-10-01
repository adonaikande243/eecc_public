import 'package:flutter/material.dart';
import '../../theme/eecc_theme.dart';
import '../../widgets/secondary_menu_drawer.dart';
import 'home_screen.dart';
import '../live/live_screen.dart';
import '../media/sermons_screen.dart';
import '../bible/bible_home_screen.dart';
import '../youth/jpc_screen.dart';
import '../youth/ecodim_screen.dart';
import '../profile/profile_screen.dart';

/// Navigation principale fidèle aux maquettes avec barre à 7 onglets :
/// [Accueil, Direct, Médias, Bible, JPC, Écodim, Profil]
class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;
  const MainNavigationScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      HomeScreen(onNavigateTab: _onTabSelected),
      const LiveScreen(),
      const SermonsScreen(),
      const BibleHomeScreen(),
      const JpcScreen(),
      const EcodimScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      drawer: const SecondaryMenuDrawer(),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: EeccTheme.bgWhite,
          border: Border(top: BorderSide(color: EeccTheme.borderGrey, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onTabSelected,
          type: BottomNavigationBarType.fixed,
          backgroundColor: EeccTheme.bgWhite,
          selectedItemColor: EeccTheme.navy,
          unselectedItemColor: EeccTheme.textLight,
          selectedFontSize: 11,
          unselectedFontSize: 10,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sensors),
              activeIcon: Icon(Icons.sensors, color: EeccTheme.redLive),
              label: 'Direct',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.play_circle_outline),
              activeIcon: Icon(Icons.play_circle_fill),
              label: 'Médias',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_outlined),
              activeIcon: Icon(Icons.menu_book),
              label: 'Bible',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.groups_outlined),
              activeIcon: Icon(Icons.groups),
              label: 'JPC',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.child_care_outlined),
              activeIcon: Icon(Icons.child_care),
              label: 'Écodim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
