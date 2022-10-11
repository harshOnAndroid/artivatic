import 'package:artivatic_exercise/api_management/APIConstants.dart';
import 'package:artivatic_exercise/api_management/APIResponse.dart';
import 'package:artivatic_exercise/api_management/NetworkServiceManager.dart';
import 'package:artivatic_exercise/country_info/CountryInfoViewContract.dart';

/**
 * This is a service class. This is responsible for any API calls made for the
 * CountryInfo screen.
 * **/
class CountryInfoService {
  static CountryInfoService? _instance;
  late CountryInfoViewContract? listScreenViewContract;
  late NetworkServiceManager networkManager;

  CountryInfoService._(this.listScreenViewContract) {
    networkManager = NetworkServiceManager.getInstance();
  }

  static CountryInfoService getInstance(CountryInfoViewContract view) =>
      _instance = _instance ?? CountryInfoService._(view);

  getCountryInfo() async {
    APIResponse response = await networkManager.getCall(APIConstants.aboutCanada);

    print("RESPONSE ==> ${response.response}");
    print(" ==> ${response.status}");
    if(response.status == 200){
      listScreenViewContract!.onListFetchSuccessful(response);
    }else{
      listScreenViewContract!.onListFetchFailure(response);
    }
  }

  dispose() {
    _instance = null;
    listScreenViewContract = null;
  }
}
