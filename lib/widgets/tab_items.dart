import 'package:flutter/material.dart';

enum TabItem { jobs, entries, account }

class TabItemData {
  final String title;
  final IconData icon;

  TabItemData(this.title, this.icon);
  static Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData('Jobs', Icons.work),
    TabItem.entries: TabItemData('Entries', Icons.view_headline),
    TabItem.account: TabItemData('Account', Icons.person),
  };
}
