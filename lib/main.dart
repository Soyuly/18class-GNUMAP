import 'package:flutter/material.dart';
import 'package:gnumap/mainpage.dart';
import 'package:gnumap/splash.dart';
import 'package:location/location.dart';
import 'package:gnumap/revise_info.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:io';
import 'package:gnumap/models/db.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:gnumap/themes.dart';

// 앱에서 지원하는 언어 리스트 변수
final supportedLocales = [Locale('en', 'US'), Locale('ko', 'KR')];

Future main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  // easylocalization 초기화!
  await EasyLocalization.ensureInitialized();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
  }

  // MyApp을 EasyLocalization 로 감싼다.
  runApp(
    EasyLocalization(
        // 지원 언어 리스트
        supportedLocales: supportedLocales,
        //path: 언어 파일 경로
        path: 'assets/translations',
        //fallbackLocale supportedLocales에 설정한 언어가 없는 경우 설정되는 언어
        fallbackLocale: Locale('en', 'US'),

        //startLocale을 지정하면 초기 언어가 설정한 언어로 변경됨
        //만일 이 설정을 하지 않으면 OS 언어를 따라 기본 언어가 설정됨
        //startLocale: Locale('ko', 'KR')

        child: EasyDynamicThemeWidget(child: MyApp())),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        theme: lightThemeData,
        darkTheme: darkThemeData,
        themeMode: EasyDynamicTheme.of(context).themeMode,
        initialRoute: '/',
        routes: {
          '/': (context) => Splash(),
          '/home': (context) => GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: MainPage()),
        });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)..maxConnectionsPerHost = 5;
  }
}
