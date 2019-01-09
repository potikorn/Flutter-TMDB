// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credits_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreditsResponse _$CreditsResponseFromJson(Map<String, dynamic> json) {
  return CreditsResponse(
      id: json['id'] as int,
      cast: (json['cast'] as List)
          ?.map((e) =>
              e == null ? null : Crew.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      crew: (json['crew'] as List)
          ?.map((e) =>
              e == null ? null : Crew.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CreditsResponseToJson(CreditsResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'cast': instance.cast,
      'crew': instance.crew
    };

Crew _$CrewFromJson(Map<String, dynamic> json) {
  return Crew(
      castId: json['cast_id'] as int,
      character: json['character'] as String,
      creditId: json['credit_id'] as String,
      department: json['department'] as String,
      gender: json['gender'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      job: json['job'] as String,
      order: json['order'] as int,
      profilePath: json['profile_path'] as String);
}

Map<String, dynamic> _$CrewToJson(Crew instance) => <String, dynamic>{
      'cast_id': instance.castId,
      'character': instance.character,
      'credit_id': instance.creditId,
      'department': instance.department,
      'gender': instance.gender,
      'id': instance.id,
      'name': instance.name,
      'job': instance.job,
      'order': instance.order,
      'profile_path': instance.profilePath
    };
