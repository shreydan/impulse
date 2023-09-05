import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/core/constants/constants.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile>
    with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  int getPopularity(List posts) {
    int totalPopularity = 0;
    for (var i = 0; i < posts.length; i++) {
      totalPopularity += posts[i]['popularity'] as int;
    }
    return totalPopularity;
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
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          backgroundColor: const Color.fromRGBO(167, 111, 255, 1),
          title: const Text("@lakhan"),
        ),
        body: Column(children: [
          Container(
            margin: const EdgeInsets.only(top: 15, right: 15),
            padding: const EdgeInsets.only(left: 15),
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: Text('${prov.userChannels.length}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: const Text('Following channels',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: Text('${prov.userPosts.length}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: const Text('Posts',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: Text('${getPopularity(prov.userPosts)}',
                          style: TextStyle(
                              color: getPopularity(prov.userPosts) < 0
                                  ? Colors.red
                                  : Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 15, top: 5),
                      child: const Text('Popularity',
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          TabBar(indicatorWeight: 5, controller: _tabController, tabs: const [
            Tab(
              child: Text(
                'Posts',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Tab(
              child: Text(
                'Channels',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ]),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                    padding: const EdgeInsets.only(top: 5),
                    shrinkWrap: true,
                    itemCount: prov.userPosts.length,
                    itemBuilder: (ctx, index) {
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          margin: const EdgeInsets.only(bottom: 5, left: 15),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        onDismissed: (val){
                          prov.deletePost(postID: prov.userPosts[index]['post_id']);
                          setState(() {
                            prov.userPosts.removeAt(index);
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: Colors.grey.shade300))),
                          padding: const EdgeInsets.only(bottom: 10),
                          margin: const EdgeInsets.only(
                              bottom: 5, left: 15, right: 15),
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  prov.userPosts[index]['content'] ?? '',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 20, bottom: 10),
                                  child: Row(
                                    children: [
                                      const Text(
                                        'Popularity: ',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        prov.userPosts[index]['popularity']
                                            .toString(),
                                        style: TextStyle(
                                            color: prov.userPosts[index]
                                                        ['popularity'] <
                                                    0
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                // Container(
                                //   margin: const EdgeInsets.only(bottom: 10),
                                //   child: Row(
                                //     children: [
                                //       const Text(
                                //         'Channel: ',
                                //         style: TextStyle(
                                //             color: Colors.grey,
                                //             fontSize: 14,
                                //             fontWeight: FontWeight.w500),
                                //       ),
                                //       const SizedBox(
                                //         width: 5,
                                //       ),
                                //       Text(
                                //         prov.userPosts[index]['channel_name']??''
                                //            ,
                                //         style: TextStyle(
                                //             fontSize: 14,
                                //             fontWeight: FontWeight.bold),
                                //       ),
                                //     ],
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                ListView.builder(
                    itemCount: prov.userChannels.length,
                    itemBuilder: (ctx, index) {
                      return Column(
                        children: [
                          ListTile(
                              leading: Container(
                                // margin: const EdgeInsets.only(top: 5),
                                alignment: Alignment.center,
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: colors[index % colors.length]),
                                child: Text(
                                    prov.userChannels[index]['name']
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ),
                              title: Text(prov.userChannels[index]['name']
                                      .toString()
                                      .substring(0, 1)
                                      .toUpperCase() +
                                  prov.userChannels[index]['name']
                                      .toString()
                                      .substring(1)),
                              trailing: TextButton(
                                  onPressed: () {
                                    prov.followUnfollowChannel(
                                        channelID: prov.userChannels[index]
                                            ['channel_id'],
                                        type: 'unfollow');
                                    setState(() {
                                      prov.userChannels.removeAt(index);
                                    });
                                  },
                                  child: const Text(
                                    'Unfollow',
                                    style: TextStyle(color: Colors.grey),
                                  ))),
                          const Divider(
                            thickness: 1,
                          ),
                        ],
                      );
                    })
              ],
            ),
          ),
        ]));
  }
}
