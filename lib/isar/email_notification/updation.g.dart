// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'updation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUpdationCollection on Isar {
  IsarCollection<Updation> get updations => this.collection();
}

const UpdationSchema = CollectionSchema(
  name: r'updation',
  id: -2979780256697025711,
  properties: {
    r'updationselectedvalue': PropertySchema(
      id: 0,
      name: r'updationselectedvalue',
      type: IsarType.string,
    )
  },
  estimateSize: _updationEstimateSize,
  serialize: _updationSerialize,
  deserialize: _updationDeserialize,
  deserializeProp: _updationDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _updationGetId,
  getLinks: _updationGetLinks,
  attach: _updationAttach,
  version: '3.1.0+1',
);

int _updationEstimateSize(
  Updation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.updationselectedvalue.length * 3;
  return bytesCount;
}

void _updationSerialize(
  Updation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.updationselectedvalue);
}

Updation _updationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Updation(
    id: id,
    updationselectedvalue: reader.readString(offsets[0]),
  );
  return object;
}

P _updationDeserializeProp<P>(
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

Id _updationGetId(Updation object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _updationGetLinks(Updation object) {
  return [];
}

void _updationAttach(IsarCollection<dynamic> col, Id id, Updation object) {
  object.id = id;
}

extension UpdationQueryWhereSort on QueryBuilder<Updation, Updation, QWhere> {
  QueryBuilder<Updation, Updation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UpdationQueryWhere on QueryBuilder<Updation, Updation, QWhereClause> {
  QueryBuilder<Updation, Updation, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Updation, Updation, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Updation, Updation, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Updation, Updation, QAfterWhereClause> idBetween(
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

extension UpdationQueryFilter
    on QueryBuilder<Updation, Updation, QFilterCondition> {
  QueryBuilder<Updation, Updation, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Updation, Updation, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Updation, Updation, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updationselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updationselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updationselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updationselectedvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'updationselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'updationselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'updationselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'updationselectedvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updationselectedvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Updation, Updation, QAfterFilterCondition>
      updationselectedvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'updationselectedvalue',
        value: '',
      ));
    });
  }
}

extension UpdationQueryObject
    on QueryBuilder<Updation, Updation, QFilterCondition> {}

extension UpdationQueryLinks
    on QueryBuilder<Updation, Updation, QFilterCondition> {}

extension UpdationQuerySortBy on QueryBuilder<Updation, Updation, QSortBy> {
  QueryBuilder<Updation, Updation, QAfterSortBy> sortByUpdationselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updationselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<Updation, Updation, QAfterSortBy>
      sortByUpdationselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updationselectedvalue', Sort.desc);
    });
  }
}

extension UpdationQuerySortThenBy
    on QueryBuilder<Updation, Updation, QSortThenBy> {
  QueryBuilder<Updation, Updation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Updation, Updation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Updation, Updation, QAfterSortBy> thenByUpdationselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updationselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<Updation, Updation, QAfterSortBy>
      thenByUpdationselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updationselectedvalue', Sort.desc);
    });
  }
}

extension UpdationQueryWhereDistinct
    on QueryBuilder<Updation, Updation, QDistinct> {
  QueryBuilder<Updation, Updation, QDistinct> distinctByUpdationselectedvalue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updationselectedvalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension UpdationQueryProperty
    on QueryBuilder<Updation, Updation, QQueryProperty> {
  QueryBuilder<Updation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Updation, String, QQueryOperations>
      updationselectedvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updationselectedvalue');
    });
  }
}
