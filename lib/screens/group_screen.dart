import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_app/constants/app_strings.dart';
import 'package:social_app/core/api_client.dart';
import 'package:social_app/models/group.dart';
import 'package:toast/toast.dart';

class GroupScreen extends StatefulWidget {
  GroupScreen(this.accessToken, this.loadDataFromAPI);

  final String accessToken;

  final bool loadDataFromAPI;

  @override
  _GroupScreenState createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  bool _isDataLoading;

  TextEditingController _titleController;

  TextEditingController _contentController;

  List<Group> _groupsList;

  Box<dynamic> _hiveBox;

  //region: Overridden function:
  @override
  void initState() {
    super.initState();
    _initScreenVariable();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _createGroup();
        },
        label: Text('Create Group'),
        icon: Icon(Icons.add_circle),
      ),
    );
  }

  @override
  void dispose() {
    _titleController?.dispose();
    _contentController?.dispose();
    super.dispose();
  }

//endregion

  //region: Widgets

  Widget _buildBody() {
    if (_isDataLoading) {
      return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)),
      );
    }
    return _buildGridWidget();
  }

  Widget _buildGridWidget() {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 8,
          crossAxisSpacing: 5,
          crossAxisCount: 2,
          childAspectRatio: 1),
      itemCount: _groupsList.length,
      itemBuilder: (BuildContext buildContext, int index) {
        Group group = _groupsList.elementAt(index);
        return _buildListItemWidget(group);
      },
    );
  }

  Widget _buildListItemWidget(Group group) {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadiusDirectional.circular(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              CircleAvatar(
                child: Text('${group.createdBy.substring(0, 1)}'),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(group.createdBy),
              const SizedBox(
                height: 16,
              ),
              Text(
                group.posts.length.toString(),
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
              Text(
                'posts',
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              _showModalSheet(group);
            },
            child: Container(
              width: double.maxFinite,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey),
              ),
              child: Text('Options'),
            ),
          )
        ],
      ),
    );
  }

  void _showModalSheet(Group group) {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
              height: 112,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(10.0),
                      topRight: const Radius.circular(10.0))),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.email),
                    onTap: () {
                      Navigator.pop(context);
                      _showPostDialog(group.groupId);
                    },
                    title: Text('Create Post',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                  ListTile(
                    leading: Icon(Icons.group_add),
                    onTap: () {
                      Navigator.pop(context);
                      _joinGroup(group.groupId);
                    },
                    title: Text('Join Group',
                        style: TextStyle(color: Colors.black, fontSize: 20)),
                  ),
                ],
              ));
        });
  }

  Future<void> _showPostDialog(String groupId) {
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              height: 180,
              child: new Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(hintText: "Title"),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _contentController,
                    decoration: InputDecoration(hintText: "Content"),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
                FlatButton(
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text('CREATE POST'),
                  onPressed: () {
                    if (_titleController.text.isNotEmpty &&
                        _contentController.text.isNotEmpty) {
                      Navigator.pop(context);
                      _createPost(_titleController.text,
                          _contentController.text, groupId);
                    } else {
                      Toast.show('Text should not be empty', context,
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

  //region: Private function
  Future<void> _initScreenVariable() async {
    _isDataLoading = true;
    _groupsList = <Group>[];
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _hiveBox = await Hive.openBox('Credentials');

    // to reduce API call
    if (widget.loadDataFromAPI) {
      _getAllGroupsData();
    } else {
      dynamic responseData = await _hiveBox.get('groupData');
      if (responseData != null) {
        _processFeedData(responseData);
      } else {
        _getAllGroupsData();
      }
    }
  }

  Future<void> _getAllGroupsData() async {
    try {
      ApiClient apiClient = ApiClient();
      dynamic responseData = await apiClient.getGroups();
      await _hiveBox.put('groupData', responseData);
      _processFeedData(responseData);
    } catch (e) {
      debugPrint('_getAllGroupsData error: $e');
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  Future<void> _createGroup() async {
    try {
      ApiClient apiClient = ApiClient();
      dynamic responseData = await apiClient.createGroup(widget.accessToken);
      debugPrint('responseData: $responseData');
      if (responseData['message'] == 'Group created!') {
        Toast.show(AppStrings.group_success, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
        setState(() {
          _isDataLoading = true;
          _groupsList.clear();
        });
        _getAllGroupsData();
      } else {
        Toast.show(AppStrings.group_fail, context,
            duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }
    } catch (e) {
      debugPrint('_createGroup error : $e');
    }
  }

  Future<void> _joinGroup(String groupId) async {
    try {
      ApiClient apiClient = ApiClient();
      dynamic responseData =
          await apiClient.joinGroup(widget.accessToken, groupId);
      Toast.show(responseData['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    } catch (e) {
      debugPrint('_joinGroup error : $e');
    }
  }

  Future<void> _createPost(String title, String content, String groupId) async {
    try {
      ApiClient apiClient = ApiClient();
      dynamic responseData = await apiClient.createPost(
          widget.accessToken, groupId, title, content);
      Toast.show(responseData['message'], context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      _groupsList.clear();
      setState(() {
        _isDataLoading = true;
      });
      _getAllGroupsData();
    } catch (e) {
      debugPrint('_createGroup error : $e');
    }
  }

  void _processFeedData(dynamic responseData) {
    List<dynamic> list = responseData['groups'];

    for (int i = 0; i < list.length; i++) {
      Group group = Group.fromJson(list.elementAt(i));
      _groupsList.add(group);
    }

    setState(() {
      _isDataLoading = false;
    });
  }
//endregion
}
