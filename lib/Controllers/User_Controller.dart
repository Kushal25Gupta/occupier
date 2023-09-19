import 'package:occupier/Global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:occupier/Models/User.dart';
import 'package:occupier/Components/Utils.dart';
import 'package:occupier/Services/Auth_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;

class UpdateUser {
  Future<String> uploadDefaultProfilePhoto() async {
    try {
      String path = 'assets/images/Default_Profile_Photo.jpg';
      final ByteData data = await rootBundle.load(path);
      final List<int> bytes = data.buffer.asUint8List();
      final Uint8List uint8list = Uint8List.fromList(bytes);
      Reference ref =
          firebaseStorage.ref().child('ProfilePhoto').child(phoneNumber);
      UploadTask uploadTask = ref.putData(uint8list);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Utils().errorMessage(e.toString());
      return "";
    }
  }

  Future<String> uploadGoogleProfilePhoto(String photoUrl) async {
    try {
      final response = await http.get(Uri.parse(photoUrl));
      if (response.statusCode == 200) {
        final Uint8List imagebytes = response.bodyBytes;
        Reference ref =
            await firebaseStorage.ref().child('ProfilePhoto').child(userEmail);
        UploadTask uploadTask = ref.putData(imagebytes);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else {
        return "";
      }
    } catch (e) {
      Utils().errorMessage(e.toString());
      return "";
    }
  }

  Future<void> updateUserWithOTP() async {
    var snap = await fireStore
        .collection('Users')
        .doc('OTP Users')
        .collection(phoneNumber)
        .doc()
        .get();
    if (snap.exists) {
      // do nothing
    } else {
      String profilephoto = await uploadDefaultProfilePhoto();
      var currentUser = Users(
          username: phoneNumber,
          phonenumber: phoneNumber,
          profilephoto: profilephoto);
      await fireStore
          .collection('Users')
          .doc('OTP Users')
          .collection(phoneNumber)
          .doc(phoneNumber)
          .set(currentUser.toJson());
    }
  }

  Future<void> updateUserWithGoogle() async {
    var snap = await fireStore
        .collection('Users')
        .doc('Google Users')
        .collection(userEmail)
        .doc()
        .get();
    if (snap.exists) {
      // do nothing
    } else {
      String profilephoto = await AuthService().getProfileImage();
      profilephoto = await uploadGoogleProfilePhoto(profilephoto);
      if (profilephoto == "") {
        profilephoto = await uploadDefaultProfilePhoto();
      }
      var currentUser = GoogleUser(
          email: userEmail, username: userEmail, profilephoto: profilephoto);

      await fireStore
          .collection('Users')
          .doc('Google Users')
          .collection(userEmail)
          .doc(userEmail)
          .set(currentUser.toJson());
    }
  }
}
