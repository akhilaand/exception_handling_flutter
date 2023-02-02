import 'package:dartz/dartz.dart';
import 'package:exception_handling/modal/post_service.dart';
import 'package:flutter/cupertino.dart';

enum NotifierState { initial, loading, loaded }

class PostChangeMotifier extends ChangeNotifier {
  final PostService _postService;
  PostChangeMotifier(this._postService);

  NotifierState _state = NotifierState.initial;
  NotifierState get state => _state;
  //for changing state
  void _changeState(NotifierState state) {
    _state = state;
    notifyListeners();
  }

  Either<Failure, PostModal>? _post;
  Either<Failure, PostModal>? get post => _post;
  //for changing post
  void _setPost(Either<Failure, PostModal>? post) {
    _post = post;
    notifyListeners();
  }

  Future<void> getPost() async {
    _changeState(NotifierState.loading);
    await Task(() => _postService.getOnePost())
        .attempt()
        .map(
          (either) => either.leftMap((l) => l as Failure),
        )
        .run()
        .then((value) => _setPost(value));
    _changeState(NotifierState.loaded);

    //   try{
    //     final post=await _postService.getOnePost();
    //     _setPost(post);
    //     _changeState(NotifierState.loaded);
    //
    //   }
    //       on Failure catch(e){
    //     _setFailure(e);
    //       }
    // }
  }
}
