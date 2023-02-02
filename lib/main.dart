import 'package:exception_handling/provider/post_change_notifier.dart';
import 'package:flutter/material.dart';

import 'modal/post_service.dart';
import 'package:provider/provider.dart';

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
      home: ChangeNotifierProvider(
        create: (context) => PostChangeMotifier(PostService()),
        child: HomeScreen(title: 'Exception Handling Part 1'),
      ),
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
  final PostService _postService = PostService();

  Future<PostModal>? postFuture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Consumer<PostChangeMotifier>(builder: (_, notifier, __) {
              if (notifier.state == NotifierState.initial) {
                return const StyledText('Press the button');
              } else if (notifier.state == NotifierState.loading) {
                return const CircularProgressIndicator();
              } else {
                return notifier.post!.fold(
                    (failure) => StyledText(failure.toString()),
                    (success) => StyledText(success.toString()));
              }
            }),
            MaterialButton(
              color: Colors.blue,
              child: const Text(
                'Get Post',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Provider.of<PostChangeMotifier>(context,listen: false).getPost();
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
  const StyledText(this.text);

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
