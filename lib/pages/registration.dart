import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import '/utils/network_service.dart';
import '/widgets/form_button.dart';
import '/widgets/input_field.dart';

class SimpleRegisterScreen extends StatefulWidget {
  const SimpleRegisterScreen({Key? key}) : super(key: key);

  @override
  _SimpleRegisterScreenState createState() => _SimpleRegisterScreenState();
}

class _SimpleRegisterScreenState extends State<SimpleRegisterScreen> {
  late String email, password, confirmPassword;
  String? emailError, passwordError;

  String? name;

  String? address;

  String? mobile;

  String role = "1";

  @override
  void initState() {
    super.initState();
    email = "";
    name = "";
    address = "";

    mobile = "";
    password = "";
    confirmPassword = "";

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

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        passwordError = "Please enter a password";
      });
      isValid = false;
    }
    if (password.isEmpty) {
      setState(() {
        passwordError = "Please enter address";
      });
      isValid = false;
    }
    if (password != confirmPassword) {
      setState(() {
        passwordError = "Passwords do not match";
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      register(email, password, name, address, mobile);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  SizedBox(height: screenHeight * .025),
                  const Text(
                    "Create Account,",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * .01),
                  Text(
                    "Sign up to get started!",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(.6),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Lottie.network(
                        "https://assets10.lottiefiles.com/private_files/lf30_e6aaw5jt.json",
                        height: 150),
                  ),
                  InputField(
                    onChanged: (value) {
                      setState(() {
                        name = value;
                      });
                    },
                    labelText: "Name",
                    // errorText: ageError,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: screenHeight * .025),
                  InputField(
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
                  SizedBox(height: screenHeight * .025),
                  InputField(
                    onChanged: (value) {
                      setState(() {
                        address = value;
                      });
                    },
                    labelText: "Address",
                    // errorText: addressError,
                    minLine: 1,
                    maxLine: 5,
                    textInputAction: TextInputAction.newline,
                    keyboardType: TextInputType.multiline,
                    autoFocus: true,
                  ),
                  SizedBox(height: screenHeight * .025),
                  InputField(
                    onChanged: (value) {
                      setState(() {
                        mobile = value;
                      });
                    },
                    labelText: "mobile",
                    // errorText: ageError,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: screenHeight * .025),
                  InputField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    labelText: "Password",
                    errorText: passwordError,
                    obscureText: true,
                    textInputAction: TextInputAction.next,
                  ),
                  SizedBox(height: screenHeight * .025),
                  InputField(
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                      });
                    },
                    onSubmitted: (value) => submit(),
                    labelText: "Confirm Password",
                    errorText: passwordError,
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                  ),
                  SizedBox(
                    height: screenHeight * .025,
                  ),
                  FormButton(
                    text: "Sign Up",
                    onPressed: submit,
                  ),
                  SizedBox(
                    height: screenHeight * .025,
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: RichText(
                      text: const TextSpan(
                        text: "I'm already a member, ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sign In",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  register(String? email, String? password, String? name, String? address,
      String? mobile) {
    Fluttertoast.showToast(msg: 'registering, Please wait');
    getData("page_register.php", params: {
      "name": name,
      "address": address,
      "email": email,
      "password": password,
      "username": email,
      "mobile": mobile,
    }).then((value) {
      if (value['message']) {
        Fluttertoast.showToast(msg: 'registered')
            .then((value) => Navigator.pop(context));
      } else {
        Fluttertoast.showToast(msg: 'registration failed');
      }
    });
  }
}
