import 'package:artivatic_exercise/api_management/APIResponse.dart';

abstract class CountryInfoViewContract {
  onListFetchSuccessful(APIResponse response);

  onListFetchFailure(APIResponse response);
}