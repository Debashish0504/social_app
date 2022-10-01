import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_app/core/api_client.dart';
import 'package:social_app/models/user.dart';
import 'package:toast/toast.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.userName);

  final String userName;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Box<dynamic> _hiveBox;

  bool _isDataLoading;

  User _user;

  TextEditingController _nameController;

  //region:  Overridden functions
  @override
  void initState() {
    super.initState();
    _initScreenVariables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white, body: _buildBody());
  }

  @override
  void dispose() {
    _nameController?.dispose();
    super.dispose();
  }

  //endregion

  //region: Widget
  _buildBody() {
    if (_isDataLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
        ),
      );
    }
    return Container(
      width: double.maxFinite,
      height: double.maxFinite,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              border: Border.all(width: 1, color: Colors.blue.shade100),
            ),
            child: Container(
              height: 100,
              width: 100,
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                child: Text('${_user.firstName.substring(0, 1)}'),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '${_user.firstName}',
                  style: const TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _showEditNameDialog();
                  },
                  child: Icon(
                    Icons.edit,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              '${_user.email}',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Future<void> _showEditNameDialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 120,
              child: new Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(hintText: "Enter your name"),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('SAVE'),
                  onPressed: () async {
                    if (_nameController.text.isNotEmpty) {
                      _user.firstName = _nameController.text;
                      dynamic userResponse = {'user': _user.toJson()};
                      await _hiveBox.put('userData', userResponse);
                      Navigator.pop(context);
                      setState(() {});
                      _nameController.clear();
                    } else {
                      Toast.show('Name should not be empty', context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                    }
                  },
                ),
              ]),
            ),
          );
        });
  }

  //endregion

//region: Private functions
  Future<void> _initScreenVariables() async {
    try {
      _isDataLoading = true;
      _hiveBox = await Hive.openBox('Credentials');
      _nameController = TextEditingController();
      dynamic userResponse = await _hiveBox.get('userData');

      if (userResponse != null) {
        //load data from cache
        dynamic userData = userResponse['user'];
        _user = User.fromJson(userData);
        setState(() {
          _isDataLoading = false;
        });
      } else {
        _getUserData(widget.userName);
      }
    } catch (e) {
      debugPrint('_initScreenVariables error: $e');
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  Future<void> _getUserData(String userName) async {
    try {
      ApiClient apiClient = ApiClient();
      dynamic userResponse = await apiClient.getUserProfileData(userName);
      dynamic userData = userResponse['user'];
      //save data to hive
      _user = User.fromJson(userData);
      await _hiveBox.put('userData', userResponse);
      setState(() {
        _isDataLoading = false;
      });
    } catch (e) {
      debugPrint('_getUserData error: $e');
      setState(() {
        _isDataLoading = false;
      });
    }
  }

//endregion
}
