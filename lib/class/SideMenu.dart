import 'package:flutter/material.dart';
import 'package:nari/bases/Appthemes.dart';
import 'package:url_launcher/url_launcher.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppThemes.background,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppThemes.bg2,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/logo.png'),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Nari',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.facebook, color: Colors.blue),
              title: Text('Facebook'),
              onTap: () => _launchURL('https://facebook.com/your-handle'),
            ),
            ListTile(
              leading: Icon(Icons.link, color: AppThemes.bg2),
              title: Text('LinkedIn'),
              onTap: () => _launchURL('https://linkedin.com/your-handle'),
            ),
            ListTile(
              leading: Icon(Icons.android, color: Colors.green),
              title: Text('GitHub'),
              onTap: () => _launchURL('https://github.com/your-handle'),
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About Us'),
              onTap: () {
                // Add about us navigation
              },
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact'),
              onTap: () {
                // Add contact navigation
              },
            ),
          ],
        ),
      ),
    );
  }
}
