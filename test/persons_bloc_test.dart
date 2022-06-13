import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning_bloc/bloc/bloc_actions.dart';
import 'package:learning_bloc/bloc/persons_block.dart';
import 'package:learning_bloc/model/fetch_result.dart';
import 'package:learning_bloc/model/person.dart';

const mockedPersons1 = [
  Person(
    name: 'Foo',
    age: 20,
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

const mockedPersons2 = [
  Person(
    name: 'Foo',
    age: 20,
  ),
  Person(
    name: 'Bar',
    age: 30,
  ),
];

Future<Iterable<Person>> mockGetPersons1(String url) => Future.value(
      mockedPersons1,
    );

Future<Iterable<Person>> mockGetPersons2(String url) => Future.value(
      mockedPersons2,
    );

void main() {
  group(
    'testing bloc',
    () {
      late PersonsBloc personsBloc;

      setUp(
        () {
          personsBloc = PersonsBloc();
        },
      );

      blocTest<PersonsBloc, FetchResult?>(
        'test initial state',
        build: () => personsBloc,
        verify: (bloc) => bloc.state == null,
      );

      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from first iterable',
        build: () => personsBloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonAction(
              personUrl: 'dummy url',
              loader: mockGetPersons1,
            ),
          );
          bloc.add(
            const LoadPersonAction(
              personUrl: 'dummy url',
              loader: mockGetPersons1,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons1,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons1,
            isRetrievedFromCache: true,
          ),
        ],
      );

      blocTest<PersonsBloc, FetchResult?>(
        'Mock retrieving persons from second iterable',
        build: () => personsBloc,
        act: (bloc) {
          bloc.add(
            const LoadPersonAction(
              personUrl: 'dummy url2',
              loader: mockGetPersons2,
            ),
          );
          bloc.add(
            const LoadPersonAction(
              personUrl: 'dummy url2',
              loader: mockGetPersons2,
            ),
          );
        },
        expect: () => [
          const FetchResult(
            persons: mockedPersons2,
            isRetrievedFromCache: false,
          ),
          const FetchResult(
            persons: mockedPersons2,
            isRetrievedFromCache: true,
          ),
        ],
      );
    },
  );
}
