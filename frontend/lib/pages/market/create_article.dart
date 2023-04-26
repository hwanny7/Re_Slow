import 'package:flutter/material.dart';
import 'package:reslow/widgets/common/custom_app_bar.dart';

class CreateArticle extends StatefulWidget {
  const CreateArticle({Key? key}) : super(key: key);

  @override
  _CreateArticleState createState() => _CreateArticleState();
}

class _CreateArticleState extends State<CreateArticle> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Hello',
      ),
      body: Text('만들어보자!'),
    ));
  }
}
