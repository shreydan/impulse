import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:impulse/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider extends ChangeNotifier {
  http.Client httpClient = http.Client();
  late String userID;
  List userChannels = [];
  List allChannels = [];
  List allPosts = [];
  List userPosts = [];
  List channelPosts = [];
  Future auth({required String username, required String password}) async {
    var url = Uri.parse('$baseUrl/auth');
    var response = await httpClient.post(url, body: {
      'username': username,
      'password': password,
    });

    if (response.statusCode == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.decode(response.body)["user_id"]);
      userID = json.decode(response.body)["user_id"];
      await prefs.setString(
          'name', username.toUpperCase() + username.substring(1));
      return response.body;
    } else {
      throw Exception();
    }
  }

  Future createChannel({required String name}) async {
    var url = Uri.parse('$baseUrl/channel-action');
    var response = await httpClient.post(url, body: {
      'channelname': name,
      'user_id': userID,
    });
    await getUserChannels();

    if (response.statusCode == 200) {
      log(userChannels.toString());
      return response.body;
    } else {
      log(response.body.toString());
      throw Exception(response.body);
    }
  }

  Future createPost(
      {required String channelID, required String content}) async {
    var url = Uri.parse('$baseUrl/post-action');
    var response = await httpClient.post(url,
        body: {'channel_id': channelID, 'user_id': userID, 'content': content});
    await getallPosts();
    log(response.body.toString());
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception(response.body);
    }
  }

  Future getuserPosts() async {
    var url = Uri.https('impulse-backend.vercel.app', '/api/feed',
        {'feedtype': 'profile', 'user_id': userID});
    var response = await httpClient.get(url);

    if (response.statusCode == 200) {
      userPosts = json.decode(response.body)["posts"];
      userChannels = json.decode(response.body)["following"];
      notifyListeners();
      return response.body;
    } else {
      log(response.body.toString());
      notifyListeners();
      throw Exception();
    }
  }

  Future getChannelPosts() async {
    var url = Uri.https(
        'impulse-backend.vercel.app', '/api/list-posts', {'listtype': 'all'});
    var response = await httpClient.get(url);

    if (response.statusCode == 200) {
      userChannels = json.decode(response.body)["channels"];
      return response.body;
    } else {
      log(response.body.toString());
      throw Exception();
    }
  }

  Future getallPosts() async {
    var url = Uri.https('impulse-backend.vercel.app', '/api/feed',
        {'user_id': userID, 'feedtype': 'home'});
    var response = await httpClient.get(url);
    log(response.body.toString());
    if (response.statusCode == 200) {
      allPosts = json.decode(response.body)["posts"];
      notifyListeners();
      return response.body;
    } else {
      notifyListeners();
      throw Exception();
    }
  }

  Future deletePost({required String postID}) async {
    var response =
        await httpClient.delete(Uri.parse('$baseUrl/post-action'), body: {
      'post_id': postID,
      'user_id': userID,
    });

    await getuserPosts();
    await getallPosts();

    if (response.statusCode == 200) {
      return response.body;
    } else {
      log(response.body.toString());
      throw Exception();
    }
  }

  Future getUserChannels() async {
    var url = Uri.https('impulse-backend.vercel.app', '/api/list-channels',
        {'listtype': 'user', 'user_id': userID});
    var response = await httpClient.get(url);

    if (response.statusCode == 200) {
      userChannels = json.decode(response.body)["channels"];
      return response.body;
    } else {
      log(response.body.toString());
      throw Exception();
    }
  }

  Future followUnfollowChannel(
      {required String channelID, required String type}) async {
    var response =
        await httpClient.put(Uri.parse('$baseUrl/channel-action'), body: {
      'channel_id': channelID,
      'followtype': type,
      'user_id': userID,
    });

    await getUserChannels();

    if (response.statusCode == 200) {
      return response.body;
    } else {
      log(response.body.toString());
      throw Exception();
    }
  }
}
