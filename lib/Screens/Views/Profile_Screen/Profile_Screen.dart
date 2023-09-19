import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:occupier/Screens/Account_Setting/Account_Settings.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(17.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 9.0,
                          ),
                          Text(
                            'Kushal Gupta',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 35.0,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 2.0),
                            padding: EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 16.0,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 5.0),
                                Text(
                                  '4.68',
                                  style: TextStyle(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AccountSetting(),
                            ),
                          );
                        },
                        child: ClipOval(
                          child: Image(
                            image: AssetImage(
                              'assets/images/logo.jpg',
                            ),
                            fit: BoxFit.cover,
                            height: 65.0,
                            width: 65.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    height: 65.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey.shade200,
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Personal',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(width: 4.0),
                        Icon(
                          Icons.person,
                          color: Colors.black87,
                          size: 21,
                        ),
                        SizedBox(width: 180.0),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          size: 25.0,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Restore the default system UI settings when the widget is disposed
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    super.dispose();
  }
}
