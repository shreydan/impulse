import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/core/constants/constants.dart';

class CreatePostScreen extends ConsumerStatefulWidget {
  const CreatePostScreen({super.key});

  @override
  ConsumerState<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends ConsumerState<CreatePostScreen> {
  final contentController = TextEditingController();
  String? community;
  @override
  void dispose() {
    super.dispose();
    contentController.dispose();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(dataProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(167, 111, 255, 1),
        title: const Text('Create a Post'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Community name'),
              ),
              const SizedBox(height: 10),
              DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      hintText: 'r/Community_name',
                      filled: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18),
                    ),
                    hint: const Text('Select Community'),
                    value: community,
                    items: prov.userChannels
                        .map((val) => DropdownMenuItem(
                              value: val['name'],
                              child: Text(val['name']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        community = value.toString();
                      });
                    }),
              ),
              const SizedBox(height: 15),
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Content'),
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 10,
                controller: contentController,
                decoration: const InputDecoration(
                  hintText: 'r/Content',
                  filled: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18),
                ),
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () async {
                  if (loading ||
                      contentController.text.isEmpty ||
                      community == null) return;

                  setState(() {
                    loading = true;
                  });
                  await prov
                      .createPost(
                    content: contentController.text,
                    channelID: prov.userChannels
                        .where((element) => element['name'] == community)
                        .first['channel_id'],
                  )
                      .then((value) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Post Created Successfully'),
                      ),
                    );
                  }).catchError((err) {
                    log(err.toString());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error Creating Post'),
                      ),
                    );
                  });

                  setState(() {
                    loading = false;
                  });
                },
                child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(167, 111, 255, 1),
                      borderRadius: BorderRadius.circular(50)),
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
