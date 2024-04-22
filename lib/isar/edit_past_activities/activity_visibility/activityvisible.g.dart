// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activityvisible.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetActivityVisibleCollection on Isar {
  IsarCollection<ActivityVisible> get activityVisibles => this.collection();
}

const ActivityVisibleSchema = CollectionSchema(
  name: r'activityvisible',
  id: -9008650305478028617,
  properties: {
    r'Activityselectedvalue': PropertySchema(
      id: 0,
      name: r'Activityselectedvalue',
      type: IsarType.string,
    )
  },
  estimateSize: _activityVisibleEstimateSize,
  serialize: _activityVisibleSerialize,
  deserialize: _activityVisibleDeserialize,
  deserializeProp: _activityVisibleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _activityVisibleGetId,
  getLinks: _activityVisibleGetLinks,
  attach: _activityVisibleAttach,
  version: '3.1.0+1',
);

int _activityVisibleEstimateSize(
  ActivityVisible object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.Activityselectedvalue.length * 3;
  return bytesCount;
}

void _activityVisibleSerialize(
  ActivityVisible object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.Activityselectedvalue);
}

ActivityVisible _activityVisibleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ActivityVisible(
    Activityselectedvalue: reader.readString(offsets[0]),
    id: id,
  );
  return object;
}

P _activityVisibleDeserializeProp<P>(
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

Id _activityVisibleGetId(ActivityVisible object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _activityVisibleGetLinks(ActivityVisible object) {
  return [];
}

void _activityVisibleAttach(
    IsarCollection<dynamic> col, Id id, ActivityVisible object) {
  object.id = id;
}

extension ActivityVisibleQueryWhereSort
    on QueryBuilder<ActivityVisible, ActivityVisible, QWhere> {
  QueryBuilder<ActivityVisible, ActivityVisible, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ActivityVisibleQueryWhere
    on QueryBuilder<ActivityVisible, ActivityVisible, QWhereClause> {
  QueryBuilder<ActivityVisible, ActivityVisible, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterWhereClause>
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

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterWhereClause> idBetween(
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

extension ActivityVisibleQueryFilter
    on QueryBuilder<ActivityVisible, ActivityVisible, QFilterCondition> {
  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Activityselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'Activityselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'Activityselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'Activityselectedvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'Activityselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'Activityselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'Activityselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'Activityselectedvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'Activityselectedvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      activityselectedvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'Activityselectedvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
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

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
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

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterFilterCondition>
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
}

extension ActivityVisibleQueryObject
    on QueryBuilder<ActivityVisible, ActivityVisible, QFilterCondition> {}

extension ActivityVisibleQueryLinks
    on QueryBuilder<ActivityVisible, ActivityVisible, QFilterCondition> {}

extension ActivityVisibleQuerySortBy
    on QueryBuilder<ActivityVisible, ActivityVisible, QSortBy> {
  QueryBuilder<ActivityVisible, ActivityVisible, QAfterSortBy>
      sortByActivityselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Activityselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterSortBy>
      sortByActivityselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Activityselectedvalue', Sort.desc);
    });
  }
}

extension ActivityVisibleQuerySortThenBy
    on QueryBuilder<ActivityVisible, ActivityVisible, QSortThenBy> {
  QueryBuilder<ActivityVisible, ActivityVisible, QAfterSortBy>
      thenByActivityselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Activityselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterSortBy>
      thenByActivityselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'Activityselectedvalue', Sort.desc);
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ActivityVisible, ActivityVisible, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension ActivityVisibleQueryWhereDistinct
    on QueryBuilder<ActivityVisible, ActivityVisible, QDistinct> {
  QueryBuilder<ActivityVisible, ActivityVisible, QDistinct>
      distinctByActivityselectedvalue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'Activityselectedvalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension ActivityVisibleQueryProperty
    on QueryBuilder<ActivityVisible, ActivityVisible, QQueryProperty> {
  QueryBuilder<ActivityVisible, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ActivityVisible, String, QQueryOperations>
      ActivityselectedvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'Activityselectedvalue');
    });
  }
}
