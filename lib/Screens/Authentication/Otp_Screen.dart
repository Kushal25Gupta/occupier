import 'dart:async';
import 'package:pinput/pinput.dart';
import 'package:occupier/Global.dart';
import 'package:flutter/material.dart';
import 'package:occupier/Components/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:occupier/Screens/Views/View_Screen.dart';
import 'package:occupier/Controllers/User_Controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

// ignore: must_be_immutable
class OtpScreen extends StatefulWidget {
  late String verificationId;
  OtpScreen({required this.verificationId, super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  int _seconds = 30;
  late Timer _timer;
  late String _userOtp;
  bool _showLogIn = false;
  bool _showLoader = false;
  final Utils utils = Utils();

  Future<void> resendVerificationCode() async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: Duration(seconds: 30),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _showLoader = false;
          });
          utils.errorMessage('Verification failed please try again');
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            widget.verificationId = verificationId;
            _seconds = 30; // Reset the timer
            _showLoader = false;
          });
          _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      setState(() {
        _showLoader = false;
      });
      utils.errorMessage('Error sending verification code: $e');
    }
  }

  Future<void> verifyOtp(String verificationid) async {
    try {
      final creds = PhoneAuthProvider.credential(
        verificationId: verificationid,
        smsCode: _userOtp,
      );
      User? user = (await firebaseAuth.signInWithCredential(creds)).user;
      print(creds);
      if (user != null) {
        await UpdateUser().updateUserWithOTP();
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ViewScreen(),
          ),
        );
        setState(() {
          _showLoader = false;
          _showLogIn = false;
        });
      } else {
        print('Hello sisterfucker');
      }
    } catch (e) {
      setState(() {
        _showLoader = false;
        _showLogIn = false;
      });
      utils.errorMessage("You've entered Incorrect OTP. Please try again");
    }
  }

  _updateTimer(Timer timer) {
    if (_seconds > 0) {
      setState(() {
        _seconds--;
      });
    } else {
      _timer.cancel();
    }
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), _updateTimer);
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _showLoader,
      child: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 1.0,
            shadowColor: Colors.black54,
            leading: InkWell(
              onTap: () {
                setState(() {
                  _showLoader = false;
                });
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
            ),
            backgroundColor: Colors.white,
            title: Text(
              'Login / SignUp',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 17.0,
              ),
            ),
          ),
          body: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Column(
                children: [
                  SizedBox(height: 55.0),
                  Text(
                    'Enter verification code',
                    style: TextStyle(
                      fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12.0),
                  Text(
                    'We have send you a 6 digit verification code on',
                    style: TextStyle(
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 7.0),
                  Text(
                    '${phoneNumber}',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 25.0),
                    child: Pinput(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      length: 6,
                      showCursor: false,
                      closeKeyboardWhenCompleted: true,
                      focusedPinTheme: PinTheme(
                        width: 45,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.blueAccent.shade700),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      defaultPinTheme: PinTheme(
                        width: 45,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(color: Colors.black26),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 20,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onCompleted: (value) async {
                        setState(() {
                          _userOtp = value;
                          _showLogIn = true;
                          _showLoader = true;
                        });
                        await verifyOtp(widget.verificationId);
                      },
                      onChanged: (value) {
                        setState(() {
                          _showLogIn = false;
                        });
                      },
                    ),
                  ),
                  SizedBox(height: 15.0),
                  _seconds == 0
                      ? Column(
                          children: [
                            Text(
                              'Time elapsed.',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Container(
                              height: 40.0,
                              width: 115.0,
                              margin: EdgeInsets.only(top: 12.0, bottom: 30.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                border: Border.all(
                                  color: Colors.black87,
                                ),
                              ),
                              child: TextButton(
                                onPressed: () async {
                                  setState(() {
                                    _showLoader = true;
                                  });
                                  await resendVerificationCode();
                                },
                                child: const Text(
                                  'Resend Code',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Text(
                          '0:$_seconds',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Colors.green,
                          ),
                        ),
                ],
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                height: 55.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showLogIn ? Colors.indigo : Colors.grey,
                  ),
                  onPressed: () async {
                    if (_showLogIn) {
                      setState(() {
                        _showLoader = true;
                      });
                      await verifyOtp(widget.verificationId);
                    }
                  },
                  child: Text(
                    'Log in',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
