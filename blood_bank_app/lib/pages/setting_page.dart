import 'package:blood_bank_app/models/donor.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../widgets/forms/my_switchlist_tile.dart';
import '../widgets/setting/select_photo_options_screen.dart';
import '../widgets/setting/profile_body.dart';
import '../widgets/setting/display_image.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

// Table name data user in hive database
const String dataBoxName = "dataProfile";

class SettingPage extends StatefulWidget {
  static const String routeName = "setting";
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  File? _image;
  Donor? donor;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Box? dataBox;

  Future<void> putDataTodataProfileTable() async {
    // var box = await Hive.openBox(dataBoxName);

    dataBox = Hive.box(dataBoxName);

    try {
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _fireStore
            .collection('donors')
            .doc("H5PPBI8VBBNikBYvmifb")
            .get()
            .then((value) async {
          print(value.data());
          print("object+++++++++++++++++++++");
          print(currentUser.uid);
          donor = Donor.fromMap(value.data()!);
          print("------------------------");
          print(donor!.email);
          await dataBox!.add(donor!);
          print("=======================");
          // print(dataBox!.get("data_profile"));
        });
      } else {
        print("error 1");
      }
    } catch (e) {
      print("error 2");
    }
  }

  Future _pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;
      File? img = File(image.path);
      img = await _cropImage(imageFile: img);
      setState(() {
        _image = img;
        print(_image);
        Navigator.of(context).pop();
      });
    } on PlatformException catch (e) {
      print(e);
      Navigator.of(context).pop();
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  void _showSelectPhotoOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        ),
      ),
      builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.28,
          maxChildSize: 0.4,
          minChildSize: 0.28,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              child: SelectPhotoOptionsScreen(
                onTap: _pickImage,
              ),
            );
          }),
    );
  }

  PermissionStatus? _permissionStatus;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      Hive.openBox(dataBoxName);
    });

    () async {
      _permissionStatus = await Permission.storage.status;

      if (_permissionStatus != PermissionStatus.granted) {
        print("object+++++++++++");
        PermissionStatus permissionStatus = await Permission.storage.request();
        setState(() {
          _permissionStatus = permissionStatus;
        });
      }
    }();
  }

  void permission() async {
    if (_permissionStatus != PermissionStatus.granted) {
      if (await Permission.storage.request().isDenied) {
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    permission();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
          ),
          InkWell(
            onTap: () {
              // _showSelectPhotoOptions(context);
              putDataTodataProfileTable();
            },
            child: DisplayImage(
              imagePath: _image ?? "assets/images/1.jpg",
              onPressed: () {},
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const ProfileBody()
        ],
      ),
    );
  }
}
