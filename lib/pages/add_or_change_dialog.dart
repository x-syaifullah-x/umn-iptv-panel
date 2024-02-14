import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/models/playlist_model.dart';

class AddUpdateDialog extends StatefulWidget {
  final String title;
  final PlaylistModel? model;
  final CollectionReference<Map<String, dynamic>> collectionPlaylist;

  const AddUpdateDialog({
    super.key,
    required this.title,
    this.model,
    required this.collectionPlaylist,
  });

  @override
  State<AddUpdateDialog> createState() => _AddUpdateDialogState();
}

class _AddUpdateDialogState extends State<AddUpdateDialog> {
  final TextEditingController inputNameController = TextEditingController();
  final TextEditingController inputUrlController = TextEditingController();

  final FocusNode focusNodeInputName = FocusNode();
  final FocusNode focusNodeInputUrl = FocusNode();

  String? errorTextInputName;
  String? errorTextInputUrl;

  @override
  void initState() {
    super.initState();
    inputNameController.text = widget.model?.name ?? "";
    inputUrlController.text = widget.model?.url ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      titlePadding: EdgeInsets.zero,
      title: Container(
        height: 48,
        decoration: const BoxDecoration(
          // color: Theme.of(context)
          //     .primaryTextTheme
          //     .titleSmall
          //     ?.backgroundColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Center(
          child: Text(widget.title),
        ),
      ),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Palylist Name",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              TextField(
                controller: inputNameController
                  ..addListener(() {
                    bool isError = errorTextInputName?.isNotEmpty == true;
                    if (isError) {
                      bool isResetError = inputNameController.text.isNotEmpty;
                      if (isResetError) {
                        setState.call(() {
                          errorTextInputName = null;
                        });
                      }
                    }
                  }),
                focusNode: focusNodeInputName,
                decoration: InputDecoration(
                  errorText: errorTextInputName,
                  hintText: "e.g xxx",
                  contentPadding: const EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                    left: 8,
                    right: 8,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Palylist URL",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 4,
              ),
              TextField(
                controller: inputUrlController
                  ..addListener(() {
                    bool isError = errorTextInputUrl?.isNotEmpty == true;
                    if (isError) {
                      bool isResetError = inputUrlController.text.isNotEmpty;
                      if (isResetError) {
                        setState.call(() {
                          errorTextInputUrl = null;
                        });
                      }
                    }
                  }),
                focusNode: focusNodeInputUrl,
                decoration: InputDecoration(
                  errorText: errorTextInputUrl,
                  hintText: "e.g https://xxx.m3u",
                  contentPadding: const EdgeInsets.only(
                    top: 0,
                    bottom: 0,
                    left: 8,
                    right: 8,
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey, width: 0.0),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 0.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        // fixedSize: Size(
                        //     getWidthDevice(context, 50),
                        //     40),
                        ),
                    child: const Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        // fixedSize: Size(
                        //     getWidthDevice(context, 50),
                        //     40),
                        ),
                    child: const Text("Submit"),
                    onPressed: () {
                      String name = inputNameController.text;
                      if (name.isEmpty) {
                        setState.call(() {
                          errorTextInputName = "Please enter playlist name";
                          focusNodeInputName.requestFocus();
                        });
                        return;
                      }
                      String url = inputUrlController.text;
                      if (url.isEmpty) {
                        setState.call(() {
                          errorTextInputUrl = "Please enter playlist URL";
                          focusNodeInputUrl.requestFocus();
                        });
                        return;
                      }

                      final collectionPlaylist = widget.collectionPlaylist;
                      PlaylistModel? model = widget.model;
                      int time = DateTime.now().millisecondsSinceEpoch;
                      if (model != null) {
                        bool isChangeName = model.name != name;
                        bool isChangeUrl = model.url != url;
                        bool isChange = isChangeName || isChangeUrl;
                        if (isChange) {
                          dynamic data = model
                              .copy(
                                name: isChangeName ? name : null,
                                url: isChangeUrl ? url : null,
                                updateAt: time,
                              )
                              .toJson();
                          collectionPlaylist
                              .doc(model.id)
                              .set(data)
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        } else {
                          Navigator.of(context).pop();
                        }
                      } else {
                        collectionPlaylist.add({}).then((value) {
                          String id = value.id;
                          PlaylistModel p = PlaylistModel(
                            id: id,
                            name: name,
                            url: url,
                            createAt: time,
                            updateAt: time,
                          );
                          collectionPlaylist
                              .doc(id)
                              .set(p.toJson())
                              .then((value) {
                            Navigator.of(context).pop();
                          });
                        });
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
