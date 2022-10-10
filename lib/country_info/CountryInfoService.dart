import 'package:artivatic_exercise/api_management/APIConstants.dart';
import 'package:artivatic_exercise/api_management/APIResponse.dart';
import 'package:artivatic_exercise/api_management/NetworkServiceManager.dart';
import 'package:artivatic_exercise/country_info/CountryInfoViewContract.dart';
import 'package:flutter/material.dart';

class CountryInfoService {
  static CountryInfoService? _instance;
  late CountryInfoViewContract? listScreenViewContract;
  late NetworkServiceManager networkManager;

  CountryInfoService._(this.listScreenViewContract) {
    networkManager = NetworkServiceManager.getInstance();
  }

  static CountryInfoService getInstance(CountryInfoViewContract view) =>
      _instance = _instance ?? CountryInfoService._(view);

  dispose() {
    _instance = null;
    listScreenViewContract = null;
  }
}
