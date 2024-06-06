import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background map (dummy for example purposes)
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/map_background.jpeg'), // Replace with your map background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Handle tap event here
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tap 3 times on screen to alert',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  'Your contact, app users nearby, and your organization will see your request help',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14),
                ),
              ),
              const Spacer(),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Location',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notification_important),
            label: 'Notification',
          ),
        ],
        selectedItemColor: Colors.red,
        onTap: (index) {
          // Handle navigation tap
        },
      ),
    );
  }
}
