import 'package:anytimeworkout/views/screens/main_layout.dart';
import 'package:flutter/material.dart';

import '../../components/drawer_menu.dart';

class MoreDrawer extends StatefulWidget {
  const MoreDrawer({super.key});

  @override
  State<MoreDrawer> createState() => _MoreDrawerState();
}

class _MoreDrawerState extends State<MoreDrawer> {
  @override
  Widget build(BuildContext context) {
    return MainLayout(
      appBarVisibility: false,
      child: Container(
          width: double.infinity, child: DrawerMenu(comeFromMore: true)),
      ctx: 3,
    );
  }
}
