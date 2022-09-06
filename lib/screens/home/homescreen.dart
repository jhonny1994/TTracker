import 'package:flutter/material.dart';
import 'package:ttracker/screens/account/account.dart';
import 'package:ttracker/screens/jobs/jobs_list.dart';

import 'package:ttracker/widgets/tab_items.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final pageOptions = [
      const JobsList(),
      const Account(),
    ];
    return Scaffold(
      body: pageOptions[_selectedIndex],
      bottomNavigationBar: myBottomNavigationBar(
        currentndex: _selectedIndex,
        onSelectTab: _onItemTapped,
      ),
    );
  }

  myBottomNavigationBar({
    required int currentndex,
    required void Function(int index) onSelectTab,
  }) {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.blueGrey,
      unselectedItemColor: Colors.grey,
      items: [
        _buildItem(TabItem.jobs),
        _buildItem(TabItem.account),
      ],
      type: BottomNavigationBarType.fixed,
      onTap: (index) => onSelectTab(index),
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem];
    return BottomNavigationBarItem(
      icon: Icon(
        itemData!.icon,
      ),
      label: itemData.title,
    );
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }
}
