import 'package:flutter/material.dart';
import 'second_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sentenceController = TextEditingController();
  FocusNode nameFocusNode = FocusNode();
  FocusNode sentenceFocusNode = FocusNode();
  bool isPalindrome = false;

  @override
  void initState() {
    super.initState();
    nameFocusNode.addListener(updateState);
    sentenceFocusNode.addListener(updateState);
  }

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildLogo(),
              buildTextField(
                controller: nameController,
                hintText: 'Name',
                focusNode: nameFocusNode,
              ),
              SizedBox(height: 16.0),
              buildTextField(
                controller: sentenceController,
                hintText: 'Sentence',
                focusNode: sentenceFocusNode,
              ),
              SizedBox(height: 16.0),
              buildElevatedButton(
                onPressed: () {
                  handleCheckButton();
                },
                label: 'Check',
              ),
              SizedBox(height: 16.0),
              buildElevatedButton(
                onPressed: () {
                  navigateToSecondScreen(context);
                },
                label: 'Next',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLogo() {
    return Container(
        margin: EdgeInsets.only(bottom: 20.0),
        child: Image(
          image: AssetImage('images/logo.png'),
          width: 150,
          height: 150,
        ));
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required FocusNode focusNode,
  }) {
    return Container(
      width: 310,
      height: 41,
      padding: EdgeInsets.symmetric(horizontal: 16),
      margin: EdgeInsets.only(bottom: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }

  Widget buildElevatedButton({
    required VoidCallback onPressed,
    required String label,
  }) {
    return Container(
      width: 310,
      height: 41,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Color(0xFF2A637B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Center(
          child: Text(
            label,
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
    );
  }

  bool validateInputs() {
    return nameController.text.trim().isNotEmpty &&
        sentenceController.text.trim().isNotEmpty;
  }

  void handleCheckButton() {
    if (validateInputs()) {
      setState(() {
        isPalindrome = checkPalindrome(sentenceController.text);
      });
      showResultDialog();
    } else {
      showInvalidInputDialog(context, 'Make sure both inputs are not empty.');
    }
  }

  void showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Palindrome Checker'),
        content: Text(isPalindrome ? 'isPalindrome' : 'notPalindrome'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void showInvalidInputDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Invalid Input'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void navigateToSecondScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SecondScreen(
          name: nameController.text,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutQuart;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  bool checkPalindrome(String text) {
    String cleanText = text.replaceAll(' ', '').toLowerCase();
    String reversedText = cleanText.split('').reversed.join();
    return cleanText == reversedText;
  }
}
