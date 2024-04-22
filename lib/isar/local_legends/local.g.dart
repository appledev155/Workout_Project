// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLocalCollection on Isar {
  IsarCollection<Local> get locals => this.collection();
}

const LocalSchema = CollectionSchema(
  name: r'local',
  id: -673032717491516623,
  properties: {
    r'localselectvalue': PropertySchema(
      id: 0,
      name: r'localselectvalue',
      type: IsarType.string,
    )
  },
  estimateSize: _localEstimateSize,
  serialize: _localSerialize,
  deserialize: _localDeserialize,
  deserializeProp: _localDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _localGetId,
  getLinks: _localGetLinks,
  attach: _localAttach,
  version: '3.1.0+1',
);

int _localEstimateSize(
  Local object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.localselectvalue.length * 3;
  return bytesCount;
}

void _localSerialize(
  Local object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.localselectvalue);
}

Local _localDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Local(
    id: id,
    localselectvalue: reader.readString(offsets[0]),
  );
  return object;
}

P _localDeserializeProp<P>(
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

Id _localGetId(Local object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _localGetLinks(Local object) {
  return [];
}

void _localAttach(IsarCollection<dynamic> col, Id id, Local object) {
  object.id = id;
}

extension LocalQueryWhereSort on QueryBuilder<Local, Local, QWhere> {
  QueryBuilder<Local, Local, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LocalQueryWhere on QueryBuilder<Local, Local, QWhereClause> {
  QueryBuilder<Local, Local, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Local, Local, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Local, Local, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Local, Local, QAfterWhereClause> idBetween(
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

extension LocalQueryFilter on QueryBuilder<Local, Local, QFilterCondition> {
  QueryBuilder<Local, Local, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Local, Local, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Local, Local, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'localselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'localselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'localselectvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'localselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'localselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'localselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'localselectvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition> localselectvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'localselectvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Local, Local, QAfterFilterCondition>
      localselectvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'localselectvalue',
        value: '',
      ));
    });
  }
}

extension LocalQueryObject on QueryBuilder<Local, Local, QFilterCondition> {}

extension LocalQueryLinks on QueryBuilder<Local, Local, QFilterCondition> {}

extension LocalQuerySortBy on QueryBuilder<Local, Local, QSortBy> {
  QueryBuilder<Local, Local, QAfterSortBy> sortByLocalselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Local, Local, QAfterSortBy> sortByLocalselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localselectvalue', Sort.desc);
    });
  }
}

extension LocalQuerySortThenBy on QueryBuilder<Local, Local, QSortThenBy> {
  QueryBuilder<Local, Local, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Local, Local, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Local, Local, QAfterSortBy> thenByLocalselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Local, Local, QAfterSortBy> thenByLocalselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'localselectvalue', Sort.desc);
    });
  }
}

extension LocalQueryWhereDistinct on QueryBuilder<Local, Local, QDistinct> {
  QueryBuilder<Local, Local, QDistinct> distinctByLocalselectvalue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'localselectvalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension LocalQueryProperty on QueryBuilder<Local, Local, QQueryProperty> {
  QueryBuilder<Local, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Local, String, QQueryOperations> localselectvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'localselectvalue');
    });
  }
}
