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

void main() {}
