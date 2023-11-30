import 'package:flutter/material.dart';
import 'package:flutter_frontend_chat_app/resources/color_manager.dart';
import 'package:flutter_frontend_chat_app/resources/font_manager.dart';
import 'package:flutter_frontend_chat_app/resources/styles_manager.dart';
import 'package:flutter_frontend_chat_app/resources/values_manager.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
      // main colors of the app
      primaryColor: ColorManager.primary,
      primaryColorLight: ColorManager.primaryOpacity70,
      primaryColorDark: ColorManager.darkPrimary,
      disabledColor: ColorManager.grey1,
      colorScheme: ColorScheme.dark(
        background: ColorManager.bgColor,
        primary: ColorManager.primary,
        onPrimary: ColorManager.lightGrey,
        secondary: ColorManager.secondaryColor,
        onSecondary: ColorManager.grey2,
      ),
      // ripple color
      splashColor: ColorManager.primaryOpacity70,
      // will be used incase of disabled button for example
      secondaryHeaderColor: ColorManager.grey,
      // card view theme
      cardTheme: CardTheme(
          color: ColorManager.white, shadowColor: ColorManager.grey, elevation: Spacing.s4),
      // App bar theme
      appBarTheme: AppBarTheme(
          centerTitle: true,
          color: ColorManager.primary,
          elevation: Spacing.s4,
          shadowColor: ColorManager.primaryOpacity70,
          titleTextStyle: getRegularStyle(color: ColorManager.white, fontSize: FontSize.s16)),
      // Button theme
      buttonTheme: ButtonThemeData(
          shape: const StadiumBorder(),
          disabledColor: ColorManager.grey1,
          buttonColor: ColorManager.primary,
          splashColor: ColorManager.primaryOpacity70),

      // elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
              textStyle: getRegularStyle(color: ColorManager.white),
              backgroundColor: ColorManager.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Spacing.s12)))),

      // Text theme
      textTheme: TextTheme(
          displayLarge: getSemiBoldStyle(color: ColorManager.darkGrey, fontSize: FontSize.s16),
          displayMedium: getRegularStyle(color: ColorManager.white, fontSize: FontSize.s16),
          displaySmall: getBoldStyle(color: ColorManager.primary, fontSize: FontSize.s16),
          headlineMedium: getRegularStyle(color: ColorManager.primary, fontSize: FontSize.s14),
          titleMedium: getMediumStyle(color: ColorManager.lightGrey, fontSize: FontSize.s14),
          titleSmall: getMediumStyle(color: ColorManager.primary, fontSize: FontSize.s14),
          bodyMedium: getMediumStyle(color: ColorManager.lightGrey),
          bodySmall: getRegularStyle(color: ColorManager.grey1),
          bodyLarge: getRegularStyle(color: ColorManager.grey)),
      // input decoration theme (text form field)

      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.all(Spacing.s20),
        // hint style
        hintStyle: getRegularStyle(color: ColorManager.grey1),

        // label style
        labelStyle: getMediumStyle(color: ColorManager.darkGrey),
        // error style
        errorStyle: getRegularStyle(color: ColorManager.error),

        // enabled border
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.grey, width: Spacing.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(Spacing.s8))),

        // focused border
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.primary, width: Spacing.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(Spacing.s8))),

        // error border
        errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.error, width: Spacing.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(Spacing.s8))),
        // focused error border
        focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: ColorManager.primary, width: Spacing.s1_5),
            borderRadius: const BorderRadius.all(Radius.circular(Spacing.s8))),
      ));
}
