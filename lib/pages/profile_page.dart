import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:web3_login/services/delete_profile.dart';

import '../anchor_types/profile_parameters.dart';
import '../services/upload_to_ipfs.dart';
import '../services/write_profile.dart';

class ProfilePage extends StatefulWidget {
  final Profile? profile;
  const ProfilePage({super.key, required this.profile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ImageProvider image;
  late String name;
  late int level;
  late String description;
  late String uri;
  Color textColor = Colors.black12;
  File? _imageFile;
  bool imagePicked = false;
  bool dataChanged = false;
  @override
  @override
  void initState() {
    super.initState();
    _setData();
  }

  void _setData() {
    if (widget.profile == null) {
      image = AssetImage('assets/default_avatar.png');
      name = '<Unknown>';
      level = 0;
      description = '<Description>';
      uri = '';
    } else {
      textColor = Colors.white;
      uri = widget.profile!.uri;
      try {
        image = NetworkImage(widget.profile!.uri);
      } catch (e) {
        image = AssetImage('assets/default_avatar.png');
      }
      name = widget.profile!.nickname;
      level = widget.profile!.level.toInt();
      description = widget.profile!.description;
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).go("/home");
        },
        backgroundColor: Colors.white.withOpacity(0.3),
        child: const Icon(
          Icons.arrow_back,
        ),
      ),
      appBar: AppBar(title: Text('Profile')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showChangeAvatarDialog,
              child: CircleAvatar(
                backgroundImage: image,
                radius: 50,
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _showChangeNameDialog,
              child: Text(
                name,
                style: TextStyle(fontSize: 24),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Level $level',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: _showChangeDescriptionDialog,
              child: Text(
                description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
                onPressed: () {
                  if (dataChanged) {
                    _showUpdateProfileDialog();
                  } else {
                    GoRouter.of(context).go("/home");
                  }
                },
                child: const Text('Accept')),
            SizedBox(height: 16),
            if (widget.profile != null)
              TextButton(
                  onPressed: _showDeleteProfileDialog,
                  child: const Text(
                    "Delete this profile",
                    style: TextStyle(color: Colors.redAccent),
                  ))
          ],
        ),
      ),
    );
  }

  void _showDeleteProfileDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete Profile'),
            content: Text("Are you sure you want to delete your profile"),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Accept'),
                onPressed: () async {
                  final message = await DeleteProfile();
                  _resultDialog(context, message);
                },
              ),
            ],
          );
        });
  }

  void _showUpdateProfileDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Update Profile'),
            content: Text(
                "Are you sure you want to update your profile details? This will generate a transaction fee"),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Accept'),
                onPressed: () async {
                  if (imagePicked) {
                    final uploadImageResult = await uploadToIPFS(_imageFile!);
                    if (uploadImageResult != null) {
                      uri =
                          'https://quicknode.myfilebase.com/ipfs/$uploadImageResult';
                    }
                  }

                  final message =
                      await saveOrUpdateProfile(name, description, uri);
                  _resultDialog(context, message);
                },
              ),
            ],
          );
        });
  }

  void _showChangeDescriptionDialog() {
    String _descriptionTemp = description;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change Description'),
            content: TextField(
              decoration: InputDecoration(hintText: 'Enter description'),
              onChanged: (value) {
                _descriptionTemp = value;
              },
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Accept'),
                onPressed: () {
                  if (description != _descriptionTemp) {
                    dataChanged = true;
                    description = _descriptionTemp;
                  }
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  void _showChangeNameDialog() {
    String _nameTemp = name;
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change Name'),
            content: TextField(
              decoration: InputDecoration(hintText: 'Enter Name'),
              onChanged: (value) {
                _nameTemp = value;
              },
            ),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Accept'),
                onPressed: () {
                  if (name != _nameTemp) {
                    dataChanged = true;
                    name = _nameTemp;
                  }
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ],
          );
        });
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imagePicked = true;
      dataChanged = true;
      setState(() {
        _imageFile = File(pickedFile.path);
        image = FileImage(_imageFile!);
      });
    }
  }

  void _showChangeAvatarDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change Avatar'),
            content: Text("Do you want to select a New Profile Picture?"),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text('Accept'),
                onPressed: () {
                  _pickImage();
                  Navigator.pop(context);
                  setState(() {});
                },
              ),
            ],
          );
        });
  }
}

void _resultDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Success'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Transaction successful with result ",
            ),
            Text(message),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Accept'),
            onPressed: () {
              Navigator.pop(context);
              context.pushReplacement("/home");
            },
          ),
        ],
      );
    },
  );
}
