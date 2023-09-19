import 'Otp_Screen.dart';
import 'package:occupier/Global.dart';
import 'package:flutter/material.dart';
import 'package:occupier/Components/Utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:country_picker/country_picker.dart';
import 'package:occupier/Services/Auth_service.dart';
import 'package:occupier/Screens/Views/View_Screen.dart';
import 'package:occupier/Controllers/User_Controller.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showLoader = false;
  bool _isFocused = false;
  String _phoneNumber = "";
  final Utils utils = Utils();
  final _focusNode = FocusNode();
  bool _validatePhoneNumber = false;

  Country selectedCountry = Country(
    phoneCode: "91",
    countryCode: "IN",
    e164Sc: 0,
    geographic: true,
    level: 1,
    name: "India",
    example: "India",
    displayName: "India",
    displayNameNoCountryCode: "IN",
    e164Key: "",
  );

  Future<void> signInWithPhoneNumber(String phonenumber) async {
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phonenumber,
        timeout: const Duration(seconds: 30),
        verificationCompleted: (_) {},
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            _showLoader = false;
          });
          String errorMessage = "Verification failed. Please try again.";
          if (e.code == 'invalid-phone-number') {
            errorMessage = "Invalid phone number. Please enter a valid number.";
          } else if (e.code == 'too-many-requests') {
            errorMessage = "Too many requests. Please try again later.";
          }
          utils.errorMessage(errorMessage);
        },
        codeSent: (String verificationId, int? token) async {
          setState(() {
            _validatePhoneNumber = false;
          });
          phoneNumber = _phoneNumber;
          id = verificationId;
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OtpScreen(verificationId: verificationId),
            ),
          );
          setState(() {
            _showLoader = false;
          });
        },
        codeAutoRetrievalTimeout: (_) {
          setState(() {
            _showLoader = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _showLoader = false;
        utils.errorMessage("Verification failed: Try again later");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        setState(() {
          _isFocused = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          _isFocused = false;
        });
        return true;
      },
      child: ModalProgressHUD(
        inAsyncCall: _showLoader,
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 60.0,
                    width: 60.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5.0),
                      child: const Image(
                        image: AssetImage('assets/images/logo.jpg'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Text(
                    'Occupier',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              const Column(
                children: [
                  Text(
                    'Your Time Saving Expert',
                    style: TextStyle(
                      fontSize: 17.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    'Quick • Accurate • Trusted',
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30.0),
              Column(
                children: [
                  Container(
                    height: 55.0,
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            height: 55.0,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: Colors.grey.shade300,
                            ),
                            child: InkWell(
                              onTap: () {
                                showCountryPicker(
                                    context: context,
                                    countryListTheme:
                                        const CountryListThemeData(
                                            bottomSheetHeight: 550),
                                    onSelect: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    selectedCountry.flagEmoji,
                                    style: const TextStyle(
                                      fontSize: 40.0,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_drop_down_outlined),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            focusNode: _focusNode,
                            keyboardType: TextInputType.number,
                            cursorColor: Colors.black,
                            showCursor: _isFocused,
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            decoration: InputDecoration(
                              fillColor: _isFocused == true
                                  ? Colors.white
                                  : Colors.grey.shade300,
                              filled: true,
                              hintText: 'Mobile Number',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    BorderSide(color: Colors.grey.shade300),
                              ),
                              focusedBorder: _isFocused
                                  ? OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: const BorderSide(
                                          color: Colors.black, width: 2.0),
                                    )
                                  : InputBorder.none,
                              prefixIcon: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 13.0),
                                child: Text(
                                  '+${selectedCountry.phoneCode}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _isFocused = true;
                              });
                            },
                            onTapOutside: (_) {
                              final currentFocus = FocusScope.of(context);
                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (mounted) {
                                setState(() {
                                  _isFocused = false;
                                });
                              }
                            },
                            onFieldSubmitted: (value) async {
                              setState(() {
                                _phoneNumber =
                                    '+${selectedCountry.phoneCode}$value';
                              });
                              if (value.length == 10) {
                                try {
                                  setState(() {
                                    _showLoader = true;
                                    _validatePhoneNumber = false;
                                  });
                                  await signInWithPhoneNumber(_phoneNumber);
                                } catch (e) {
                                  setState(() {
                                    _showLoader = false;
                                  });
                                  utils.errorMessage('Network Error');
                                }
                              } else {
                                setState(() {
                                  _validatePhoneNumber = true;
                                  _showLoader = false;
                                });
                              }
                            },
                            onChanged: (value) {
                              setState(() {
                                _validatePhoneNumber = false;
                                _phoneNumber = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_validatePhoneNumber)
                    Container(
                      padding: const EdgeInsets.only(left: 20.0, top: 5.0),
                      child: Text(
                        'This phone number is invalid',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: 14.0,
                        ),
                      ),
                    ),
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0),
                    height: 55.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black,
                    ),
                    child: InkWell(
                      onTap: () async {
                        if (_phoneNumber.length == 10) {
                          try {
                            setState(() {
                              _phoneNumber =
                                  "+${selectedCountry.phoneCode}$_phoneNumber";
                              _showLoader = true;
                              _validatePhoneNumber = false;
                            });
                            await signInWithPhoneNumber(_phoneNumber);
                          } catch (e) {
                            setState(() {
                              _showLoader = false;
                            });
                            utils.errorMessage('Network Error');
                          }
                        } else {
                          setState(() {
                            _showLoader = false;
                            _validatePhoneNumber = true;
                          });
                        }
                      },
                      child: const Center(
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                child: const Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black, // Color of the line
                        height: 2.0, // Height of the line
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black, // Color of the line
                        height: 2.0, // Height of the line
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 55.0,
                width: MediaQuery.of(context).size.width,
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: InkWell(
                  onTap: () async {
                    try {
                      setState(() {
                        _showLoader = true;
                      });
                      final account = await AuthService().signInWithGoogle();
                      if (account != null) {
                        setState(() {
                          userEmail = account.email ?? "";
                        });
                        await UpdateUser().updateUserWithGoogle();
                        // ignore: use_build_context_synchronously
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ViewScreen(),
                          ),
                        );
                      }
                      setState(() {
                        _showLoader = false;
                      });
                    } catch (e) {
                      GoogleSignIn().signOut();
                      setState(() {
                        _showLoader = false;
                      });
                    }
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5.0, vertical: 15.0),
                        child: Image.asset(
                          ('assets/images/Google_logo.png'),
                        ),
                      ),
                      const Text(
                        'Continue With Google',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
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
