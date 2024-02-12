import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test/playlist_model.dart';
import 'package:test/utils.dart/utils.dart';

class HomePage extends StatefulWidget {
  final String deviceId;

  const HomePage(
    this.deviceId, {
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int tmp = 65;

  @override
  Widget build(BuildContext context) {
    CollectionReference<Map<String, dynamic>> collectionDevicesId =
        FirebaseFirestore.instance.collection("devices_id");
    DocumentReference<Map<String, dynamic>> documentReferenceDeviceId =
        collectionDevicesId.doc(widget.deviceId);
    CollectionReference<Map<String, dynamic>> collectionPlaylist =
        documentReferenceDeviceId.collection("playlists");
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    int time = DateTime.now().millisecondsSinceEpoch;
                    collectionPlaylist.add({}).then((value) {
                      String id = value.id;
                      PlaylistModel p = PlaylistModel(
                        id: id,
                        name: String.fromCharCode(tmp++),
                        url: "https://a.m3u",
                        createAt: time,
                        updateAt: time,
                      );
                      collectionPlaylist.doc(id).set(p.toJson()).then((value) {
                        if (kDebugMode) {
                          print('aaaa');
                        }
                      });
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            Flexible(
              child: StreamBuilder(
                stream: collectionPlaylist.orderBy("name").snapshots(),
                builder: (context, snapshot) {
                  ConnectionState state = snapshot.connectionState;
                  bool isActive = state == ConnectionState.active;
                  bool isDown = state == ConnectionState.done;
                  bool isActiveOrDone = isActive || isDown;
                  if (isActiveOrDone) {
                    QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
                    List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs =
                        data?.docs;
                    List<PlaylistModel> item = docs
                            ?.map((e) => PlaylistModel.fromJson(e.data()))
                            .toList() ??
                        List.empty();
                    return ListView.builder(
                        itemCount: item.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.all(4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item[index].name),
                                Text(item[index].url),
                                Text('${item[index].createAt}'),
                                Text('${item[index].updateAt}'),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        collectionPlaylist
                                            .doc(item[index].id)
                                            .delete()
                                            .then((value) {
                                          print("sas");
                                        });
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        });
                  }
                  return const Center(
                    child: SizedBox(
                      child: CupertinoActivityIndicator(),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(getWidthDevice(context, 65), 40),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Logout"),
            )
          ],
        ),
      ),
    );
  }
}
