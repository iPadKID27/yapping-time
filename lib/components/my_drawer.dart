import 'package:flutter/material.dart';
import 'package:yappingtime/auth/auth_service.dart';
import 'package:yappingtime/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
            child: Center(
              child: Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.primary,
                size: 40,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text("HOME"),
              leading: Icon(Icons.home),
              onTap: () => {
                Navigator.pop(context),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: ListTile(
              title: Text("SETTINGS"),
              leading: Icon(Icons.settings),
              onTap: () => {
                Navigator.pop(context),
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                  )
                  ),
              },
            ),
          ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, bottom: 25),
            child: ListTile(
              title: Text("LOGOUT"),
              leading: Icon(Icons.logout),
              onTap: logout,
            ),
          )
        ],
      ),
    );
  }
}
