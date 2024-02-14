import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:test/extensions/build_context_extention.dart';
import 'package:test/models/playlist_model.dart';
import 'package:test/pages/add_or_change_dialog.dart';

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
  String order = 'name';
  // bool isReverseOrder = true;

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
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 550),
            child: Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                const Text(
                  "Playlist",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Row(
                  children: [
                    const SizedBox(
                      width: 8,
                    ),
                    _addDataWidget(collectionPlaylist),
                    const SizedBox(
                      width: 8,
                    ),
                    _sortingWidget(context),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Flexible(child: _itemWidget(collectionPlaylist)),
                _logoutWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _logoutWidget() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(context.getWidthDevice(65), 40),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text("Logout"),
    );
  }

  Widget _itemWidget(
    CollectionReference<Map<String, dynamic>> collectionPlaylist,
  ) {
    return StreamBuilder(
      stream: collectionPlaylist.orderBy(b[selectedOption]).snapshots(),
      builder: (context, snapshot) {
        ConnectionState state = snapshot.connectionState;
        bool isActive = state == ConnectionState.active;
        bool isDown = state == ConnectionState.done;
        bool isActiveOrDone = isActive || isDown;
        if (isActiveOrDone) {
          QuerySnapshot<Map<String, dynamic>>? data = snapshot.data;
          List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs = data?.docs;
          List<PlaylistModel> items =
              docs?.map((e) => PlaylistModel.fromJson(e.data())).toList() ??
                  List.empty();
          if (items.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.asset(
                    "assets/images/icon_empty_playlist.png",
                  ),
                ),
                const Text(
                  "Playlist empty",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )
              ],
            );
          }
          return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                PlaylistModel model = items[index];
                return Column(
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          child: InkWell(
                            onTap: () {},
                            borderRadius: const BorderRadius.all(
                              Radius.circular(14),
                            ),
                            child: Container(
                              // margin: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 8,
                                bottom: 8,
                              ),
                              decoration: BoxDecoration(
                                // color: Colors.amber,
                                border: Border.all(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(14),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    model.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    model.url,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  Text(
                                    'CreateAt\t: ${DateTime.fromMillisecondsSinceEpoch(model.createAt)}',
                                  ),
                                  Text(
                                    'UpdateAt\t: ${DateTime.fromMillisecondsSinceEpoch(model.updateAt)}',
                                  ),
                                  Row(
                                    children: [
                                      // Edit
                                      TextButton(
                                        onPressed: () {
                                          _showDialog(
                                            context,
                                            collectionPlaylist,
                                            title: "Change Playlist",
                                            model: model,
                                          );
                                        },
                                        child: const Text(
                                          "Change",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      // Delete
                                      TextButton(
                                        onPressed: () {
                                          collectionPlaylist
                                              .doc(model.id)
                                              .delete()
                                              .then((value) {});
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    )
                  ],
                );
              });
        }
        return const Center(
          child: SizedBox(
            child: CupertinoActivityIndicator(),
          ),
        );
      },
    );
  }

  int selectedOption = 0;
  List<String> a = ['Name', 'Date'];
  List<String> b = [
    'name',
    'createAt',
  ];
  Widget _sortingWidget(BuildContext context) {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: const Icon(Icons.sort_sharp),
      ),
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            int currentValue = selectedOption;
            return StatefulBuilder(builder: (context, setState) {
              return AlertDialog(
                title: const Text("Sort by"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(a[0]),
                      leading: Radio(
                        value: 0,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(a[1]),
                      leading: Radio(
                        value: 1,
                        groupValue: selectedOption,
                        onChanged: (value) {
                          setState(() {
                            selectedOption = value!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              selectedOption = currentValue;
                              Navigator.of(context).pop(false);
                            },
                            child: const Text("cancel"),
                          ),
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(selectedOption != currentValue);
                            },
                            child: const Text("ok"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            });
          },
        ).then((value) {
          if (value) {
            setState(() {});
          }
        });
        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        //   content: Text("Sorting feature coming soon"),
        // ));
      },
    );
  }

  Widget _addDataWidget(
    CollectionReference<Map<String, dynamic>> collectionPlaylist,
  ) {
    return InkWell(
      borderRadius: const BorderRadius.all(
        Radius.circular(20),
      ),
      onTap: () {
        _showDialog(
          context,
          collectionPlaylist,
          title: "Add Playlist",
        );
      },
      child: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 8, right: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: const Row(
          children: [
            Icon(Icons.add),
            Text(
              "Add Playlist",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _showDialog(
    BuildContext context,
    CollectionReference<Map<String, dynamic>> collectionPlaylist, {
    required String title,
    PlaylistModel? model,
  }) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      useSafeArea: true,
      builder: (context) {
        return AddUpdateDialog(
          title: title,
          collectionPlaylist: collectionPlaylist,
          model: model,
        );
      },
    );
  }
}
