// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/core/constants/constants.dart';
import 'package:intl/intl.dart';

class Search extends ConsumerStatefulWidget {
  const Search({super.key});

  @override
  ConsumerState<Search> createState() => _SearchState();
}

class _SearchState extends ConsumerState<Search> {
  List<dynamic> allPosts = [];
  List<dynamic> allChannels = [];
  bool isPostEmpty = false;
  bool isChannelEmpty = false;
  @override
  void initState() {
    allPosts = ref.read(dataProvider).allPosts;
    allPosts.sort((a, b) => a['popularity'].compareTo(b['popularity']));
    allChannels = ref.read(dataProvider).allChannels;
    isChannelEmpty = allChannels.isEmpty;
    isPostEmpty = allPosts.isEmpty;
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final prov = ref.watch(dataProvider);
    return Scaffold(
      appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.white,
              statusBarIconBrightness: Brightness.dark),
          title: TextFormField(
            onChanged: (val) {
              setState(() {
                var posts = allPosts.where((element) => element['content']
                    .toString()
                    .startsWith(searchController.text));
                isPostEmpty = posts.isEmpty;
                var channels = allChannels.where((element) =>
                    element['channel_name']
                        .toString()
                        .startsWith(searchController.text));
                isChannelEmpty = channels.isEmpty;
              });
            },
            controller: searchController,
            decoration: const InputDecoration(
              hintText: 'Search',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.grey.shade200,
          leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(
                Icons.close,
                color: Colors.black,
              ))),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  isPostEmpty
                      ? Container()
                      : const Text(
                          'TRENDING POSTS',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListView.builder(
                      primary: false,
                      padding: const EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      itemCount: searchController.text.isEmpty
                          ? min(allPosts.length, 5)
                          : allPosts.length,
                      itemBuilder: (ctx, index) {
                        return searchController.text.isNotEmpty
                            ? allPosts[index]['content']
                                    .toString()
                                    .startsWith(searchController.text)
                                ? postCard(index)
                                : Container()
                            : postCard(index);
                      }),
                  isChannelEmpty
                      ? Container()
                      : const Text(
                          'COMMUNITIES',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                  ListView.builder(
                      primary: false,
                      padding: const EdgeInsets.only(top: 10),
                      shrinkWrap: true,
                      itemCount: searchController.text.isEmpty
                          ? min(allChannels.length, 5)
                          : allChannels.length,
                      itemBuilder: (ctx, index) {
                        return searchController.text.isNotEmpty
                            ? allChannels[index]['channel_name']
                                    .toString()
                                    .startsWith(searchController.text)
                                ? communityCard(index)
                                : Container()
                            : communityCard(index);
                      }),
                ],
              ),
            ),
          ),
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white.withOpacity(0.5),
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 100),
                      height: 20,
                      width: 20,
                      child: const CircularProgressIndicator(
                        color: Color.fromRGBO(5, 12, 102, 1),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget communityCard(int index) {
    final prov = ref.watch(dataProvider);
    bool isFollowing = prov.userChannels
        .where((element) =>
            element['channel_id'] == allChannels[index]['channel_id'])
        .isNotEmpty;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                // margin: const EdgeInsets.only(top: 5),
                alignment: Alignment.center,
                height: 35,
                width: 35,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade800),
                child: Text(
                    allChannels[index]['channel_name']
                        .toString()
                        .substring(0, 1)
                        .toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
              ),
              Container(
                margin: const EdgeInsets.only(left: 10),
                child: Text(
                    allChannels[index]['channel_name']
                            .toString()
                            .substring(0, 1)
                            .toUpperCase() +
                        allChannels[index]['channel_name']
                            .toString()
                            .substring(1),
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w500)),
              ),
              const Spacer(),
              TextButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await prov.followUnfollowChannel(
                        channelID: allChannels[index]['channel_id'],
                        type: isFollowing ? 'unfollow' : 'follow');
                    setState(() {
                      isFollowing = !isFollowing;
                      isLoading = false;
                    });
                  },
                  child: Text(
                    isFollowing ? 'Unfollow' : 'Follow',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: !isFollowing
                            ? const Color.fromRGBO(5, 12, 102, 1)
                            : Colors.grey),
                  ))
            ],
          ),
        ],
      ),
    );
  }

  Widget postCard(int index) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1, color: Colors.grey.shade300))),
      margin: const EdgeInsets.only(
        bottom: 20,
      ),
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
                      color: Colors.grey.shade800),
                  child: Text(
                      allPosts[index]['username']
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
                      width: MediaQuery.of(context).size.width - 75,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Text(
                                allPosts[index]['username']
                                        .toString()
                                        .substring(0, 1)
                                        .toUpperCase() +
                                    allPosts[index]['username']
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
                                        allPosts[index]['createdAt']))
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
                      margin: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                          allPosts[index]['channel_name']
                                  .toString()
                                  .substring(0, 1)
                                  .toUpperCase() +
                              allPosts[index]['channel_name']
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
              allPosts[index]['content'] ?? '',
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
