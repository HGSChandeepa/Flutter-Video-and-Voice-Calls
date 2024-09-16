import 'package:flutter/material.dart';
import 'package:flutter_video_call/services/login_service.dart';
import 'package:flutter_video_call/utils/utils.dart';
import '../constants/constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _userIDTextCtrl = TextEditingController(text: 'user_id');
  final _passwordVisible = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();

    getUniqueUserId().then((userID) async {
      setState(() {
        _userIDTextCtrl.text = userID;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            logo(),
            const SizedBox(height: 50),
            userIDEditor(),
            passwordEditor(),
            const SizedBox(height: 30),
            signInButton(),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Center(
      child: Image.asset(
        'assets/image.png',
        width: 200,
        height: 200,
      ),
    );
  }

  Widget userIDEditor() {
    return TextFormField(
      controller: _userIDTextCtrl,
      decoration: const InputDecoration(
        labelText: 'Phone Num.(User for user id)',
      ),
    );
  }

  Widget passwordEditor() {
    return ValueListenableBuilder<bool>(
      valueListenable: _passwordVisible,
      builder: (context, isPasswordVisible, _) {
        return TextFormField(
          obscureText: !isPasswordVisible,
          decoration: InputDecoration(
            labelText: 'Password.(Any character for test)',
            suffixIcon: IconButton(
              icon: Icon(
                isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                _passwordVisible.value = !_passwordVisible.value;
              },
            ),
          ),
        );
      },
    );
  }

  Widget signInButton() {
    return ElevatedButton(
      onPressed: _userIDTextCtrl.text.isEmpty
          ? null
          : () async {
              login(
                userID: _userIDTextCtrl.text,
                userName: 'user_${_userIDTextCtrl.text}',
              ).then((value) {
                onUserLogin();

                Navigator.pushNamed(
                  context,
                  PageRouteNames.home,
                );
              });
            },
      child: const Text('Sign In', style: textStyle),
    );
  }
}
