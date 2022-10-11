import 'dart:io';

import 'package:artivatic_exercise/api_management/APIResponse.dart';
import 'package:artivatic_exercise/country_info/CountryInfoScreen.dart';
import 'package:artivatic_exercise/data_beans/CountryInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'ut_country_info.dart';

dynamic _successfulResponse = {
  "title": "About Canada",
  "rows": [
    {
      "title": "Beavers",
      "description":
          "Beavers are second only to humans in their ability to manipulate and change their environment. They can measure up to 1.3 metres long. A group of beavers is called a colony",
      "imageHref":
          "http://upload.wikimedia.org/wikipedia/commons/thumb/6/6b/American_Beaver.jpg/220px-American_Beaver.jpg"
    },
    {
      "title": "Flag",
      "description": null,
      "imageHref": "http://images.findicons.com/files/icons/662/world_flag/128/flag_of_canada.png"
    },
  ]
};

Widget countryInfoScreenMock(MockCountryInfoBloc bloc, dynamic initialData) => MaterialApp(
  home: Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
        title: TitleText(
          bloc: bloc,
        )),
    body: StreamBuilder<CountryInfo?>(
        stream: bloc.propertiesStream,
        initialData: initialData,
        builder: (context, snapshot) {
          if (snapshot.data == null) return Container(key: const ValueKey("shimmer"));

          return PropertiesListView(countryInfo: snapshot.data!);
        }),
  ),
);

void main() {
  late MockCountryInfoBloc bloc;
  late MockCountryInfoViewContract contract;
  late MockCountryInfoService service;
  late APIResponse apiResponse;
  CountryInfo countryInfo = CountryInfo();

  setUp(() {
    contract = MockCountryInfoViewContract();
    bloc = MockCountryInfoBloc();
    service = MockCountryInfoService.getInstance(contract);
    apiResponse = APIResponse(200, "Success", _successfulResponse);

    when(() => service.listScreenViewContract!.onListFetchSuccessful(apiResponse)).thenAnswer((invocation) async {
      countryInfo = CountryInfo.fromJson(apiResponse.response);
      bloc.onInfoFetched(apiResponse);
    });

    when(() => service.getCountryInfo()).thenAnswer((invocation) async {
      service.listScreenViewContract!.onListFetchSuccessful(apiResponse);
    });

    when(() => bloc.fetchCountryInfo()).thenAnswer((invocation) async {
      service.getCountryInfo();
    });
  });

  testWidgets('Displays shimmer when data is being fetched', (WidgetTester tester) async {
    await tester.pumpWidget(
      countryInfoScreenMock(bloc, null),
    );

    final shimmer = find.byKey(const ValueKey("shimmer"));
    expect(shimmer, findsOneWidget);
    final lv = find.byKey(const ValueKey("listview"));
    expect(lv, findsNothing);
  });

  testWidgets('Listview is visible when data is loaded', (WidgetTester tester) async {
    await tester.pumpWidget(
      countryInfoScreenMock(bloc, countryInfo),
    );

    final shimmer = find.byKey(const ValueKey("shimmer"));
    expect(shimmer, findsNothing);
    final lv = find.byKey(const ValueKey("listview"));
    expect(lv, findsOneWidget);
  });
}
