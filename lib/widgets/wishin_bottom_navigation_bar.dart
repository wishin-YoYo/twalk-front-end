import 'package:flutter/material.dart';

class WishinBottomNavigaionBar extends StatelessWidget {
  const WishinBottomNavigaionBar(
      {Key? key, required this.pageIndex, required this.changePage})
      : super(key: key);

  final pageIndex;
  final changePage;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        iconSize: 40,
        currentIndex: pageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.local_fire_department_outlined), label: 'PvP'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined), label: 'Map'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: 'MyPage'),
        ],
        onTap: (i) {
          changePage(i);
        });
  }
}
