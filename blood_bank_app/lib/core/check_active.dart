import 'package:blood_bank_app/domain/entities/blood_center.dart';
import 'package:blood_bank_app/domain/entities/donor.dart';
import 'package:blood_bank_app/presentation/pages/setting_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

class CheckActive {
  static Donor? currentDonor;
  static BloodCenter? currentBloodCenter;
  static final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static checkActiveUser() async {
    if (_auth.currentUser == null) {
      Hive.box(dataBoxName).put('user', "0");
    }
    String userType = Hive.box(dataBoxName).get('user') ?? "0";
    if (userType == "1") {
      await getDonorData().then((_) async {
        if (currentDonor!.state != "ACTIVE") {
          await _auth.signOut();
          await Hive.box(dataBoxName).put('user', "0");
        }
      });
    } else if (userType == "1") {
      await getCenterData().then((_) async {
        if (currentDonor!.state != "ACTIVE") {
          await _auth.signOut();
          await Hive.box(dataBoxName).put('user', "0");
        }
      });
    }
  }

  static Future<void> getDonorData() async {
    try {
      if (_auth.currentUser != null) {
        String uId = _auth.currentUser!.uid;
        await _fireStore.collection("donors").doc(uId).get().then((doc) {
          if (doc.exists) {
            currentDonor = Donor.fromMap(doc.data()!);
            print("=================currentDonor============");
            print(currentDonor!.name);
            print(doc.data());
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }

  static Future<void> getCenterData() async {
    try {
      if (_auth.currentUser != null) {
        String uId = _auth.currentUser!.uid;
        await _fireStore.collection("centers").doc(uId).get().then((doc) {
          if (doc.exists) {
            currentBloodCenter = BloodCenter.fromMap(doc.data()!);
            print("=================currentBloodCenter============");
            print(currentBloodCenter!.name);
            print(doc.data());
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }
}
