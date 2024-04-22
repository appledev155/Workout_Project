// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'groupactivity.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGroupActivityCollection on Isar {
  IsarCollection<GroupActivity> get groupActivitys => this.collection();
}

const GroupActivitySchema = CollectionSchema(
  name: r'groupactivity',
  id: 4377072539523534010,
  properties: {
    r'group_activity_selectevalue': PropertySchema(
      id: 0,
      name: r'group_activity_selectevalue',
      type: IsarType.string,
    )
  },
  estimateSize: _groupActivityEstimateSize,
  serialize: _groupActivitySerialize,
  deserialize: _groupActivityDeserialize,
  deserializeProp: _groupActivityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _groupActivityGetId,
  getLinks: _groupActivityGetLinks,
  attach: _groupActivityAttach,
  version: '3.1.0+1',
);

int _groupActivityEstimateSize(
  GroupActivity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.group_activity_selectevalue.length * 3;
  return bytesCount;
}

void _groupActivitySerialize(
  GroupActivity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.group_activity_selectevalue);
}

GroupActivity _groupActivityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GroupActivity(
    group_activity_selectevalue: reader.readString(offsets[0]),
    id: id,
  );
  return object;
}

P _groupActivityDeserializeProp<P>(
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

Id _groupActivityGetId(GroupActivity object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _groupActivityGetLinks(GroupActivity object) {
  return [];
}

void _groupActivityAttach(
    IsarCollection<dynamic> col, Id id, GroupActivity object) {
  object.id = id;
}

extension GroupActivityQueryWhereSort
    on QueryBuilder<GroupActivity, GroupActivity, QWhere> {
  QueryBuilder<GroupActivity, GroupActivity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension GroupActivityQueryWhere
    on QueryBuilder<GroupActivity, GroupActivity, QWhereClause> {
  QueryBuilder<GroupActivity, GroupActivity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<GroupActivity, GroupActivity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterWhereClause> idBetween(
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

extension GroupActivityQueryFilter
    on QueryBuilder<GroupActivity, GroupActivity, QFilterCondition> {
  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'group_activity_selectevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'group_activity_selectevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'group_activity_selectevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'group_activity_selectevalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'group_activity_selectevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'group_activity_selectevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'group_activity_selectevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'group_activity_selectevalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'group_activity_selectevalue',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      group_activity_selectevalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'group_activity_selectevalue',
        value: '',
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition>
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

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GroupActivity, GroupActivity, QAfterFilterCondition> idBetween(
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
}

extension GroupActivityQueryObject
    on QueryBuilder<GroupActivity, GroupActivity, QFilterCondition> {}

extension GroupActivityQueryLinks
    on QueryBuilder<GroupActivity, GroupActivity, QFilterCondition> {}

extension GroupActivityQuerySortBy
    on QueryBuilder<GroupActivity, GroupActivity, QSortBy> {
  QueryBuilder<GroupActivity, GroupActivity, QAfterSortBy>
      sortByGroup_activity_selectevalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'group_activity_selectevalue', Sort.asc);
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterSortBy>
      sortByGroup_activity_selectevalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'group_activity_selectevalue', Sort.desc);
    });
  }
}

extension GroupActivityQuerySortThenBy
    on QueryBuilder<GroupActivity, GroupActivity, QSortThenBy> {
  QueryBuilder<GroupActivity, GroupActivity, QAfterSortBy>
      thenByGroup_activity_selectevalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'group_activity_selectevalue', Sort.asc);
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterSortBy>
      thenByGroup_activity_selectevalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'group_activity_selectevalue', Sort.desc);
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GroupActivity, GroupActivity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension GroupActivityQueryWhereDistinct
    on QueryBuilder<GroupActivity, GroupActivity, QDistinct> {
  QueryBuilder<GroupActivity, GroupActivity, QDistinct>
      distinctByGroup_activity_selectevalue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'group_activity_selectevalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension GroupActivityQueryProperty
    on QueryBuilder<GroupActivity, GroupActivity, QQueryProperty> {
  QueryBuilder<GroupActivity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GroupActivity, String, QQueryOperations>
      group_activity_selectevalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'group_activity_selectevalue');
    });
  }
}
