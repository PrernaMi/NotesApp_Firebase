import 'dart:math';

class UserModel {
  String name;
  String email;
  String phone;
  String gender;
  String picUrl;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.gender,
       required  this.picUrl
      });

  factory UserModel.fromDoc(Map<String, dynamic> doc) {
    return UserModel(
        name: doc['name'],
        email: doc['email'],
        phone: doc['phone'],
        picUrl: doc['picurl'],
        gender: doc['gender']);
  }

  Map<String,dynamic> toDoc(){
    return {
      'name' : name,
      'email' : email,
      'phone' :phone,
      'gender' : gender,
      'picurl': picUrl
    };
  }
}
