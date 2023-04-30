import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reslow/models/user.dart';
import 'package:reslow/providers/auth_provider.dart';
import 'package:reslow/providers/user_provider.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';
import 'package:reslow/widgets/common/loading_circle.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _idFormKey = GlobalKey<FormFieldState>();
  final _nicknameFormKey = GlobalKey<FormFieldState>();
  final _passwordFormKey = GlobalKey<FormFieldState>();
  final _secondPasswordFormKey = GlobalKey<FormFieldState>();
  final TextEditingController idController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController secondPasswordController =
      TextEditingController();
  String? _idCheck;
  String? _nicknameCheck;
  // null로 자동 셋팅
  bool _isTyped = false;

  bool _idClear = false;
  bool _passwordClear = false;
  bool _secondPasswordClear = false;
  bool _nicknameClear = false;

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    final userProvider = context.read<UserProvider>();

    void setPasswordClear(bool isActive) {
      setState(() {
        _passwordClear = isActive;
      });
    }

    void setSecondPasswordClear(bool isActive) {
      setState(() {
        _secondPasswordClear = isActive;
      });
    }

    void setIdPasswordClear(bool isActive) {
      setState(() {
        _idClear = isActive;
      });
    }

    void setNicknameClear(bool isActive) {
      setState(() {
        _nicknameClear = isActive;
      });
    }

    void IdChecking(value) async {
      bool isPossible = await auth.checkId(value);
      if (!isPossible) {
        setState(() {
          _idCheck = "이미 가입한 아이디입니다.";
          _idClear = false;
        });
      } else {
        setState(() {
          _idCheck = null;
          _idClear = true;
        });
      }
    }

    void nicknameChecking(value) async {
      bool isPossible = await auth.checkNickname(value);
      if (!isPossible) {
        setState(() {
          _nicknameCheck = "이미 가입한 닉네임입니다.";
          _nicknameClear = false;
        });
      } else {
        setState(() {
          _nicknameCheck = null;
          _nicknameClear = true;
        });
      }
    }

    void submit() async {
      if (auth.registeredInStatus != Status.Registering) {
        final id = idController.text;
        final password = passwordController.text;
        final nickname = nicknameController.text;
        Map<String, dynamic> response =
            await auth.register(id, password, nickname);

        if (response['status'] == true) {
          Map<String, dynamic> response = await auth.login(id, password);

          if (response['status'] == true) {
            User user = User.fromJson(response['user']);
            userProvider.setUser(user);
            Navigator.pushReplacementNamed(context, '/main');
          } else {
            print(response['message']);
          }
        } else {
          print(response['message']);
        }
      }
    }

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final idField = TextFormField(
        autofocus: false,
        controller: idController,
        keyboardType: TextInputType.text,
        key: _idFormKey,
        validator: (value) {
          RegExp regex = RegExp(r'^[a-zA-Z0-9]{4,16}$');
          if (value!.isEmpty) {
            setIdPasswordClear(false);
            return ("아이디를 입력해주세요");
          }
          if (!regex.hasMatch(value)) {
            setIdPasswordClear(false);
            return ("영문, 숫자 4-16자");
          }
          IdChecking(value);
          return null;
        },
        onSaved: (value) {
          idController.text = value!;
        },
        onChanged: (value) {
          _idFormKey.currentState!.validate();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: '아이디',
          errorText: _idCheck,
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "영문, 숫자 4-16자",
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
            setPasswordClear(false);
            return ("비밀번호는 필수정보 입니다.");
          }
          if (value.length < 8 || 16 < value.length) {
            setPasswordClear(false);

            return ("최소 8자, 최대 16자를 작성해주세요.");
          }
          if (!regex.hasMatch(value)) {
            setPasswordClear(false);

            return ("문자, 숫자, 특수문자를 최소 한 자씩 입력해주세요.");
          }
          setPasswordClear(true);
          return null;
        },
        onChanged: (value) {
          _passwordFormKey.currentState!.validate();
          _secondPasswordFormKey.currentState!.validate();
        },
        // onSaved: (value) {
        //   passwordController.text = value!;
        // },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: '비밀번호',
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "영문, 숫자, 특수문자 조합 8-16자",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Color(0xff3C9F61),
              )),
        ));

    final secondPasswordField = TextFormField(
        autofocus: false,
        controller: secondPasswordController,
        obscureText: true,
        key: _secondPasswordFormKey,
        validator: (value) {
          if (!(value == '')) {
            _isTyped = true;
          }
          if (_isTyped & value!.isEmpty) {
            setSecondPasswordClear(false);
            return ("비밀번호 재확인은 필수정보입니다.");
          }
          if (_isTyped &
              !(passwordController.text == secondPasswordController.text)) {
            setSecondPasswordClear(false);
            return ("비밀번호가 일치하지 않습니다.");
          }
          setSecondPasswordClear(true);

          return null;
        },
        onChanged: (value) {
          _passwordFormKey.currentState!.validate();
          _secondPasswordFormKey.currentState!.validate();
        },
        // onSaved: (value) {
        //   passwordController.text = value!;
        // },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.vpn_key),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "비밀번호 재입력",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Color(0xff3C9F61),
              )),
        ));

    final nickNameField = TextFormField(
        autofocus: false,
        controller: nicknameController,
        key: _nicknameFormKey,
        validator: (value) {
          RegExp regex = RegExp(r'^[a-zA-Z0-9가-힣]{2,16}$');
          if (value!.isEmpty) {
            setNicknameClear(false);
            return ("별명은 필수정보 입니다.");
          }
          if (value.length < 2 || 16 < value.length) {
            setNicknameClear(false);

            return ("최소 2자, 최대 16자를 작성해주세요.");
          }
          if (!regex.hasMatch(value)) {
            setNicknameClear(false);

            return ("영문, 숫자, 한글 조합 2-16자");
          }
          nicknameChecking(value);
          return null;
        },
        onChanged: (value) {
          _nicknameFormKey.currentState!.validate();
        },
        // onSaved: (value) {
        //   passwordController.text = value!;
        // },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          labelText: '닉네임',
          errorText: _nicknameCheck,
          prefixIcon: const Icon(Icons.person),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "영문, 숫자, 한글 조합 2-16자",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(0),
              borderSide: const BorderSide(
                color: Color(0xff3C9F61),
              )),
        ));

    final signUpBtn = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(4),
      color:
          (_idClear & _passwordClear && _secondPasswordClear && _nicknameClear)
              ? const Color(0xFF165B40)
              : Colors.grey,
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: _idClear & _passwordClear &&
                  _secondPasswordClear &&
                  _nicknameClear
              ? () {
                  submit();
                }
              : null,
          child: auth.registeredInStatus == Status.Registering
              ? LoadingCircle()
              : const Text(
                  "가입하기",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                )),
    );

    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: '회원가입',
      ),
      body: SingleChildScrollView(
          child: Container(
        child: Padding(
            padding: EdgeInsets.all(width * 0.08),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    idField,
                    SizedBox(height: height * 0.02),
                    passwordField,
                    SizedBox(height: height * 0.01),
                    secondPasswordField,
                    SizedBox(height: height * 0.02),
                    nickNameField,
                    SizedBox(height: height * 0.02),
                    signUpBtn,
                  ]),
            )),
      )),
    ));
  }
}
