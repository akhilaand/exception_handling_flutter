import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:exception_handling/modal/post_service.dart';
import 'package:exception_handling/provider/post_change_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements PostService {}

void main() {
  late PostChangeMotifier sut;
  late MockNewsService mockNewService;
  setUp(() {
    mockNewService = MockNewsService();
    sut = PostChangeMotifier(mockNewService);
  });

  test("for checking initial values are correct", () {
    expect(sut.state, NotifierState.initial);
  });

  group("getArticles", () {
    void returnDummyPostValues() {
      when(() => mockNewService.getOnePost()).thenAnswer(
          (_) async => PostModal(userId: 1, title: "title", body: "body"));
    }

    // test("gets article from service", () async {
    //   when(() => mockNewService.getOnePost()).thenAnswer(
    //       (_) async => PostModal(userId: 1, title: "title", body: "body"));
    //   await sut.getPost();
    //   verify((() => mockNewService.getOnePost())).called(1);
    // });

    test("check for variables assigns properly", () async {
      when(() => mockNewService.getOnePost()).thenAnswer(
          (_) async => PostModal(userId: 1, title: "title", body: "body"));
      final result = sut.getPost();
      expect(sut.state, NotifierState.loading);
      await result;

      final eitherResult = sut.post?.fold((l) => l, (r) => r);
      expect(eitherResult, isA<PostModal>());
      expect(sut.state, NotifierState.loaded);
    });
  });
}
