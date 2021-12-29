import 'package:flutter/material.dart';
import 'package:git_repo/floor/post_response_dao.dart';
import 'package:git_repo/view/login_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'floor/app_database.dart';
import 'view/git_home.dart';
import 'provider/git_provider.dart';

PostResponseDao? dao;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database =
  await $FloorAppDatabase.databaseBuilder('interview_db.db').build();
  dao = database.postResponseDao;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(
          create: (context) => PostProvider(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This view.widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.pink,
      ),
      home:
      // PostScreen()
      LoginScreen(),
    );
  }
}
