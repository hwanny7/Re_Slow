import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/providers/auth_provider.dart';
import 'package:reslow/providers/user_provider.dart';

// import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // form key
  final _formKey = GlobalKey<FormState>();
  final _idFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  bool _isInitialSubmit = true;

  // editing controller
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // firebase

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);

    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.text,
        key: _idFormKey,
        validator: (value) {
          RegExp regex = RegExp(r'^[a-zA-Z][a-zA-Z0-9]{3,15}$');
          if (value!.isEmpty) {
            return ("아이디를 입력해주세요");
          }
          if (!regex.hasMatch(value)) {
            return ("4~16자의 영문 혹은 숫자로만 입력");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value!;
        },
        onChanged: (value) {
          if (!_isInitialSubmit) {
            _formKey.currentState!.validate();
          }
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "아이디",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Color(0xff3C9F61),
              )),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        key: _passwordFormKey,
        validator: (value) {
          RegExp regex = RegExp(
              r'^(?=.*[A-Za-z])(?=.*\d)(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,16}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("문자, 숫자, 특수문자를 최소 한 개씩 입력해주세요.");
          }
        },
        onChanged: (value) {
          if (!_isInitialSubmit) {
            _formKey.currentState!.validate();
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "비밀번호",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Color(0xff3C9F61),
              )),
        ));

    void submit(String id, String password) async {
      _isInitialSubmit = false;
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        dynamic response = auth.login(id, password);
        if (response['status'] == true) {
          User user = response['user'];
          Provider.of<UserProvider>(context, listen: false).setUser(user);
          Navigator.pushReplacementNamed(context, '/main');
        } else {
          print(response['message']['message'].toString());
        }
      }
    }

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(4),
      color: const Color(0xFF165B40),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            submit(emailController.text.toString(),
                passwordController.text.toString());
          },
          child: const Text(
            "로그인하기",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(
                    //     height: 200,
                    //     child: Image.asset(
                    //       "assets/Logo_Reslow.png",
                    //       fit: BoxFit.contain,
                    //     )),
                    const SizedBox(
                      height: 45,
                    ),
                    emailField,
                    const SizedBox(height: 25),
                    passwordField,
                    const SizedBox(height: 35),
                    loginButton,
                    const SizedBox(height: 15),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("계정이 없으신가요? "),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             RegistrationScreen()));
                            },
                            child: const Text(
                              "회원가입",
                              style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}





// https://github.com/aaronksaunders/simple_firebase_auth/blob/completed-part-one/lib/main.dart
// https://medium.com/@afegbua/flutter-thursday-13-building-a-user-registration-and-login-process-with-provider-and-external-api-1bb87811fd1d

