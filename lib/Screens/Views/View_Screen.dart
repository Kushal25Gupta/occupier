import 'package:flutter/material.dart';
import 'package:occupier/Screens/Views/Home_Screen.dart';
import 'package:occupier/Screens/Views/Profile_Screen/Profile_Screen.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({super.key});

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  int _selectedIndex = 0;
  List _screenList = [
    HomeScreen(),
    HomeScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          selectedLabelStyle: TextStyle(
            fontSize: 12.0,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          unselectedItemColor: Colors.black26,
          unselectedLabelStyle: TextStyle(
            fontSize: 12.0,
            color: Colors.black26,
            fontWeight: FontWeight.w500,
          ),
          currentIndex: _selectedIndex,
          elevation: 5.0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 25,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.density_small,
                size: 25,
              ),
              label: "Services",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.my_library_books_sharp,
                size: 25,
              ),
              label: "Activity",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                size: 25,
              ),
              label: "Profile",
            ),
          ],
        ),
        body: _screenList[_selectedIndex],
      ),
    );
  }
}
