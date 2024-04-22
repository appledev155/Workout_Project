// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mention.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMentionCollection on Isar {
  IsarCollection<Mention> get mentions => this.collection();
}

const MentionSchema = CollectionSchema(
  name: r'mention',
  id: 6478318506420961400,
  properties: {
    r'mentionselectvalue': PropertySchema(
      id: 0,
      name: r'mentionselectvalue',
      type: IsarType.string,
    )
  },
  estimateSize: _mentionEstimateSize,
  serialize: _mentionSerialize,
  deserialize: _mentionDeserialize,
  deserializeProp: _mentionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _mentionGetId,
  getLinks: _mentionGetLinks,
  attach: _mentionAttach,
  version: '3.1.0+1',
);

int _mentionEstimateSize(
  Mention object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mentionselectvalue.length * 3;
  return bytesCount;
}

void _mentionSerialize(
  Mention object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.mentionselectvalue);
}

Mention _mentionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Mention(
    id: id,
    mentionselectvalue: reader.readString(offsets[0]),
  );
  return object;
}

P _mentionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _mentionGetId(Mention object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _mentionGetLinks(Mention object) {
  return [];
}

void _mentionAttach(IsarCollection<dynamic> col, Id id, Mention object) {
  object.id = id;
}

extension MentionQueryWhereSort on QueryBuilder<Mention, Mention, QWhere> {
  QueryBuilder<Mention, Mention, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension MentionQueryWhere on QueryBuilder<Mention, Mention, QWhereClause> {
  QueryBuilder<Mention, Mention, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Mention, Mention, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Mention, Mention, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Mention, Mention, QAfterWhereClause> idBetween(
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

extension MentionQueryFilter
    on QueryBuilder<Mention, Mention, QFilterCondition> {
  QueryBuilder<Mention, Mention, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Mention, Mention, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Mention, Mention, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mentionselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mentionselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mentionselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mentionselectvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mentionselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mentionselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mentionselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mentionselectvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mentionselectvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Mention, Mention, QAfterFilterCondition>
      mentionselectvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mentionselectvalue',
        value: '',
      ));
    });
  }
}

extension MentionQueryObject
    on QueryBuilder<Mention, Mention, QFilterCondition> {}

extension MentionQueryLinks
    on QueryBuilder<Mention, Mention, QFilterCondition> {}

extension MentionQuerySortBy on QueryBuilder<Mention, Mention, QSortBy> {
  QueryBuilder<Mention, Mention, QAfterSortBy> sortByMentionselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mentionselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Mention, Mention, QAfterSortBy> sortByMentionselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mentionselectvalue', Sort.desc);
    });
  }
}

extension MentionQuerySortThenBy
    on QueryBuilder<Mention, Mention, QSortThenBy> {
  QueryBuilder<Mention, Mention, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Mention, Mention, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Mention, Mention, QAfterSortBy> thenByMentionselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mentionselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Mention, Mention, QAfterSortBy> thenByMentionselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mentionselectvalue', Sort.desc);
    });
  }
}

extension MentionQueryWhereDistinct
    on QueryBuilder<Mention, Mention, QDistinct> {
  QueryBuilder<Mention, Mention, QDistinct> distinctByMentionselectvalue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mentionselectvalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension MentionQueryProperty
    on QueryBuilder<Mention, Mention, QQueryProperty> {
  QueryBuilder<Mention, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Mention, String, QQueryOperations> mentionselectvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mentionselectvalue');
    });
  }
}
