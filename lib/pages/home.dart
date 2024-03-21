import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:social_media_app/pages/feed.dart';
import 'package:social_media_app/pages/post.dart';
import 'package:social_media_app/pages/profile.dart';
import 'package:social_media_app/pages/scanner.dart';
import 'package:social_media_app/pages/search.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  List<Widget> pages = [];
  PanelController panelController = PanelController();

  @override
  void initState() {
    pages = [
      const FeedScreen(),
      const SearchScreen(),
      const QRScannerScreen(),
      PostScreen(panelController: panelController),
      // const FavoriteScreen(),
      ProfilePage(
        targetUserEmail: FirebaseAuth.instance.currentUser!.email,
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        controller: panelController,
        minHeight: 0,
        maxHeight: MediaQuery.of(context).size.height * 0.8,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
        panelBuilder: (ScrollController sc) {
          return PostScreen(panelController: panelController);
        },
        body: pages[selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: (value) {
          setState(() {
            if (value == 3) {
              panelController.isPanelOpen
                  ? panelController.close()
                  : panelController.open();
            } else {
              selectedIndex = value;
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR Code'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Joke'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
