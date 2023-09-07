import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:impulse/core/constants/constants.dart';
import 'package:impulse/features/auth/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/features/home/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var inst = await SharedPreferences.getInstance();
  userID = inst.getString('user') ?? '';
  userName = inst.getString('name') ?? '';
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    var prov = ref.read(dataProvider);
    prov.userID = userID;
    prov.userName = userName;
    prov.getallPosts();
    prov.getuserPosts();
    prov.getallChannels();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // set status bar white
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark));
    var prov = ref.watch(dataProvider);
    prov.userID = userID;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PostIt',
      home: userID.isEmpty ? const LoginScreen() : const HomeScreen(),
    );
  }
}
