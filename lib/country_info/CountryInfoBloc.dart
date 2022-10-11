import 'package:artivatic_exercise/api_management/APIResponse.dart';
import 'package:artivatic_exercise/country_info/CountryInfoService.dart';
import 'package:artivatic_exercise/country_info/CountryInfoViewContract.dart';
import 'package:artivatic_exercise/data_beans/CountryInfo.dart';
import 'package:artivatic_exercise/data_beans/InfoProperty.dart';
import 'package:rxdart/rxdart.dart';

/**
 * This class is a BLoC for the CountryInfo screen.
 * This class is responsible for listening to the calls from the UI screen and processing the
 * requests accordingly. On the other hand it is also responsible for pushing data/event to
 * the UI screen.
 * **/

class CountryInfoBloc {
  late BehaviorSubject<CountryInfo?> _propertiesSubject;
  CountryInfo _countryInfo = CountryInfo();
  late CountryInfoService service;
  CountryInfoViewContract viewContract;

  Stream<CountryInfo?> get propertiesStream => _propertiesSubject.stream;

  static CountryInfoBloc? _instance;

  CountryInfoBloc._(this.viewContract) {
    _propertiesSubject = BehaviorSubject<CountryInfo?>();
    service = CountryInfoService.getInstance(viewContract);
  }

  static CountryInfoBloc getInstance(CountryInfoViewContract viewContract) =>
      _instance = _instance ?? CountryInfoBloc._(viewContract);

  void dispose() {
    _propertiesSubject.close();
  }

  fetchCountryInfo() async => service.getCountryInfo();

  onInfoFetched(APIResponse response) {
    if (response.response == null) {
      _propertiesSubject.add(null);
      return;
    }

    _countryInfo = CountryInfo.fromJson(response.response);
    _propertiesSubject.add(_countryInfo);
  }

  void filter(String searchString) {
    List<InfoProperty> filteredList = _countryInfo.properties
        .where((element) => element.title.toLowerCase().contains(searchString.toLowerCase()))
        .toList();

    CountryInfo filteredInfo = CountryInfo()
      ..title = _countryInfo.title
      ..properties = filteredList;

    _propertiesSubject.add(filteredInfo);
  }

  void publishUnfilteredData() {
    _propertiesSubject.add(_countryInfo);
  }
}
