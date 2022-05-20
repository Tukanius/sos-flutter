import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sos/components/modal/index.dart';
import 'package:sos/provider/general_provider.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/Home/index.dart';
import 'package:sos/screens/Login/Login_page.dart';
import 'package:sos/screens/create_post/create_post_page.dart';
import 'package:sos/screens/forgot/forgot_page.dart';
import 'package:sos/screens/home/screen/new_post.dart';
import 'package:sos/screens/home/screen/notification_page.dart';
import 'package:sos/screens/home/screen/pending_post.dart';
import 'package:sos/screens/home/screen/post_detail.dart';
import 'package:sos/screens/home/screen/successful_post.dart';
import 'package:sos/screens/otp/otp_page.dart';
import 'package:sos/screens/profile/profile_page.dart';
import 'package:sos/screens/profile/screens/change_password.dart';
import 'package:sos/screens/profile/screens/my_create_post_page.dart';
import 'package:sos/screens/profile/screens/user_detail_page.dart';
import 'package:sos/screens/register/register_page.dart';
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
      debugShowCheckedModeBanner: false,
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
            builder: (context, widget) => Navigator(
              onGenerateRoute: (settings) => MaterialPageRoute(
                builder: (context) =>
                    DialogManager(child: loading(context, widget)),
              ),
            ),
            navigatorKey: locator<NavigationService>().navigatorKey,
            initialRoute: SplashPage.routeName,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (RouteSettings settings) {
              switch (settings.name) {
                case SplashPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const SplashPage();
                  });
                case RegisterPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const RegisterPage();
                  });
                case HomePage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const HomePage();
                  });
                case ProfilePage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const ProfilePage();
                  });
                case ForgotPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const ForgotPage();
                  });
                case LoginPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const LoginPage();
                  });
                case UserDetailPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const UserDetailPage();
                  });
                case ChangePasswordPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const ChangePasswordPage();
                  });
                case MyCreatePostPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const MyCreatePostPage();
                  });
                case PendingPostPage.routeName:
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const PendingPostPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  );
                case NewPostPage.routeName:
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const NewPostPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  );
                case SuccessfulPostPage.routeName:
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const SuccessfulPostPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  );

                case CreatePostPage.routeName:
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const CreatePostPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  );
                case NotificationPage.routeName:
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const NotificationPage(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  );

                case PostDetailPage.routeName:
                  PostDetailPageArguments arguments =
                      settings.arguments as PostDetailPageArguments;
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        PostDetailPage(
                      id: arguments.id,
                    ),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      var begin = const Offset(0.0, 1.0);
                      var end = Offset.zero;
                      var curve = Curves.ease;

                      var tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));

                      return SlideTransition(
                        position: animation.drive(tween),
                        child: child,
                      );
                    },
                  );

                case OtpVerifyPage.routeName:
                  OtpVerifyPageArguments? arguments =
                      settings.arguments as OtpVerifyPageArguments?;

                  return MaterialPageRoute(
                      builder: (context) {
                        return OtpVerifyPage(
                          data: arguments!.data,
                          type: arguments.type,
                          phone: arguments.phone,
                        );
                      },
                      fullscreenDialog: true);
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
