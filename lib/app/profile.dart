import 'dart:developer';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as pathHelper;
import 'package:crypton/crypton.dart';
import 'package:share_extend/share_extend.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _privateKey = "";
  String _publicKey = "";

  @override
  initState() {
    super.initState();
    _getMasterKey();
  }

  _getMasterKey() async {
    final applicationsDir = await getApplicationDocumentsDirectory();

    final privateKeyPath =
        pathHelper.join(applicationsDir.path, 'credentials', 'master.key');
    final privateKey = File(privateKeyPath);

    final publicKeyPath =
        pathHelper.join(applicationsDir.path, 'credentials', 'master.pub');
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
    await Directory(pathHelper.join(applicationsDir.path, 'credentials'))
        .create(recursive: true);
    log(applicationsDir.path);
    final keyPair = ECKeypair.fromRandom();

    final privateKeyPath =
        pathHelper.join(applicationsDir.path, 'credentials', 'master.key');
    var privateKey = File(privateKeyPath);
    if (privateKey.existsSync()) {
      privateKey.deleteSync();
    }
    privateKey.createSync();
    privateKey.writeAsStringSync(keyPair.privateKey.toString());

    final publicKeyPath =
        pathHelper.join(applicationsDir.path, 'credentials', 'master.pub');
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

  _exportMasterKey() async {
    final applicationsDir = await getApplicationDocumentsDirectory();
    var encoder = ZipFileEncoder();
    await encoder.zipDirectoryAsync(
      Directory(pathHelper.join(applicationsDir.path, 'credentials')),
      filename: pathHelper.join(applicationsDir.path, 'passport.zip'),
    );
    ShareExtend.share(pathHelper.join(applicationsDir.path, 'passport.zip'), 'file');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _publicKey.isEmpty
            ? ElevatedButton(
                onPressed: _createMasterKey,
                child: const Text('Create Master Key'),
              )
            : Row(children: [
                ElevatedButton(
                  onPressed: _createMasterKey,
                  child: const Text('Reset Master Key'),
                ),
                const Expanded(child: Text('')),
                ElevatedButton(
                  onPressed: _exportMasterKey,
                  child: const Text('Export Master Key'),
                )
              ]),
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
