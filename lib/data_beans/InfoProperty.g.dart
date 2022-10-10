// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InfoProperty.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InfoProperty _$InfoPropertyFromJson(Map<String, dynamic> json) => InfoProperty(
      title: json['title'] as String? ?? '',
      image: json['imageHref'] as String? ?? '',
      description: json['description'] as String? ?? '',
      hasNoData: InfoProperty._hasNoData(json, 'hasNoData') as bool? ?? false,
    );

Map<String, dynamic> _$InfoPropertyToJson(InfoProperty instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'imageHref': instance.image,
      'hasNoData': instance.hasNoData,
    };
