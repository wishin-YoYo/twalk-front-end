import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twalk_app/pages/map_page.dart';
import 'package:twalk_app/pages/pvp_page.dart';
import 'package:twalk_app/pages/my_page.dart';
import 'package:twalk_app/widgets/wishin_bottom_navigation_bar.dart';
import 'package:twalk_app/stores/user_store.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => UserStore()),
    ],
    child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.black,
            elevation: 0,
          ),
        ),
        home: MyApp()),
  ));
}

//////////////////////////////////////////////////////
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  var pageIndex = 1;
  final bodies = [const PvpPage(), MapPage(), const MyPage()];

  @override
  void initState() {
    initialization();
    super.initState();
    getPermission();
  }

  void initialization() async {
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    // ignore_for_file: avoid_print
    print('ready in 3...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 2...');
    await Future.delayed(const Duration(seconds: 1));
    print('ready in 1...');
    await Future.delayed(const Duration(seconds: 1));
    print('go!');
    FlutterNativeSplash.remove();
  }

  getPermission() async {
    // LOCATION PERMISSION
    var locationStatus = await Permission.location.status;
    if (locationStatus.isGranted) {
      print('[CGCG] location permission 허락됨.');
    } else if (locationStatus.isDenied) {
      print('[CGCG] location permission 거절됨.');
      Permission.location.request();
    }
    // ACTIVITY RECOGNITION PERMISSION
    var activityRecognitionStatus = await Permission.activityRecognition.status;
    if (activityRecognitionStatus.isGranted) {
      print('[CGCG] activeRecognition 허락됨.');
    } else if (activityRecognitionStatus.isDenied) {
      print('[CGCG] activeRecognition 거절됨.');
      Permission.activityRecognition.request();
    }
    // STORAGE PERMISSION
    var storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) {
      print('[CGCG] storage 허락됨.');
    } else {
      print('[CGCG] storage 거절됨.');
      Permission.storage.request();
    }
  }

  void changePage(index) {
    if (mounted) {
      setState(() {
        pageIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: bodies[pageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: WishinBottomNavigaionBar(
        pageIndex: pageIndex,
        changePage: changePage,
      ),
    );
  }
}
