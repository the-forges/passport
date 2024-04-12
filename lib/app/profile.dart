import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathHelper;
import 'package:crypton/crypton.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String _privateKey = "";
  String _publicKey = "";

  initState() {
    _getMasterKey();
  }

  _getMasterKey() async {
    final applicationsDir = await getApplicationDocumentsDirectory();

    final privateKeyPath = pathHelper.join(applicationsDir.path, 'master.key');
    final privateKey = File(privateKeyPath);

    final publicKeyPath = pathHelper.join(applicationsDir.path, 'master.pub');
    final publicKey = File(publicKeyPath);
    if (privateKey.existsSync() && publicKey.existsSync()) {
      setState(() {
        _privateKey = privateKey.readAsStringSync();
        _publicKey = publicKey.readAsStringSync();
      });
    }
  }

  _createMasterKey() async {
    final applicationsDir = await getApplicationDocumentsDirectory();
    final keyPair = ECKeypair.fromRandom();

    final privateKeyPath = pathHelper.join(applicationsDir.path, 'master.key');
    var privateKey = File(privateKeyPath);
    if (privateKey.existsSync()) {
      privateKey.deleteSync();
    }
    privateKey.createSync();
    privateKey.writeAsStringSync(keyPair.privateKey.toString());

    final publicKeyPath = pathHelper.join(applicationsDir.path, 'master.pub');
    var publicKey = File(publicKeyPath);
    if (publicKey.existsSync()) {
      publicKey.deleteSync();
    }
    publicKey.createSync();
    publicKey.writeAsStringSync(keyPair.publicKey.toString());

    setState(() {
      _privateKey = keyPair.privateKey.toString();
      _publicKey = keyPair.publicKey.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _publicKey.isEmpty ?
          ElevatedButton(
            onPressed: _createMasterKey,
            child: const Text('Create Master Key'),
          ) :
          Column(
            children: [
              Text(_publicKey),
              ElevatedButton(
                onPressed: _createMasterKey,
                child: const Text('Reset Master Key'),
              )
            ]
          ),
        const Expanded(
          flex: 1,
          child: Center(
            child: Text('Profile'),
          ),
        ),
      ],
    );
  }

}