import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:she/pages/home_page.dart';
import '/utils/network_service.dart';
import '/pages/registration.dart';
import '/widgets/form_button.dart';
import '/widgets/input_field.dart';

class SimpleLoginScreen extends StatefulWidget {
  const SimpleLoginScreen({Key? key}) : super(key: key);
  @override
  _SimpleLoginScreenState createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<SimpleLoginScreen> {
  late String email, password;
  String? emailError, passwordError;
  BuildContext? myContext;

  var checker = false;

  @override
  void initState() {
    super.initState();
    email = "";
    password = "";

    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = "Email is invalid";
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = "Please enter a password";
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      login(email, password, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    myContext = context;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: ListView(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Lottie.network(
                'https://assets7.lottiefiles.com/private_files/lf30_twbpyk8b.json',
                height: 220),
          ),
          Visibility(
            child: Center(child: CircularProgressIndicator()),
            visible: checker,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InputField(
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              labelText: "Email",
              errorText: emailError,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autoFocus: true,
            ),
          ),
          SizedBox(height: screenHeight * .025),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: InputField(
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              onSubmitted: (val) => submit(),
              labelText: "Password",
              errorText: passwordError,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
          ),
          SizedBox(
            height: screenHeight * .055,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: FormButton(
              text: "Log In",
              onPressed: submit,
            ),
          ),
          SizedBox(
            height: screenHeight * .015,
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SimpleRegisterScreen(),
              ),
            ),
            child: RichText(
              text: const TextSpan(
                text: "I'm a new user, ",
                style: TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: "Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Lottie.network(
              "https://assets7.lottiefiles.com/packages/lf20_bnpqzbat.json")
        ],
      ),
    );
  }

  login(String? email, String? password, context) {
    getData("page_login.php", params: {
      "username": email,
      "password": password,
    }).then((value) async {
      if (value['message'] as bool) {
        // Obtain shared preferences.
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_id', value['id']);
        Fluttertoast.showToast(msg: "welcome.");

        Route route = MaterialPageRoute(builder: (context) => HomePage());
        Navigator.pushReplacement(myContext!, route);
      } else {
        Fluttertoast.showToast(msg: "username or password incorrect.");
      }
    });
  }
}
