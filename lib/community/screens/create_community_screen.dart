import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:impulse/core/constants/constants.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState<CreateCommunityScreen> createState() =>
      _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    communityNameController.dispose();
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var prov = ref.watch(dataProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(167, 111, 255, 1),
        title: const Text('Create a community'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Align(
              alignment: Alignment.topLeft,
              child: Text('Community name'),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: communityNameController,
              decoration: const InputDecoration(
                hintText: 'r/Community_name',
                filled: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(18),
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () async {
                if (loading || communityNameController.text.isEmpty) return;

                setState(() {
                  loading = true;
                });
                await prov
                    .createChannel(
                  name: communityNameController.text,
                )
                    .then((value) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Community created successfully'),
                    ),
                  );
                }).catchError((err) {
                  log(err.toString());
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to create community'),
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
            )
          ],
        ),
      ),
    );
  }
}
