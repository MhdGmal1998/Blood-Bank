import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/utils.dart';
import '../../../../dependency_injection.dart' as di;
import '../../../cubit/profile_cubit/profile_cubit.dart';
import '../../../pages/about_page.dart';
import '../../../pages/edit_main_center_data.dart';
import '../../../pages/profile_center.dart';
import '../../../pages/setting_page.dart';
import '../../../pages/sign_in_page.dart';
import '../../../pages/sign_up_page.dart';
import '../../../resources/strings_manager.dart';
import 'home_drawer_menu_item.dart';

class HomeDrawerBody extends StatelessWidget {
  const HomeDrawerBody({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          child: Wrap(
            runSpacing: 10,
            children: [
              HomeDrawerMenuItem(
                title: AppStrings.homeDrawerSignIn,
                icon: Icons.login_rounded,
                onTap: () {
                  di.initSignIn();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignInPage(),
                    ),
                  );
                },
              ),
              HomeDrawerMenuItem(
                title: AppStrings.homeDrawerSignUp,
                icon: Icons.person_add_outlined,
                onTap: () {
                  di.initSignUp();
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const SignUpPage(),
                    ),
                  );
                },
              ),

              HomeDrawerMenuItem(
                title: AppStrings.homeDrawerSettings,
                icon: Icons.settings_outlined,
                onTap: () {
                  print("++++++++++++++++++");
                  BlocProvider.of<ProfileCubit>(context).getDataToProfilePage();
                  if (FirebaseAuth.instance.currentUser != null) {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingPage(),
                      ),
                    );
                  } else {
                    Utils.showSnackBar(
                      context: context,
                      msg: AppStrings.homeDrawerSignInFirstToast,
                    );
                    di.initSignIn();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignInPage(),
                      ),
                    );
                  }
                },
              ),

              HomeDrawerMenuItem(
                title: AppStrings.homeDrawerUpdateBloodBank,
                icon: Icons.sync,
                onTap: () {
                  BlocProvider.of<ProfileCubit>(context).getProfileCenterData();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const ProfileCenterPage()));
                },
              ),
              HomeDrawerMenuItem(
                title: AppStrings.homeDrawerEditProfileCenter,
                icon: Icons.sync,
                onTap: () {
                  BlocProvider.of<ProfileCubit>(context).getProfileCenterData();
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => EditMainCenterDataPage()));
                },
              ),
              const Divider(color: Colors.black54),
              HomeDrawerMenuItem(
                title: "مشاركة التطبيق",
                icon: Icons.share,
                onTap: () => Share.share(
                    'https://play.google.com/store/apps/details?id=d.threedevils.devicey'),
              ),
              HomeDrawerMenuItem(
                title: AppStrings.homeDrawerAboutApp,
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const AboutPage()));
                },
              ),
              // const Divider(color: Colors.black54),
              HomeDrawerMenuItem(
                title: AppStrings.homeDrawerLogOut,
                icon: Icons.logout_outlined,
                onTap: () async {
                  Hive.box(dataBoxName).put('user', "0");
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
