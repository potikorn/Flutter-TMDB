// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VideoResponse _$VideoResponseFromJson(Map<String, dynamic> json) {
  return VideoResponse(
      id: json['id'] as int,
      results: (json['results'] as List)
          ?.map((e) =>
              e == null ? null : Video.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$VideoResponseToJson(VideoResponse instance) =>
    <String, dynamic>{'id': instance.id, 'results': instance.results};

Video _$VideoFromJson(Map<String, dynamic> json) {
  return Video(
      id: json['id'] as String,
      iso6391: json['iso_639_1'] as String,
      iso31661: json['iso_3166_1'] as String,
      key: json['key'] as String,
      name: json['name'] as String,
      site: json['site'] as String,
      size: json['size'] as int,
      type: json['type'] as String);
}

Map<String, dynamic> _$VideoToJson(Video instance) => <String, dynamic>{
      'id': instance.id,
      'iso_639_1': instance.iso6391,
      'iso_3166_1': instance.iso31661,
      'key': instance.key,
      'name': instance.name,
      'site': instance.site,
      'size': instance.size,
      'type': instance.type
    };
