import 'package:artivatic_exercise/api_management/APIResponse.dart';
import 'package:artivatic_exercise/country_info/CountryInfoBloc.dart';
import 'package:artivatic_exercise/country_info/CountryInfoScreen.dart';
import 'package:artivatic_exercise/country_info/CountryInfoService.dart';
import 'package:artivatic_exercise/country_info/CountryInfoViewContract.dart';
import 'package:artivatic_exercise/data_beans/CountryInfo.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rxdart/rxdart.dart';

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

    when(() => service.listScreenViewContract!.onListFetchSuccessful(apiResponse)).thenAnswer((invocation) async{
      countryInfo = CountryInfo.fromJson(apiResponse.response);
    });

    when(() => service.getCountryInfo()).thenAnswer((invocation) async {
      service.listScreenViewContract!.onListFetchSuccessful(apiResponse);
    });

    when(() => bloc.fetchCountryInfo()).thenAnswer((invocation) async {
      service.getCountryInfo();
    });
  });

  test("getCountryInfo() is called", () async {
    countryInfo = CountryInfo();
    await bloc.fetchCountryInfo();

    verify(() => service.getCountryInfo()).called(1);
  });

  test("Country info data is parsed correctly", () async {
    countryInfo = CountryInfo();
    await bloc.fetchCountryInfo();

    expect(countryInfo.title, "About Canada");
    expect(countryInfo.properties.length, 2);
  });
}

class MockCountryInfoService extends Mock implements CountryInfoService {
  static MockCountryInfoService? _instance;
  late CountryInfoViewContract? listScreenViewContract;

  MockCountryInfoService._(this.listScreenViewContract);

  static MockCountryInfoService getInstance(CountryInfoViewContract view) => MockCountryInfoService._(view);
}

class MockCountryInfoViewContract extends Mock implements CountryInfoViewContract {}

class MockCountryInfoBloc extends Mock implements CountryInfoBloc {
  late BehaviorSubject<CountryInfo?> _propertiesSubject;
  late Stream<CountryInfo?> propertiesStream;

  MockCountryInfoBloc() {
    _propertiesSubject = BehaviorSubject<CountryInfo?>();
    propertiesStream = _propertiesSubject.stream;
  }
}
