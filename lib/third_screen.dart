import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
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
        centerTitle: true,
        title: Text(
          'Third Screen',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF04021D),
            fontSize: 18,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            height: 0.08,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0XFF554AF0),
          ), 
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0), 
          child: Divider(
            color: Color(0xFFDCDCDC), 
            thickness: 0.5,
          ),
        ),
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
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            leading: ClipOval(
                              child: Image.network(
                                users[index].avatar,
                                width: 49.0,
                                height: 49.0,
                                fit: BoxFit.fill,
                              ),
                            ),
                            title: Text(
                              '${users[index].firstName} ${users[index].lastName}',
                              style: TextStyle(
                                color: Color(0xFF04021D),
                                fontSize: 16,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            subtitle: Text(
                              users[index].email.toUpperCase(),
                              style: TextStyle(
                                color: Color(0xFF686777),
                                fontSize: 10,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                height: 0,
                              ),
                            ),
                            onTap: () {
                              _handleUserTap(
                                '${users[index].firstName} ${users[index].lastName}',
                              );
                            },
                          ),
                          Divider(
                            height: 1,
                            thickness: 0.5,
                            color: Color(0xFFDCDCDC),
                          ),
                        ],
                      ),
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
    if (isLoading) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (users.isEmpty) {
      return Center(
        child: Text('No users found.'),
      );
    } else {
      return Container(); 
    }
  }

  Future<void> _handleRefresh() async {
    try {
      setState(() {
        page = 1;
        users.clear();
      });


      await _loadData();
    } catch (e) {

      print('Error during refresh: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to refresh data. Please try again.'),
        ),
      );
    }
  }

  void _handleUserTap(String selectedUserName) {
    print('Selected User Name: $selectedUserName');
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
