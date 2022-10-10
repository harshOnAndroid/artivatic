import 'dart:async';

import 'package:artivatic_exercise/api_management/APIResponse.dart';
import 'package:artivatic_exercise/country_info/CountryInfoViewContract.dart';
import 'package:artivatic_exercise/country_info/CountryInfoBloc.dart';
import 'package:flutter/material.dart';

class CountryInfoScreen extends StatefulWidget {
  const CountryInfoScreen({Key? key}) : super(key: key);

  @override
  State<CountryInfoScreen> createState() => _CountryInfoScreenState();
}

class _CountryInfoScreenState extends State<CountryInfoScreen> implements CountryInfoViewContract {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.85),
      body: Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  onListFetchFailure(APIResponse response) {}

  @override
  onListFetchSuccessful(APIResponse response) {}
}
