import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ThirdScreen extends StatefulWidget {
  @override
  _ThirdScreenState createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  List<User> users = [];
  bool isLoading = false;
  int page = 1;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();

    // Add a listener to the scroll controller
    _scrollController.addListener(() {
      // Check if the user has scrolled to the bottom
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        // Load more data when reaching the bottom
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http
        .get(Uri.parse('https://reqres.in/api/users?page=$page&per_page=11'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<User> userList = [];

      for (var user in data['data']) {
        userList.add(User.fromJson(user));
      }

      setState(() {
        users.addAll(userList);
        isLoading = false;
        page++;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception(
          'Failed to load data. Status Code: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Third Screen'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: ListView.builder(
                controller: _scrollController,
                itemCount: users.length + 1,
                itemBuilder: (context, index) {
                  if (index == users.length) {
                    return _buildLoader();
                  } else {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(users[index].avatar),
                      ),
                      title: Text(users[index].firstName),
                      subtitle: Text(users[index].email),
                      onTap: () {
                        _handleUserTap(users[index].firstName);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoader() {
    return isLoading
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : users.isEmpty
            ? Center(
                child: Text('Tidak ada pengguna yang ditemukan.'),
              )
            : Container();
  }

  Future<void> _handleRefresh() async {
    // Reset the page count and clear the existing users
    setState(() {
      page = 1;
      users.clear();
    });

    // Load data again
    await _loadData();
  }

  void _handleUserTap(String selectedUserName) {
    // Replace the selected user's name in the Second Screen
    Navigator.pop(context, selectedUserName);
  }
}

class User {
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  User({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}
