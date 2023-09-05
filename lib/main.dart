import 'package:flutter/material.dart';
import 'package:impulse/core/constants/constants.dart';
import 'package:impulse/features/auth/screens/login_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/features/home/screen/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var inst = await SharedPreferences.getInstance();
  userID = inst.getString('user') ?? '';
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
    prov.getallPosts();
    prov.getuserPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(dataProvider);
    prov.userID = userID;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PostIt',
      home: userID.isEmpty ? const LoginScreen() : const HomeScreen(),
    );
  }
}
