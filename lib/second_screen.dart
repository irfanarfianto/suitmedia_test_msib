import 'package:flutter/material.dart';
import 'third_screen.dart';

class SecondScreen extends StatelessWidget {
  final String name;
  final User? selectedUser;

  SecondScreen({required this.name, required this.selectedUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selamat Datang'),
            SizedBox(height: 16.0),
            Text('Nama Acara: Palindrome Checker'),
            SizedBox(height: 16.0),
            Text('Nama Pengguna yang Dipilih: $name'),
            SizedBox(height: 16.0),
            Text('Data Pengguna dari Layar Ketiga:'),
            if (selectedUser != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${selectedUser!.email}'),
                  Text('Nama Depan: ${selectedUser!.firstName}'),
                  Text('Nama Belakang: ${selectedUser!.lastName}'),
                ],
              )
            else
              Text('Tidak ada pengguna yang dipilih'),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ThirdScreen()),
                );
              },
              child: Text('Pilih Pengguna'),
            ),
          ],
        ),
      ),
    );
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
