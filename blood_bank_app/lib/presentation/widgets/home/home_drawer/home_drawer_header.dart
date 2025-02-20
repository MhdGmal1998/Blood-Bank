import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../resources/color_manageer.dart';
import '../../../resources/strings_manager.dart';
import '../../../resources/values_manager.dart';

class HomeDrawerHeader extends StatelessWidget {
  const HomeDrawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return DrawerHeader(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: InkWell(
        onTap: () async {},
        child: Center(
          child: Column(
            children: [
              Container(
                height: AppSize.s80,
                width: AppSize.s80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppRadius.r50),
                  color: ColorManager.white,
                ),
                child: Center(
                  child: Icon(
                    Icons.emoji_emotions,
                    size: AppSize.s50,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
              const SizedBox(height: AppSize.s20),
              Text(
                (currentUser != null)
                    ? currentUser.email!
                    : AppStrings.homeDrawerHeaderAppName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
