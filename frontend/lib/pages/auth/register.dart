import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

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

  bool _isTyped = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final idField = TextFormField(
        autofocus: false,
        controller: idController,
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
          idController.text = value!;
        },
        onChanged: (value) {
          _idFormKey.currentState!.validate();
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          labelText: '아이디',
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
            return ("비밀번호는 필수정보 입니다.");
          }
          if (value.length < 8 || 16 < value.length) {
            return ("최소 8자, 최대 16자를 작성해주세요.");
          }
          if (!regex.hasMatch(value)) {
            return ("문자, 숫자, 특수문자를 최소 한 자씩 입력해주세요.");
          }
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
            return ("비밀번호 재확인은 필수정보입니다.");
          }
          if (_isTyped &
              !(passwordController.text == secondPasswordController.text)) {
            return ("비밀번호가 일치하지 않습니다.");
          }
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
            return ("별명은 필수정보 입니다.");
          }
          if (value.length < 2 || 16 < value.length) {
            return ("최소 2자, 최대 16자를 작성해주세요.");
          }
          if (!regex.hasMatch(value)) {
            return ("영문, 숫자, 한글 조합 2-16자");
          }
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
          prefixIcon: const Icon(Icons.vpn_key),
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
      color: const Color(0xFF165B40),
      child: MaterialButton(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            // submit(idController.text.toString(),
            //     passwordController.text.toString());
          },
          child: const Text(
            "가입하기",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
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
