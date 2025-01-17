import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:sos/components/modal/index.dart';
import 'package:sos/provider/general_provider.dart';
import 'package:sos/provider/post_provider.dart';
import 'package:sos/provider/sector_provider.dart';
import 'package:sos/provider/user_provider.dart';
import 'package:sos/screens/Home/index.dart';
import 'package:sos/screens/Login/Login_page.dart';
import 'package:sos/screens/create_post/create_post_page.dart';
import 'package:sos/screens/forgot/forgot_page.dart';
import 'package:sos/screens/forgot/forgot_password_change.dart';
import 'package:sos/screens/home/screen/edit_post.dart';
import 'package:sos/screens/login/phone_ask.dart';
import 'package:sos/screens/map/map_screen_page.dart';
import 'package:sos/screens/home/screen/new_post.dart';
import 'package:sos/screens/notify/notification_detail_page.dart';
import 'package:sos/screens/notify/notification_page.dart';
import 'package:sos/screens/home/screen/pending_post.dart';
import 'package:sos/screens/home/screen/post_detail.dart';
import 'package:sos/screens/home/screen/successful_post.dart';
import 'package:sos/screens/otp/otp_page.dart';
import 'package:sos/screens/profile/profile_page.dart';
import 'package:sos/screens/profile/screens/change_password.dart';
import 'package:sos/screens/profile/screens/depending_post.dart';
import 'package:sos/screens/profile/screens/faq_page.dart';
import 'package:sos/screens/profile/screens/my_create_post_page.dart';
import 'package:sos/screens/profile/screens/my_sector_post.dart';
import 'package:sos/screens/profile/screens/policy_page.dart';
import 'package:sos/screens/profile/screens/saved_post_page.dart';
import 'package:sos/screens/profile/screens/user_detail_page.dart';
import 'package:sos/screens/register/register_page.dart';
import 'package:sos/screens/search/search_page.dart';
import 'package:sos/screens/splash/index.dart';
import 'package:sos/services/dialog.dart';
import 'package:sos/services/navigation.dart';
import 'package:provider/provider.dart';
import 'package:sos/utils/firebase/index.dart';
import 'package:sos/widgets/dialog_manager/dialog_manager.dart';
import 'package:firebase_core/firebase_core.dart';

// checkPermission() async {
//   var notification = await Permission.notification.status;

//   if (notification.isGranted == false) await Permission.notification.request();
// }

Future<void> main() async {
  // checkPermission();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseUtils.main();
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());

  runApp(const MyApp());
}

GetIt locator = GetIt.instance;

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
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
        ChangeNotifierProvider(create: (_) => SectorProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
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
                case MySectorPost.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const MySectorPost();
                  });
                case DependingPostPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const DependingPostPage();
                  });
                case SearchPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const SearchPage();
                  });
                case PolicyPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const PolicyPage();
                  });
                case FaqPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const FaqPage();
                  });
                case PhoneAskPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const PhoneAskPage();
                  });
                // case SuccessPage.routeName:
                //   SuccessPageArguments arguments =
                //       settings.arguments as SuccessPageArguments;
                //   return PageRouteBuilder(
                //     pageBuilder: (context, animation, secondaryAnimation) =>
                //         SuccessPage(
                //       title: arguments.title,
                //       message: arguments.message,
                //     ),
                //     transitionsBuilder:
                //         (context, animation, secondaryAnimation, child) {
                //       var begin = const Offset(0.0, 1.0);
                //       var end = Offset.zero;
                //       var curve = Curves.ease;

                //       var tween = Tween(begin: begin, end: end)
                //           .chain(CurveTween(curve: curve));

                //       return SlideTransition(
                //         position: animation.drive(tween),
                //         child: child,
                //       );
                //     },
                //   );
                case UserDetailPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const UserDetailPage();
                  });
                case MyCreatePostPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const MyCreatePostPage();
                  });
                case SavedPostPage.routeName:
                  return MaterialPageRoute(builder: (context) {
                    return const SavedPostPage();
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
                case MapScreenPage.routeName:
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        const MapScreenPage(),
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

                case NotificationDetailPage.routeName:
                  NotificationDetailPageArguments arguments =
                      settings.arguments as NotificationDetailPageArguments;
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        NotificationDetailPage(
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

                case ChangePasswordPage.routeName:
                  ChangePasswordPageArguments arguments =
                      settings.arguments as ChangePasswordPageArguments;
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ChangePasswordPage(
                      type: arguments.type,
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

                case PostDetailPage.routeName:
                  PostDetailPageArguments arguments =
                      settings.arguments as PostDetailPageArguments;
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        PostDetailPage(
                      id: arguments.id,
                    ),
                  );
                case EditPostPage.routeName:
                  EditPostPageArguments arguments =
                      settings.arguments as EditPostPageArguments;
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        EditPostPage(
                      data: arguments.data,
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

                case ForgotPasswordChange.routeName:
                  ForgotPasswordChangeArguments arguments =
                      settings.arguments as ForgotPasswordChangeArguments;
                  return PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        ForgotPasswordChange(
                      data: arguments.data,
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
