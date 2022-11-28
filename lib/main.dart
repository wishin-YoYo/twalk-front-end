import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twalk_app/pages/map_page.dart';
import 'package:twalk_app/pages/pvp_page.dart';
import 'package:twalk_app/pages/my_page.dart';
import 'package:twalk_app/widgets/wishin_bottom_navigation_bar.dart';
import 'package:twalk_app/stores/user_store.dart';
import 'package:permission_handler/permission_handler.dart';

void main() => runApp(MultiProvider(
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
    super.initState();
    getPermission();
  }

  getPermission() async {
    var status = await Permission.location.status;
    if (status.isGranted) {
      print('허락됨.');
    } else if (status.isDenied) {
      print('거절됨.');
      Permission.location.request();
    }
  }

  void changePage(index) {
    setState(() {
      pageIndex = index;
    });
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
