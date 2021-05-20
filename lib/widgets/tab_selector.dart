import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:give_now/models/app_tab/app_tab.dart';

class TabSelector extends StatelessWidget {
  final AppTab activeTab;
  final Function(AppTab) onTabSelected;

  const TabSelector(
      {@required this.activeTab, @required this.onTabSelected, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
      currentIndex: AppTab.values.indexOf(activeTab),
      onTap: (index) => onTabSelected(AppTab.values[index]),
      backgroundColor: Colors.white,
      items: AppTab.values
          .map((tab) => BottomNavigationBarItem(
              icon: _tabIcon(tab), label: _tabLabel(tab)))
          .toList());

  Icon _tabIcon(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return const Icon(
          Icons.show_chart,
        );
        break;
      case AppTab.profile:
        return const Icon(
          Icons.person_outline,
        );
        break;
      case AppTab.donations:
        return const Icon(
          FontAwesomeIcons.briefcase,
        );
        break;

      default:
        return const Icon(
          Icons.show_chart,
        );
        break;
    }
  }

  String _tabLabel(AppTab tab) {
    switch (tab) {
      case AppTab.home:
        return 'Home';
        break;
      case AppTab.profile:
        return 'Profile';
        break;
      case AppTab.donations:
        return 'Donations';
        break;

      default:
        return 'All';
        break;
    }
  }
}
