import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:social_app/core/api_client.dart';
import 'package:social_app/models/post.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen(this.accessToken, this.userName, this.loadDataFromAPI);

  final String accessToken;
  final String userName;
  final bool loadDataFromAPI;

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _isDataLoading;

  List<Post> _postList;

  Box<dynamic> _hiveBox;

  //region : Overridden functions
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
    super.dispose();
  }

//endregion

  //region: Widget

  Widget _buildBody() {
    if (_isDataLoading) {
      return Center(
        child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue)),
      );
    }
    return _buildListWidget();
  }

  Widget _buildListWidget() {
    return ListView.separated(
      itemCount: _postList.length,
      itemBuilder: (BuildContext buildContext, int index) {
        final Post post = _postList.elementAt(index);
        return _buildListItemWidget(post);
      },
      separatorBuilder: (BuildContext buildContext, int index) {
        return Divider();
      },
    );
  }

  Widget _buildListItemWidget(Post post) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('${post.createdBy.substring(0, 1)}'),
      ),
      title: Text(post.createdBy,
          style: TextStyle(color: Colors.black, fontSize: 20)),
      subtitle: RichText(
        text: TextSpan(children: <InlineSpan>[
          TextSpan(
              text: post.title,
              style: TextStyle(color: Colors.black54, fontSize: 14)),
          TextSpan(
            text: '\n',
          ),
          TextSpan(
              text: post.content,
              style: TextStyle(color: Colors.black38, fontSize: 12))
        ]),
      ),
    );
  }

  //endregion

  //region: Private functions
  Future<void> _initScreenVariables() async {
    _isDataLoading = true;
    _postList = <Post>[];

    _hiveBox = await Hive.openBox('Credentials');
    // to reduce API call
    if (widget.loadDataFromAPI) {
      _getFeedData();
    } else {
      dynamic responseData = await _hiveBox.get('feedData');
      if (responseData != null) {
        _processFeedData(responseData);
      } else {
        _getFeedData();
      }
    }
  }

  Future<void> _getFeedData() async {
    try {
      ApiClient apiClient = ApiClient();
      dynamic responseData =
          await apiClient.getUserFeed(widget.accessToken, widget.userName);
      await _hiveBox.put('feedData', responseData);
      _processFeedData(responseData);
    } catch (e) {
      debugPrint('_getFeedData error : $e');
      setState(() {
        _isDataLoading = false;
      });
    }
  }

  void _processFeedData(dynamic responseData) {
    Map<dynamic, dynamic> posts = responseData['posts'];
    posts.forEach((key, value) {
      final Post post = Post.fromJson(value);
      _postList.add(post);
    });

    setState(() {
      _isDataLoading = false;
    });
  }
//endregion
}
