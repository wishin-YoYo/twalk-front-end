import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:twalk_app/pages/order_traking_page.dart';
import 'package:twalk_app/pages/pvp_page.dart';
import 'package:twalk_app/pages/my_page.dart';
import 'package:twalk_app/widgets/wishin_bottom_navigation_bar.dart';
import 'package:twalk_app/stores/user_store.dart';

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
  final bodies = [const PvpPage(), const OrderTrackingPage(), const MyPage()];

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
