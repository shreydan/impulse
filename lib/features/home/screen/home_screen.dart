import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/core/constants/constants.dart';
import 'package:impulse/features/drawers/community_list_drawer.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  var colors = const [
    Color.fromRGBO(29, 53, 87, 1.0),
    Color.fromRGBO(69, 123, 157, 1.0),
    Color.fromRGBO(168, 218, 220, 1.0),
    Color.fromRGBO(241, 250, 238, 1.0),
    Color.fromRGBO(230, 57, 70, 1.0),
    Color.fromRGBO(244, 162, 97, 1.0),
    Color.fromRGBO(42, 157, 143, 1.0),
    Color.fromRGBO(27, 67, 50, 1.0),
    Color.fromRGBO(109, 104, 117, 1.0),
    Color.fromRGBO(52, 58, 64, 1.0),
    Color.fromRGBO(106, 5, 114, 1.0),
    Color.fromRGBO(171, 131, 161, 1.0),
    Color.fromRGBO(247, 37, 133, 1.0),
    Color.fromRGBO(127, 99, 255, 1.0),
    Color.fromRGBO(86, 11, 173, 1.0),
    Color.fromRGBO(255, 107, 107, 1.0),
    Color.fromRGBO(247, 127, 0, 1.0),
    Color.fromRGBO(243, 198, 119, 1.0),
    Color.fromRGBO(59, 59, 152, 1.0),
    Color.fromRGBO(74, 21, 75, 1.0),
  ];

  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(dataProvider);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Feed'),
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color.fromRGBO(167, 111, 255, 1),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => displayDrawer(context),
          );
        }),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
      drawer: const CommunityListDrawer(),
      body: Column(
        children: [
          ListView.builder(
              padding: const EdgeInsets.only(top: 10),
              shrinkWrap: true,
              itemCount: prov.allPosts.length,
              itemBuilder: (ctx, index) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1, color: Colors.grey.shade300))),
                  margin:
                      const EdgeInsets.only(bottom: 20, left: 15, right: 15),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              // margin: const EdgeInsets.only(top: 5),
                              alignment: Alignment.center,
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: colors[index % colors.length]),
                              child: Text(
                                  prov.allPosts[index]['username']
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width - 75,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: Text(
                                            prov.allPosts[index]['username']
                                                    .toString()
                                                    .substring(0, 1)
                                                    .toUpperCase() +
                                                prov.allPosts[index]['username']
                                                    .toString()
                                                    .substring(1),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      const Spacer(),
                                      Container(
                                        margin: const EdgeInsets.only(left: 10),
                                        child: const Text('Date :',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(left: 5),
                                        child: Text(
                                            DateFormat('dd/MM/yyyy')
                                                .format(DateTime.parse(
                                                    prov.allPosts[index]
                                                        ['createdAt']))
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500)),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 10, top: 5),
                                  child: Text(
                                      prov.allPosts[index]['channel_name']
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          prov.allPosts[index]['channel_name']
                                              .toString()
                                              .substring(1),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          prov.allPosts[index]['content'] ?? '',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w500),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 20, bottom: 10),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.thumb_up_alt_outlined,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                prov.allPosts[index]['popularity'].toString(),
                                style: TextStyle(
                                    color:
                                        prov.allPosts[index]['popularity'] < 0
                                            ? Colors.red
                                            : Colors.green,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              GestureDetector(
                                onTap: () {},
                                child: Icon(
                                  Icons.thumb_down_alt_outlined,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })
        ],
      ),
    );
  }
}
