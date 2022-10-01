import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:social_app/constants/app_strings.dart';
import 'package:social_app/screens/feed_screen.dart';
import 'package:social_app/screens/profile_screen.dart';
import 'package:toast/toast.dart';

import 'group_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen(this.accessToken, this.userName);

  final String accessToken;
  final String userName;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex;

  //Flag to maintain where to load data from API or cache.
  //For first time it will load data from API and for subsequent call data will be loaded from cache.
  //True by default
  bool _loadDataFromAPI;

  Box<dynamic> _hiveBox;

  //region: Overridden functions

  @override
  void initState() {
    super.initState();
    _initScreenVariables();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  //endregion

  //region: Widgets
  Widget _buildAppBar() {
    return AppBar(
      title: Text(
        AppStrings.appTitle,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontSize: 25,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: [
        _selectedPageIndex == 2
            ? IconButton(
                onPressed: () {
                  _onLogout();
                },
                icon: Icon(
                  Icons.logout,
                  color: Colors.black38,
                ))
            : const SizedBox()
      ],
    );
  }

  Widget _buildBody() {
    if (_selectedPageIndex == 0) {
      return FeedScreen(widget.accessToken, widget.userName, _loadDataFromAPI);
    } else if (_selectedPageIndex == 1) {
      return GroupScreen(widget.accessToken, _loadDataFromAPI);
    } else {
      return ProfileScreen(widget.userName);
    }
  }

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      iconSize: 32,
      selectedItemColor: Theme.of(context).primaryColor,
      unselectedItemColor: Colors.blueGrey,
      items: [
        BottomNavigationBarItem(
            label: AppStrings.feed,
            icon: const Icon(
              Icons.home_filled,
            )),
        BottomNavigationBarItem(
            label: AppStrings.group, icon: const Icon(Icons.people)),
        BottomNavigationBarItem(
            label: AppStrings.profile,
            icon: const Icon(
              Icons.person,
            )),
      ],
      currentIndex: _selectedPageIndex,
      onTap: _onItemSelected,
    );
  }

  Future<bool> _onLogout() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Are you sure want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(false);
                await _hiveBox.clear();
                Toast.show('Logout successfully', context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                SystemNavigator.pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

//endregion

  //region: Private functions
  Future<void> _initScreenVariables() async {
    _selectedPageIndex = 0;
    _loadDataFromAPI = true;
    _hiveBox = await Hive.openBox('Credentials');
    Future.delayed(Duration(seconds: 3), () {
      _loadDataFromAPI = false;
    });
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }
//endregion
}
