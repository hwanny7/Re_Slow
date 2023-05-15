import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/pages/auth/register.dart';
import 'package:reslow/providers/auth_provider.dart';
import 'package:reslow/providers/user_provider.dart';
import 'package:reslow/utils/navigator.dart';
import 'package:reslow/widgets/common/loading_circle.dart';

// import 'package:fluttertoast/fluttertoast.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // form key

  String id = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    final userProvider = context.read<UserProvider>();

    final emailField = TextFormField(
        autofocus: false,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          setState(() {
            id = value;
          });
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: '아이디',
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
        obscureText: true,
        onChanged: (value) {
          setState(() {
            password = value;
          });
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          labelText: '비밀번호',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Color(0xff3C9F61),
              )),
        ));

    void submit() async {
      if (auth.loggedInStatus != Status.Authenticating) {
        Map<String, dynamic> response = await auth.login(id, password);

        if (response['status'] == true) {
          User user = User.fromJson(response['user']);
          userProvider.setUser(user);
          if (context.mounted) Navigator.pushReplacementNamed(context, '/main');
        } else {
          if (context.mounted) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('로그인 오류'),
                    content: Text(response['message']),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text(
                                  '닫기',
                                  style: TextStyle(
                                    fontSize: 22, // Set the font size to 24
                                    color: Colors
                                        .blue, // Set the font color to blue
                                    fontWeight:
                                        FontWeight.bold, // Make the text bold
                                  ),
                                ),
                              )),
                        ],
                      )
                    ],
                  );
                });
          }
        }
      }
    }

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(4),
      color: id.isNotEmpty && password.isNotEmpty
          ? const Color(0xFF165B40)
          : Colors.grey,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: id.isNotEmpty && password.isNotEmpty
              ? () {
                  submit();
                }
              : null,
          child: auth.loggedInStatus == Status.Authenticating
              ? LoadingCircle()
              : const Text(
                  "로그인하기",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
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
                              leftToRightNavigator(const Register(), context);
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

