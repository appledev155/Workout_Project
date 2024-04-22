// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notificationpush.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetNotificationPushCollection on Isar {
  IsarCollection<NotificationPush> get notificationPushs => this.collection();
}

const NotificationPushSchema = CollectionSchema(
  name: r'notificationpush',
  id: 5001483505202311922,
  properties: {
    r'acitivities': PropertySchema(
      id: 0,
      name: r'acitivities',
      type: IsarType.stringList,
    ),
    r'challenges': PropertySchema(
      id: 1,
      name: r'challenges',
      type: IsarType.stringList,
    ),
    r'clubs': PropertySchema(
      id: 2,
      name: r'clubs',
      type: IsarType.stringList,
    ),
    r'dataselectedvalue': PropertySchema(
      id: 3,
      name: r'dataselectedvalue',
      type: IsarType.string,
    ),
    r'events': PropertySchema(
      id: 4,
      name: r'events',
      type: IsarType.stringList,
    ),
    r'friends': PropertySchema(
      id: 5,
      name: r'friends',
      type: IsarType.stringList,
    ),
    r'other': PropertySchema(
      id: 6,
      name: r'other',
      type: IsarType.stringList,
    ),
    r'posts': PropertySchema(
      id: 7,
      name: r'posts',
      type: IsarType.stringList,
    )
  },
  estimateSize: _notificationPushEstimateSize,
  serialize: _notificationPushSerialize,
  deserialize: _notificationPushDeserialize,
  deserializeProp: _notificationPushDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _notificationPushGetId,
  getLinks: _notificationPushGetLinks,
  attach: _notificationPushAttach,
  version: '3.1.0+1',
);

int _notificationPushEstimateSize(
  NotificationPush object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final list = object.acitivities;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.challenges;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.clubs;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final value = object.dataselectedvalue;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final list = object.events;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.friends;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.other;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  {
    final list = object.posts;
    if (list != null) {
      bytesCount += 3 + list.length * 3;
      {
        for (var i = 0; i < list.length; i++) {
          final value = list[i];
          bytesCount += value.length * 3;
        }
      }
    }
  }
  return bytesCount;
}

void _notificationPushSerialize(
  NotificationPush object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.acitivities);
  writer.writeStringList(offsets[1], object.challenges);
  writer.writeStringList(offsets[2], object.clubs);
  writer.writeString(offsets[3], object.dataselectedvalue);
  writer.writeStringList(offsets[4], object.events);
  writer.writeStringList(offsets[5], object.friends);
  writer.writeStringList(offsets[6], object.other);
  writer.writeStringList(offsets[7], object.posts);
}

NotificationPush _notificationPushDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = NotificationPush(
    acitivities: reader.readStringList(offsets[0]),
    challenges: reader.readStringList(offsets[1]),
    clubs: reader.readStringList(offsets[2]),
    dataselectedvalue: reader.readStringOrNull(offsets[3]),
    events: reader.readStringList(offsets[4]),
    friends: reader.readStringList(offsets[5]),
    id: id,
    other: reader.readStringList(offsets[6]),
    posts: reader.readStringList(offsets[7]),
  );
  return object;
}

P _notificationPushDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset)) as P;
    case 1:
      return (reader.readStringList(offset)) as P;
    case 2:
      return (reader.readStringList(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringList(offset)) as P;
    case 5:
      return (reader.readStringList(offset)) as P;
    case 6:
      return (reader.readStringList(offset)) as P;
    case 7:
      return (reader.readStringList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _notificationPushGetId(NotificationPush object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _notificationPushGetLinks(NotificationPush object) {
  return [];
}

void _notificationPushAttach(
    IsarCollection<dynamic> col, Id id, NotificationPush object) {
  object.id = id;
}

extension NotificationPushQueryWhereSort
    on QueryBuilder<NotificationPush, NotificationPush, QWhere> {
  QueryBuilder<NotificationPush, NotificationPush, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension NotificationPushQueryWhere
    on QueryBuilder<NotificationPush, NotificationPush, QWhereClause> {
  QueryBuilder<NotificationPush, NotificationPush, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension NotificationPushQueryFilter
    on QueryBuilder<NotificationPush, NotificationPush, QFilterCondition> {
  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'acitivities',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'acitivities',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'acitivities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'acitivities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'acitivities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'acitivities',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'acitivities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'acitivities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'acitivities',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'acitivities',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'acitivities',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'acitivities',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'acitivities',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'acitivities',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'acitivities',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'acitivities',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'acitivities',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      acitivitiesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'acitivities',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'challenges',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'challenges',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'challenges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'challenges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'challenges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'challenges',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'challenges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'challenges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'challenges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'challenges',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'challenges',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'challenges',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'challenges',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'challenges',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'challenges',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'challenges',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'challenges',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      challengesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'challenges',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'clubs',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'clubs',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clubs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'clubs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'clubs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'clubs',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'clubs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'clubs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'clubs',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'clubs',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'clubs',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'clubs',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'clubs',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'clubs',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'clubs',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'clubs',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'clubs',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      clubsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'clubs',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataselectedvalue',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataselectedvalue',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dataselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dataselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dataselectedvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'dataselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'dataselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataselectedvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataselectedvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      dataselectedvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataselectedvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'events',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'events',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'events',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'events',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'events',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'events',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'events',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'events',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'events',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'events',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'events',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'events',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      eventsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'events',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'friends',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'friends',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'friends',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'friends',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'friends',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'friends',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'friends',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'friends',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'friends',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'friends',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'friends',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'friends',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friends',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friends',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friends',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friends',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friends',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      friendsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'friends',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      idLessThan(
    Id? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'other',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'other',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'other',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'other',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'other',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'other',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'other',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'other',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'other',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'other',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'other',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'other',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'other',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'other',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'other',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'other',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'other',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      otherLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'other',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'posts',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'posts',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'posts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'posts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'posts',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'posts',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posts',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'posts',
        value: '',
      ));
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'posts',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'posts',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'posts',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'posts',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'posts',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterFilterCondition>
      postsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'posts',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension NotificationPushQueryObject
    on QueryBuilder<NotificationPush, NotificationPush, QFilterCondition> {}

extension NotificationPushQueryLinks
    on QueryBuilder<NotificationPush, NotificationPush, QFilterCondition> {}

extension NotificationPushQuerySortBy
    on QueryBuilder<NotificationPush, NotificationPush, QSortBy> {
  QueryBuilder<NotificationPush, NotificationPush, QAfterSortBy>
      sortByDataselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterSortBy>
      sortByDataselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataselectedvalue', Sort.desc);
    });
  }
}

extension NotificationPushQuerySortThenBy
    on QueryBuilder<NotificationPush, NotificationPush, QSortThenBy> {
  QueryBuilder<NotificationPush, NotificationPush, QAfterSortBy>
      thenByDataselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterSortBy>
      thenByDataselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataselectedvalue', Sort.desc);
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension NotificationPushQueryWhereDistinct
    on QueryBuilder<NotificationPush, NotificationPush, QDistinct> {
  QueryBuilder<NotificationPush, NotificationPush, QDistinct>
      distinctByAcitivities() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'acitivities');
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QDistinct>
      distinctByChallenges() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'challenges');
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QDistinct>
      distinctByClubs() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'clubs');
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QDistinct>
      distinctByDataselectedvalue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataselectedvalue',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QDistinct>
      distinctByEvents() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'events');
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QDistinct>
      distinctByFriends() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'friends');
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QDistinct>
      distinctByOther() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'other');
    });
  }

  QueryBuilder<NotificationPush, NotificationPush, QDistinct>
      distinctByPosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posts');
    });
  }
}

extension NotificationPushQueryProperty
    on QueryBuilder<NotificationPush, NotificationPush, QQueryProperty> {
  QueryBuilder<NotificationPush, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<NotificationPush, List<String>?, QQueryOperations>
      acitivitiesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'acitivities');
    });
  }

  QueryBuilder<NotificationPush, List<String>?, QQueryOperations>
      challengesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'challenges');
    });
  }

  QueryBuilder<NotificationPush, List<String>?, QQueryOperations>
      clubsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'clubs');
    });
  }

  QueryBuilder<NotificationPush, String?, QQueryOperations>
      dataselectedvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataselectedvalue');
    });
  }

  QueryBuilder<NotificationPush, List<String>?, QQueryOperations>
      eventsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'events');
    });
  }

  QueryBuilder<NotificationPush, List<String>?, QQueryOperations>
      friendsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'friends');
    });
  }

  QueryBuilder<NotificationPush, List<String>?, QQueryOperations>
      otherProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'other');
    });
  }

  QueryBuilder<NotificationPush, List<String>?, QQueryOperations>
      postsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posts');
    });
  }
}
