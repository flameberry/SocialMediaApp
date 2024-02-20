import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FBYDrawer extends StatelessWidget {
  const FBYDrawer({super.key});

  void logoutUser() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const DrawerHeader(
                  child: Icon(Icons.favorite),
                ),

                // HOME
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text("H O M E"),
                    onTap: () {
                      // Pop the drawer
                      Navigator.pop(context);

                      // Navigate to Home
                      Navigator.pushNamed(context, "/home");
                    },
                  ),
                ),

                // PROFILE
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text("P R O F I L E"),
                    onTap: () {
                      // Pop the drawer
                      Navigator.pop(context);

                      // Navigate to Home
                      Navigator.pushNamed(context, "/profile");
                    },
                  ),
                ),
              ],
            ),

            // LOGOUT
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("L O G O U T"),
                onTap: () {
                  // Pop the drawer
                  Navigator.pop(context);

                  logoutUser();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
