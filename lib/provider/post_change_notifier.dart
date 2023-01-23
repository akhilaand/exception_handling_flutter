import 'package:exception_handling/modal/post_service.dart';
import 'package:flutter/cupertino.dart';

enum NotifierState{initial,loading,loaded}

class PostChangeMotifier extends ChangeNotifier{
  final PostService _postService=PostService();

  NotifierState _state=NotifierState.initial;
  NotifierState get state =>_state;
   //for changing state
  void _changeState(NotifierState state){
    _state=state;
    notifyListeners();
  }

  PostModal? _post;
  PostModal? get post=>_post;
   //for changing post
  void _setPost(PostModal post){
    _post=post;
    notifyListeners();
  }

  Failure? _failure;
  Failure? get failure=>_failure;
   //to set failure
  void _setFailure(Failure failure){
    _failure=failure;
    notifyListeners();
  }

  void getPost()async{
    _changeState(NotifierState.loading);
    try{
      final post=await _postService.getOnePost();
      _setPost(post);
      _changeState(NotifierState.loaded);

    }
        on Failure catch(e){
      _setFailure(e);
        }
  }
}