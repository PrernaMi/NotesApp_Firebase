class UserModel {
  String name;
  String email;
  String phone;
  String gender;

  UserModel(
      {required this.name,
      required this.email,
      required this.phone,
      required this.gender});

  factory UserModel.fromDoc(Map<String, dynamic> doc) {
    return UserModel(
        name: doc['name'],
        email: doc['email'],
        phone: doc['phone'],
        gender: doc['gender']);
  }

  Map<String,dynamic> toDoc(){
    return {
      'name' : name,
      'email' : email,
      'phone' :phone,
      'gender' : gender
    };
  }
}
