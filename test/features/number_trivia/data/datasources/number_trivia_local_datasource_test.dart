import 'dart:convert';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

main() {
  late NumberTriviaLocalDatasourceImpl dataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDatasourceImpl(
        sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

    test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache.',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any()))
          .thenReturn(fixture('trivia_cached.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();
      //assert
      verify(() => mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, tNumberTriviaModel);
    });

    test('should throw a CacheException when there is not a cached value.',
        () async {
      // arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
      verify(() => mockSharedPreferences.getString(cachedNumberTrivia));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

    test('should call SharedPreferences to cache the data.', () async {
      //arrange
      when(() => mockSharedPreferences.setString(any(), any()))
          .thenAnswer((_) async => true);
      //act
      await dataSource.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJson = jsonEncode(tNumberTriviaModel.toJson());
      verify(() =>
          mockSharedPreferences.setString(cachedNumberTrivia, expectedJson));
    });
  });
}
