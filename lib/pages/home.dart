import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:social_media_app/pages/feed.dart';
import 'package:social_media_app/pages/geolocation.dart';
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
      const LocationServices(),
      PostScreen(panelController: panelController),
      // const FavoriteScreen(),
      ProfilePage(
        targetUserEmail: FirebaseAuth.instance.currentUser!.email,
      ),
    ];

    super.initState();

    ShakeDetector _ = ShakeDetector.autoStart(
      onPhoneShake: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'You have shaken the phone! Is there some problem with the app?'),
            showCloseIcon: true,
            dismissDirection: DismissDirection.down,
            // duration: Durations.extralong4,
          ),
        );
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
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
            if (value == 4) {
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
          BottomNavigationBarItem(
              icon: Icon(Icons.location_pin), label: 'Location'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Joke'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
