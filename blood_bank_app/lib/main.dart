import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dependency_injection.dart' as di;
import 'presentation/cubit/profile_cubit/profile_cubit.dart';
import 'presentation/cubit/search_cubit/search_cubit.dart';
import 'presentation/cubit/signin_cubit/signin_cubit.dart';
import 'presentation/cubit/signup_cubit/signup_cubit.dart';
import 'presentation/pages/about_page.dart';
import 'presentation/pages/edit_main_center_data.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/introduction_page.dart';
import 'presentation/pages/profile_center.dart';
import 'presentation/pages/search_map.dart';
import 'presentation/pages/search_page.dart';
import 'presentation/pages/setting_page.dart';
import 'presentation/pages/sign_in_page.dart';
import 'presentation/pages/sign_up_page.dart';
import 'presentation/pages/sing_up_center_page.dart';
import 'presentation/resources/theme_manager.dart';

// Future backgroundMessage(RemoteMessage message) async {
//   Fluttertoast.showToast(msg: message.notification!.body.toString());
// }

// Future updateLocation(RemoteMessage msg) async {
//   print("==========onBackground==========");
//   Fluttertoast.showToast(msg: "update location\n${msg.notification!.body}");
//   await Firebase.initializeApp();
//   print("=========update====location=======\n${msg.notification!.body}");
//   await FirebaseFirestore.instance
//       .collection("donors")
//       .doc("H5PPBI8VBBNikBYvmifb")
//       .update({
//     "lan": 2.02121510,
//     "lon": 2.42144775,
//   }).then((value) {
//     print("==========Done==========");
//   });
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await di.initApp();
  await Hive.initFlutter();
  await Hive.openBox(dataBoxName);

  // FirebaseMessaging.onBackgroundMessage(updateLocation);
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (BuildContext context) => di.sl<SignUpCubit>()),
      BlocProvider(create: (BuildContext context) => di.sl<SingInCubit>()),
      BlocProvider(create: (BuildContext context) => di.sl<SearchCubit>()),
      BlocProvider(create: (BuildContext context) => di.sl<ProfileCubit>())
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      // theme: ThemeData(
      //   primarySwatch: Colors.red,
      //   primaryColor: ePrimColor,
      //   fontFamily: "Almarai",
      //   // textTheme: Theme.of(context).textTheme.copyWith(
      //   //       bodyText2: TextStyle(
      //   //         color: eTextColor,
      //   //         fontFamily: 'Almarai',
      //   //       ),
      //   //     ),
      // ),
      locale: const Locale("ar", "AE"),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale("ar", "AE")],
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName: (context) => const HomePage(),
        SignUpPage.routeName: (context) => const SignUpPage(),
        SignInPage.routeName: (context) => const SignInPage(),
        SignUpCenter.routeName: (context) => const SignUpCenter(),
        SearchPage.routeName: (context) => const SearchPage(),
        SettingPage.routeName: (context) => const SettingPage(),
        SearchMapPage.routeName: (context) => const SearchMapPage(),
        // OnBoardingView.routeName: (context) => const OnBoardingView(),
        IntroductionPage.routeName: (context) => const IntroductionPage(),
        ProfileCenterPage.routeName: (context) => ProfileCenterPage(),
        EditMainCenterDataPage.routeName: (context) => EditMainCenterDataPage(),
        AboutPage.routeName: (context) => const AboutPage()
      },
    );
  }
}
