import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/community/screens/create_community_screen.dart';
import 'package:impulse/community/screens/create_post_screen.dart';
import 'package:impulse/core/constants/constants.dart';
import 'package:impulse/features/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../auth/screens/login_screen.dart';

class CommunityListDrawer extends ConsumerStatefulWidget {
  const CommunityListDrawer({super.key});

  @override
  ConsumerState<CommunityListDrawer> createState() =>
      _CommunityListDrawerState();
}

class _CommunityListDrawerState extends ConsumerState<CommunityListDrawer> {
  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(dataProvider);
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 15),
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => const Profile()));
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(80),
                          color: Colors.grey.shade200),
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 15),
                        child:  Text(userName,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 5),
                        child: Text('Posts: ${prov.userPosts.length}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 15, top: 5),
                        child: Text(
                            'Following channels: ${prov.userChannels.length}',
                            style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.grey.shade300,
            ),
            ListTile(
              title: const Text('Create a community',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500)),
              leading: const Icon(Icons.add),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreateCommunityScreen(),
                ));
              },
            ),
            ListTile(
              title: const Text('Create a post',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.w500)),
              leading: const Icon(Icons.add),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const CreatePostScreen(),
                ));
              },
            ),
            const Spacer(),
            GestureDetector(
              onTap: () async {
                SharedPreferences.getInstance().then((value) => value.clear());
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) => const LoginScreen()),
                    (route) => false);
              },
              child: Container(
                height: 50,
                alignment: Alignment.center,
                width: double.infinity,
                color: Colors.red,
                child: const Text('Logout',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
