import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/provider.dart';

class Constants {
  static const catlogoPath = 'assets/images/catlogo.png';
  static const googlePath = 'assets/images/google.png';
}

const baseUrl = 'https://impulse-backend.vercel.app/api';
final dataProvider = ChangeNotifierProvider((ref) => DataProvider());
String userID='';
String userName='';
