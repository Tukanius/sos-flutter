import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sos/components/modal/index.dart';
import 'package:sos/provider/general_provider.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/Home/index.dart';
import 'package:sos/screens/splash/index.dart';
import 'package:sos/services/dialog.dart';
import 'package:sos/services/navigation.dart';
import 'package:provider/provider.dart';
import 'package:sos/widgets/dialog_manager/dialog_manager.dart';

void main() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());

  runApp(const MyApp());
}

GetIt locator = GetIt.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GeneralProvider()),
      ],
      child: Stack(
        children: [
          MaterialApp(
            title: 'Sos',
            // theme: ThemeData.from(
            //   colorScheme:  ColorScheme.light(primary: primaryGreen),
            // ).copyWith(
            //   pageTransitionsTheme: const PageTransitionsTheme(
            //     builders: <TargetPlatform, PageTransitionsBuilder>{
            //       TargetPlatform.android: ZoomPageTransitionsBuilder(),
            //     },
            //   ),
            // ),
            builder: (context, widget) => Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) =>
                    DialogManager(child: loading(context, widget)),
              ),
            ),
            navigatorKey: locator<NavigationService>().navigatorKey,
            initialRoute: SplashPage.routeName,
            // home: const TabPage(),
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case SplashPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const SplashPage();
                  });
                case HomePage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  });
                default:
                  return MaterialPageRoute(
                    builder: (_) => Scaffold(
                      body: Center(
                          child: Text('No route defined for ${settings.name}')),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget loading(BuildContext context, widget) {
    bool shouldPop = false;

    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.3),
        body: Container(
          color: Colors.blue,
          child: SafeArea(
            bottom: false,
            top: false,
            child: Stack(
              children: [
                Opacity(
                  opacity: 1,
                  child: Container(
                    color: Colors.black,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        widget,
                        GeneralModal(),
                      ],
                    ),
                  ),
                ),
                // const LoadingPage(),
              ],
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return shouldPop;
      },
    );
  }
}
