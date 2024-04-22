// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flybys.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetFlybysCollection on Isar {
  IsarCollection<Flybys> get flybys => this.collection();
}

const FlybysSchema = CollectionSchema(
  name: r'flybys',
  id: -8235784753191874519,
  properties: {
    r'flybysselectvalue': PropertySchema(
      id: 0,
      name: r'flybysselectvalue',
      type: IsarType.string,
    )
  },
  estimateSize: _flybysEstimateSize,
  serialize: _flybysSerialize,
  deserialize: _flybysDeserialize,
  deserializeProp: _flybysDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _flybysGetId,
  getLinks: _flybysGetLinks,
  attach: _flybysAttach,
  version: '3.1.0+1',
);

int _flybysEstimateSize(
  Flybys object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.flybysselectvalue.length * 3;
  return bytesCount;
}

void _flybysSerialize(
  Flybys object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.flybysselectvalue);
}

Flybys _flybysDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Flybys(
    flybysselectvalue: reader.readString(offsets[0]),
    id: id,
  );
  return object;
}

P _flybysDeserializeProp<P>(
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

Id _flybysGetId(Flybys object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _flybysGetLinks(Flybys object) {
  return [];
}

void _flybysAttach(IsarCollection<dynamic> col, Id id, Flybys object) {
  object.id = id;
}

extension FlybysQueryWhereSort on QueryBuilder<Flybys, Flybys, QWhere> {
  QueryBuilder<Flybys, Flybys, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension FlybysQueryWhere on QueryBuilder<Flybys, Flybys, QWhereClause> {
  QueryBuilder<Flybys, Flybys, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Flybys, Flybys, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterWhereClause> idBetween(
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

extension FlybysQueryFilter on QueryBuilder<Flybys, Flybys, QFilterCondition> {
  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> flybysselectvalueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flybysselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition>
      flybysselectvalueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'flybysselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> flybysselectvalueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'flybysselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> flybysselectvalueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'flybysselectvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition>
      flybysselectvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'flybysselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> flybysselectvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'flybysselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> flybysselectvalueContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'flybysselectvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> flybysselectvalueMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'flybysselectvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition>
      flybysselectvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'flybysselectvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition>
      flybysselectvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'flybysselectvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Flybys, Flybys, QAfterFilterCondition> idBetween(
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

extension FlybysQueryObject on QueryBuilder<Flybys, Flybys, QFilterCondition> {}

extension FlybysQueryLinks on QueryBuilder<Flybys, Flybys, QFilterCondition> {}

extension FlybysQuerySortBy on QueryBuilder<Flybys, Flybys, QSortBy> {
  QueryBuilder<Flybys, Flybys, QAfterSortBy> sortByFlybysselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flybysselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterSortBy> sortByFlybysselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flybysselectvalue', Sort.desc);
    });
  }
}

extension FlybysQuerySortThenBy on QueryBuilder<Flybys, Flybys, QSortThenBy> {
  QueryBuilder<Flybys, Flybys, QAfterSortBy> thenByFlybysselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flybysselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterSortBy> thenByFlybysselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'flybysselectvalue', Sort.desc);
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Flybys, Flybys, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension FlybysQueryWhereDistinct on QueryBuilder<Flybys, Flybys, QDistinct> {
  QueryBuilder<Flybys, Flybys, QDistinct> distinctByFlybysselectvalue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'flybysselectvalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension FlybysQueryProperty on QueryBuilder<Flybys, Flybys, QQueryProperty> {
  QueryBuilder<Flybys, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Flybys, String, QQueryOperations> flybysselectvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'flybysselectvalue');
    });
  }
}
