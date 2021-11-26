import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late NumberTriviaRemoteDatasourceImpl datasource;
  late MockHttpClient mockHttpClient;

  setUpAll(() {
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = NumberTriviaRemoteDatasourceImpl(client: mockHttpClient);
  });

  void setUpMockHttpClientSuccess200() {
    when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
        .thenAnswer(
      (_) async => http.Response(fixture("trivia.json"), 200),
    );
  }

  void setUpMockHttpClientFailure404() {
    when(() => mockHttpClient.get(any(), headers: any(named: "headers")))
        .thenAnswer(
      (_) async => http.Response("A error here", 404),
    );
  }

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    var tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture("trivia.json")));

    test(
        "Should do a GET on a URL passing the number as param and with application/json as header.",
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      datasource.getConcreteNumberTrivia(tNumber);
      // assert
      verify(() => mockHttpClient.get(
          Uri.parse("http://numbersapi.com/$tNumber"),
          headers: {'Content-Type': 'application/json'}));
    });

    test(
        "Should return a NumberTriviaModel when the response code is 200 (success)",
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await datasource.getConcreteNumberTrivia(tNumber);
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "Should throw a ServerException when the response code is 404 or other",
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = datasource.getConcreteNumberTrivia;
      // assert
      expect(
          () => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });


  group("getRandomNumberTrivia", () {
    var tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture("trivia.json")));

    test(
        "Should do a GET on the random number URL with application/json as header.",
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      datasource.getRandomNumberTrivia();
      // assert
      verify(() => mockHttpClient.get(
          Uri.parse("http://numbersapi.com/random"),
          headers: {'Content-Type': 'application/json'}));
    });

    test(
        "Should return a NumberTriviaModel when the response code is 200 (success)",
        () async {
      // arrange
      setUpMockHttpClientSuccess200();
      // act
      final result = await datasource.getRandomNumberTrivia();
      // assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        "Should throw a ServerException when the response code is 404 or other",
        () async {
      // arrange
      setUpMockHttpClientFailure404();
      // act
      final call = datasource.getRandomNumberTrivia;
      // assert
      expect(
          () => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
