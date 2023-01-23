import 'package:flutter/material.dart';

import 'modal/post_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:  HomeScreen(title: 'Exception Handling Part 1'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.title});



  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostService _postService=PostService();

  Future<PostModal>? postFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FutureBuilder<PostModal>(
              future: postFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  final error = snapshot.error.toString();
                  return StyledText(error.toString());
                } else if (snapshot.hasData) {
                  final post = snapshot.data;
                  return StyledText(post.toString(),);
                } else {
                  return const StyledText('Press the button');
                }
              },
            ),
            MaterialButton(
              color:Colors.blue,
              child: const Text('Get Post',style: TextStyle(color: Colors.white),),
              onPressed: () async {
                setState(() {
                  postFuture = _postService.getOnePost();
                });
              },
            ),
          ],
        ),
      ),
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
class StyledText extends StatelessWidget {
  const  StyledText(
      this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 40),
    );
  }
}