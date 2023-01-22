import 'package:blood_bank_app/presentation/resources/style_manager.dart';
import 'package:flutter/material.dart';

import 'color_manageer.dart';
import 'font_manager.dart';
import 'values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    // main colors
    primaryColor: ColorManager.primary,
    primaryColorLight: ColorManager.lightPrimary,
    primaryColorDark: ColorManager.darkPrimary,
    disabledColor: ColorManager.grey1,
    splashColor: ColorManager.lightPrimary,

    // cardview theme
    cardTheme: const CardTheme(
      color: ColorManager.white,
      shadowColor: ColorManager.grey,
      elevation: AppSize.s4,
    ),

    // app bar theme
    appBarTheme: AppBarTheme(
        color: ColorManager.primary,
        centerTitle: true,
        elevation: AppSize.s4,
        shadowColor: ColorManager.lightPrimary,
        titleTextStyle: getBoldStyle(
          fontSize: FontSize.s16,
          color: ColorManager.white,
        )),

    // button theme
    buttonTheme: const ButtonThemeData(
        shape: StadiumBorder(),
        disabledColor: ColorManager.grey1,
        buttonColor: ColorManager.primary,
        splashColor: ColorManager.lightPrimary),

    // elevated button theme

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
          textStyle: getRegularStyle(
              color: ColorManager.white, fontSize: FontSize.s17),
          backgroundColor: ColorManager.primary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppSize.s12))),
    ),
    // text theme
    textTheme: TextTheme(
      displayLarge:
          getSemiBoldStyle(color: ColorManager.white, fontSize: FontSize.s30),
      headlineLarge: getSemiBoldStyle(
        color: ColorManager.darkGrey,
        fontSize: FontSize.s16,
      ),
      titleMedium:
          getMediumStyle(color: ColorManager.lightGrey, fontSize: FontSize.s14),
      headlineMedium:
          getRegularStyle(color: ColorManager.darkGrey, fontSize: FontSize.s14),
      bodyLarge: getRegularStyle(color: ColorManager.grey1),
      bodySmall: getRegularStyle(color: ColorManager.grey),
      displaySmall: getRegularStyle(
        color: ColorManager.white,
        fontSize: FontSize.s22,
      ),
    ),

    // input decorarion theme(text form field)

    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(AppPadding.p8),
      // hintstyle
      hintStyle:
          getRegularStyle(color: ColorManager.grey, fontSize: FontSize.s20),
      // label style
      labelStyle:
          getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),
      //erore style
      errorStyle: getRegularStyle(color: ColorManager.error),
      // enable border style
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ColorManager.grey, width: AppSize.s1_5),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s18))),
// focused border style
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.grey,
            width: AppSize.s1_5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),

// error border style
      errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.error,
            width: AppSize.s1_5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
      // focusedError Border style
      focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: ColorManager.primary,
            width: AppSize.s1_5,
          ),
          borderRadius: BorderRadius.all(Radius.circular(AppSize.s8))),
    ),
  );
}
