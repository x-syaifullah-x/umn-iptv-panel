import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/utils.dart/utils.dart';

class DeviceCodePage extends StatefulWidget {
  const DeviceCodePage({super.key});

  @override
  State<DeviceCodePage> createState() => _DeviceCodePageState();
}

class _DeviceCodePageState extends State<DeviceCodePage> {
  final FocusNode _focusNode = FocusNode()..requestFocus();
  final TextEditingController _controller = TextEditingController();

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              Size biggest = constraints.biggest;
              double width = biggest.width >= 300 ? 300 : biggest.width;
              return Center(
                child: SizedBox(
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Device Code",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        focusNode: _focusNode,
                        controller: _controller
                          ..addListener(() {
                            bool isError = _errorText?.isNotEmpty == true;
                            if (isError) {
                              bool isResetError = _controller.text.isNotEmpty;
                              if (isResetError) {
                                setState(() {
                                  _errorText = null;
                                });
                              }
                            }
                          }),
                        decoration: InputDecoration(
                          hintText: "Enter your device code",
                          errorText: _errorText,
                          // border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(getWidthDevice(context, 65), 40),
                          ),
                          onPressed: () {
                            String deviceCode = _controller.text;
                            if (deviceCode.isEmpty) {
                              setState(() {
                                _errorText = "Please enter device code";
                                _focusNode.requestFocus();
                              });
                              return;
                            }
                            final collectionDevicesCode = FirebaseFirestore
                                .instance
                                .collection("devices_code");

                            collectionDevicesCode
                                .doc(deviceCode)
                                .get()
                                .then((value) {
                              final Map<String, dynamic>? data = value.data();
                              if (data == null) {
                                setState(() {
                                  _errorText = "Device code is incorrect";
                                });
                                return;
                              }
                              final String deviceId = data['device_id'];
                              print(deviceId);
                            });
                          },
                          child: const Text("Submit"),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
