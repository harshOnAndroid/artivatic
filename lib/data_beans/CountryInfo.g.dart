// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CountryInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryInfo _$CountryInfoFromJson(Map<String, dynamic> json) {
  $checkKeys(
    json,
    disallowNullValues: const ['title', 'rows'],
  );
  return CountryInfo(
    title: json['title'] as String? ?? '',
    properties: (json['rows'] as List<dynamic>?)
            ?.map((e) => InfoProperty.fromJson(e as Map<String, dynamic>))
            .toList() ??
        [],
  );
}

Map<String, dynamic> _$CountryInfoToJson(CountryInfo instance) =>
    <String, dynamic>{
      'title': instance.title,
      'rows': instance.properties.map((e) => e.toJson()).toList(),
    };
