import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class BloodCenter {
  String name;
  String email;
  String password;
  String phone;
  String state;
  String district;
  String neighborhood;
  String image;
  String lastUpdate;
  String lat;
  String lon;
  String token;
  String status;
  int aPlus;
  int aMinus;
  int bPlus;
  int bMinus;
  int abPlus;
  int abMinus;
  int oPlus;
  int oMinus;
  BloodCenter({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
    required this.state,
    required this.district,
    required this.neighborhood,
    required this.image,
    required this.lastUpdate,
    required this.lat,
    required this.lon,
    required this.token,
    required this.status,
    required this.aPlus,
    required this.aMinus,
    required this.bPlus,
    required this.bMinus,
    required this.abPlus,
    required this.abMinus,
    required this.oPlus,
    required this.oMinus,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      BloodCenterFields.name: name,
      BloodCenterFields.email: email,
      BloodCenterFields.password: password,
      BloodCenterFields.phone: phone,
      BloodCenterFields.state: state,
      BloodCenterFields.district: district,
      BloodCenterFields.neighborhood: neighborhood,
      BloodCenterFields.image: image,
      BloodCenterFields.lastUpdate: lastUpdate,
      BloodCenterFields.lat: lat,
      BloodCenterFields.lon: lon,
      BloodCenterFields.token: token,
      BloodCenterFields.status: status,
      BloodCenterFields.aPlus: aPlus,
      BloodCenterFields.aMinus: aMinus,
      BloodCenterFields.bPlus: bPlus,
      BloodCenterFields.bMinus: bMinus,
      BloodCenterFields.abPlus: abPlus,
      BloodCenterFields.abMinus: abMinus,
      BloodCenterFields.oPlus: oPlus,
      BloodCenterFields.oMinus: oMinus,
    };
  }

  factory BloodCenter.fromMap(Map<String, dynamic> map) {
    return BloodCenter(
      name: map[BloodCenterFields.name] ?? "",
      email: map[BloodCenterFields.email] ?? "",
      password: map[BloodCenterFields.password] ?? "",
      phone: map[BloodCenterFields.phone] ?? "",
      state: map[BloodCenterFields.state] ?? "",
      district: map[BloodCenterFields.district] ?? "",
      neighborhood: map[BloodCenterFields.neighborhood] ?? "",
      image: map[BloodCenterFields.image] ?? "",
      lastUpdate: map[BloodCenterFields.lastUpdate] ?? "",
      lat: map[BloodCenterFields.lat] ?? "",
      lon: map[BloodCenterFields.lon] ?? "",
      token: map[BloodCenterFields.token] ?? "",
      status: map[BloodCenterFields.status] ?? "",
      aPlus: map[BloodCenterFields.aPlus] ?? 0,
      aMinus: map[BloodCenterFields.aMinus] ?? 0,
      bPlus: map[BloodCenterFields.bPlus] ?? 0,
      bMinus: map[BloodCenterFields.bMinus] ?? 0,
      abPlus: map[BloodCenterFields.abPlus] ?? 0,
      abMinus: map[BloodCenterFields.abMinus] ?? 0,
      oPlus: map[BloodCenterFields.oPlus] ?? 0,
      oMinus: map[BloodCenterFields.oMinus] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory BloodCenter.fromJson(String source) =>
      BloodCenter.fromMap(json.decode(source) as Map<String, dynamic>);
}

class BloodCenterFields {
  static const String collectionName = "centers";
  static const String name = "name";
  static const String email = "email";
  static const String password = "password";
  static const String phone = "phone";
  static const String state = "state";
  static const String district = "district";
  static const String neighborhood = "neighborhood";
  static const String image = "image";
  static const String lastUpdate = "last_update";
  static const String lat = "lat";
  static const String lon = "lon";
  static const String token = "token";
  static const String status = "status";
  static const String aPlus = "A+";
  static const String aMinus = "A-";
  static const String bPlus = "B+";
  static const String bMinus = "B-";
  static const String abPlus = "AB+";
  static const String abMinus = "AB-";
  static const String oPlus = "O+";
  static const String oMinus = "O-";
}
