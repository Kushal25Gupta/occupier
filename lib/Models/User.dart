import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String username;
  String phonenumber;
  String profilephoto;

  Users({
    required this.username,
    required this.phonenumber,
    required this.profilephoto,
  });

  Map<String, dynamic> toJson() => {
        'username': username,
        'phonenumber': phonenumber,
        'profilephoto': profilephoto
      };

  static Users fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return Users(
      username: snap['username'],
      phonenumber: snap['phonenumber'],
      profilephoto: snap['profilephoto'],
    );
  }
}

class GoogleUser {
  String email;
  String username;
  String profilephoto;

  GoogleUser({
    required this.email,
    required this.username,
    required this.profilephoto,
  });

  Map<String, dynamic> toJson() =>
      {'email': email, 'username': username, 'profilephoto': profilephoto};

  static GoogleUser fromSnap(DocumentSnapshot snapshot) {
    var snap = snapshot.data() as Map<String, dynamic>;
    return GoogleUser(
      email: snap['email'],
      username: snap['username'],
      profilephoto: snap['profilephoto'],
    );
  }
}
