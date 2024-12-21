class UserModel {
  String name;
  String phoneNumber;
  int age;

  UserModel({required this.name, required this.phoneNumber, required this.age});

  // Convert data to a Map for storing in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'age': age,
    };
  }

  // Convert Firestore data to UserModel object
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      phoneNumber: map['phoneNumber'],
      age: map['age'],
    );
  }

  Map<String, dynamic> tojson() {
    return {'name': name, 'phoneNumber': phoneNumber, 'age': age};
  }
}
