import 'package:flutter/material.dart';
import 'third_screen.dart';

class SecondScreen extends StatefulWidget {
  final String name;

  SecondScreen({required this.name});

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String selectedUserName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        'Second Screen',
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
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildWelcomeText(),
          SizedBox(height: 16.0),
          buildUserNameText(),
          Spacer(),
          buildSelectedUserNameText(),
          Spacer(),
          buildChooseUserButton(),
        ],
      ),
    );
  }

  Text buildWelcomeText() {
    return Text(
      'Welcome',
      style: TextStyle(
        color: Color(0xFF04021D),
        fontSize: 12,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        height: 0.25,
      ),
    );
  }

  Text buildUserNameText() {
    return Text(
      '${widget.name}',
      style: TextStyle(
        color: Color(0xFF04021D),
        fontSize: 18,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        height: 0.11,
      ),
    );
  }

  Center buildSelectedUserNameText() {
    return Center(
      child: Text(
        selectedUserName.isNotEmpty
            ? '$selectedUserName'
            : 'Selected User Name',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Color(0xFF04021D),
          fontSize: 24,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          height: 0.06,
        ),
      ),
    );
  }

  Center buildChooseUserButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  ThirdScreen(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                const begin = Offset(0.0, 1.0);
                const end = Offset.zero;
                const curve = Curves.easeInOutQuart;

                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));

                var offsetAnimation = animation.drive(tween);

                return SlideTransition(
                  position: offsetAnimation,
                  child: child,
                );
              },
            ),
          );

          if (result != null && result is String) {
            // Debug statements to check the flow
            print('Received user name from ThirdScreen: $result');
            setState(() {
              selectedUserName = result;
            });
            print('Updated selectedUserName: $selectedUserName');
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF2A637B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Container(
          width: 310,
          height: 41,
          child: Center(
            child: Text(
              'Choose a User',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
