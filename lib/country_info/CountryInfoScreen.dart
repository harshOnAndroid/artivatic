import 'dart:async';

import 'package:artivatic_exercise/api_management/APIResponse.dart';
import 'package:artivatic_exercise/components/ShimmerView.dart';
import 'package:artivatic_exercise/country_info/CountryInfoViewContract.dart';
import 'package:artivatic_exercise/country_info/CountryInfoBloc.dart';
import 'package:artivatic_exercise/data_beans/CountryInfo.dart';
import 'package:artivatic_exercise/data_beans/InfoProperty.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class CountryInfoScreen extends StatefulWidget {
  const CountryInfoScreen({Key? key}) : super(key: key);

  @override
  State<CountryInfoScreen> createState() => _CountryInfoScreenState();
}

class _CountryInfoScreenState extends State<CountryInfoScreen> implements CountryInfoViewContract {
  late CountryInfoBloc _countryInfoBloc;
  final PublishSubject _searchSubject = PublishSubject<String>();
  late StreamSubscription _searchStreamSubscription;
  late final TextEditingController _textController = TextEditingController();
  late double _screenWidth;

  @override
  void initState() {
    _countryInfoBloc = CountryInfoBloc.getInstance(this);
    _countryInfoBloc.fetchCountryInfo();
    _searchStreamSubscription =
        _searchSubject.stream.debounceTime(const Duration(milliseconds: 300)).listen((searchString) {
          if (searchString.isNotEmpty)
            _countryInfoBloc.filter(searchString);
          else
            _countryInfoBloc.publishUnfilteredData();
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.85),
      body: RefreshIndicator(
        onRefresh: () async {
          _textController.text = '';
          return _countryInfoBloc.fetchCountryInfo();
        },
        child: Column(
          children: [
            AppBar(title: TitleText(bloc: _countryInfoBloc,)),
            _searchBox(),
            Expanded(
              child: StreamBuilder<CountryInfo?>  (
                  stream: _countryInfoBloc.propertiesStream,
                  initialData: CountryInfo(),
                  builder: (context, snapshot) {
                    if (snapshot.data == null) return _errorText;

                    CountryInfo countryInfo = snapshot.data!;

                    if (countryInfo.title.isEmpty) return _shimmerView();

                    return PropertiesListView(countryInfo: countryInfo,);
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget get _errorText => const Center(
    child: Text("Something went wrong!"),
  );

  _searchBox() {
    return Container(
      key: UniqueKey(),
      height: 50,
      color: Colors.white,
      padding: const EdgeInsets.all(6),
      child: TextField(
        controller: _textController,
        onChanged: (newTxt) {
          _searchSubject.add(newTxt);
        },
        decoration: const InputDecoration(hintText: "Search by title"),
        maxLines: 1,
      ),
    );
  }

  _shimmerView() {
    return ListView(
      key: const ValueKey("shimmer_view"),
      children: [
        _shimmerItem(),
        _shimmerItem(),
        _shimmerItem(),
        _shimmerItem(),
      ],
    );
  }

  _shimmerItem() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ShimmerView(height: _screenWidth, width: _screenWidth, radius: 13),
          const SizedBox(height: 10),
          ShimmerView(height: 12, width: 120, radius: 4),
          const SizedBox(height: 6),
          ShimmerView(height: 8, width: double.infinity, radius: 4),
          ShimmerView(height: 8, width: 120, radius: 4),
        ],
      ),
    );
  }

  @override
  onListFetchFailure(APIResponse response) {
    _countryInfoBloc.onInfoFetched(response);
  }

  @override
  onListFetchSuccessful(APIResponse response) {
    _countryInfoBloc.onInfoFetched(response);
  }
}

class PropertiesListView extends StatelessWidget {
  final CountryInfo countryInfo;
  const PropertiesListView({Key? key, required this.countryInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      key: const ValueKey("listview"),
      itemCount: countryInfo.properties.length,
      padding: const EdgeInsets.symmetric(vertical: 12),
      itemBuilder: (bc, i) => countryInfo.properties[i].hasNoData
          ? Container()
          : _PropertyItem(infoProperty: countryInfo.properties[i]),
    );
  }
}


class TitleText extends StatelessWidget {
  final CountryInfoBloc bloc;
  const TitleText({Key? key, required this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CountryInfo?>(
        stream: bloc.propertiesStream,
        initialData: CountryInfo(),
        builder: (context, snapshot) {
          String title = snapshot.data == null ? '' : snapshot.data!.title;

          return Text(title, key: const ValueKey("title"), );
        });
  }
}

class _PropertyItem extends StatelessWidget {
  final InfoProperty infoProperty;

  const _PropertyItem({Key? key, required this.infoProperty}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxFit imgFit = BoxFit.cover;
    return Container(
      width: double.infinity,
      // height: 80,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.hardEdge,
      child: Material(
        child: InkWell(
          onTap: () {
            print("on tap");
          },
          splashColor: Colors.white60,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(13)),
                  clipBehavior: Clip.hardEdge,
                  child: infoProperty.image.isEmpty
                      ? Image.asset(
                    'images/im_image_not_found.png',
                    fit: imgFit,
                    width: double.infinity,
                  )
                      : CachedNetworkImage(
                      imageUrl: infoProperty.image,
                      fit: imgFit,
                      width: double.infinity,
                      errorWidget: (bc, url, err) => Image.asset(
                        'images/im_image_not_found.png',
                        fit: imgFit,
                        width: double.infinity,
                      ),
                      placeholder: (bc, url) => Image.asset(
                        'images/im_placeholder.jpeg',
                        width: double.infinity,
                        fit: imgFit,
                      )
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  infoProperty.title,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 6),
                Text(
                  infoProperty.description,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
