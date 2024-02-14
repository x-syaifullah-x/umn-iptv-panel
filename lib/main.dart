import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:test/pages/device_code_page.dart';
import 'package:test/utils/firebase_options.dart';

String? deviceId;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // CollectionReference<Map<String, dynamic>> collectionDevicesCode =
  //     FirebaseFirestore.instance.collection("devices_code");
  // QuerySnapshot<Map<String, dynamic>> querySnapshotDeviceCode =
  //     await collectionDevicesCode.get();
  // for (var doc in querySnapshotDeviceCode.docs) {
  //   if (kDebugMode) {
  //     String deviceID = doc.data()["device_id"];
  //     CollectionReference<Map<String, dynamic>> collectionDevicesId =
  //         FirebaseFirestore.instance.collection("devices_id");
  //     var documentReferenceDeviceId = collectionDevicesId.doc(deviceID);
  //     DocumentSnapshot<Map<String, dynamic>> devicesIdDoc =
  //         await documentReferenceDeviceId.get();
  //     print(devicesIdDoc.data());
  //     CollectionReference<Map<String, dynamic>> collectionPlaylist =
  //         documentReferenceDeviceId.collection("playlists");
  // }
  // }
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: '/',
      // routes: {
      //   // When navigating to the "/" route, build the FirstScreen widget.
      //   '/': (context) => const DeviceCodePage(),
      //   // When navigating to the "/second" route, build the SecondScreen widget.
      //   '/home': (context) => const HomePage("sasasasa"),
      // },
      home: const DeviceCodePage(),
    );
  }
}
