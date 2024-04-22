// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dataPermissionOptions.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDataPermissionOptionsCollection on Isar {
  IsarCollection<DataPermissionOptions> get dataPermissionOptions =>
      this.collection();
}

const DataPermissionOptionsSchema = CollectionSchema(
  name: r'dataPermission',
  id: 2789718542041158799,
  properties: {
    r'dataselectedvalue': PropertySchema(
      id: 0,
      name: r'dataselectedvalue',
      type: IsarType.string,
    )
  },
  estimateSize: _dataPermissionOptionsEstimateSize,
  serialize: _dataPermissionOptionsSerialize,
  deserialize: _dataPermissionOptionsDeserialize,
  deserializeProp: _dataPermissionOptionsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _dataPermissionOptionsGetId,
  getLinks: _dataPermissionOptionsGetLinks,
  attach: _dataPermissionOptionsAttach,
  version: '3.1.0+1',
);

int _dataPermissionOptionsEstimateSize(
  DataPermissionOptions object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.dataselectedvalue;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _dataPermissionOptionsSerialize(
  DataPermissionOptions object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.dataselectedvalue);
}

DataPermissionOptions _dataPermissionOptionsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DataPermissionOptions(
    dataselectedvalue: reader.readStringOrNull(offsets[0]),
    id: id,
  );
  return object;
}

P _dataPermissionOptionsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dataPermissionOptionsGetId(DataPermissionOptions object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dataPermissionOptionsGetLinks(
    DataPermissionOptions object) {
  return [];
}

void _dataPermissionOptionsAttach(
    IsarCollection<dynamic> col, Id id, DataPermissionOptions object) {
  object.id = id;
}

extension DataPermissionOptionsQueryWhereSort
    on QueryBuilder<DataPermissionOptions, DataPermissionOptions, QWhere> {
  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DataPermissionOptionsQueryWhere on QueryBuilder<DataPermissionOptions,
    DataPermissionOptions, QWhereClause> {
  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterWhereClause>
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterWhereClause>
      idBetween(
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

extension DataPermissionOptionsQueryFilter on QueryBuilder<
    DataPermissionOptions, DataPermissionOptions, QFilterCondition> {
  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'dataselectedvalue',
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'dataselectedvalue',
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueEqualTo(
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueGreaterThan(
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueLessThan(
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueBetween(
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueStartsWith(
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueEndsWith(
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
          QAfterFilterCondition>
      dataselectedvalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'dataselectedvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
          QAfterFilterCondition>
      dataselectedvalueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'dataselectedvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dataselectedvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> dataselectedvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'dataselectedvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DataPermissionOptions, DataPermissionOptions,
      QAfterFilterCondition> idBetween(
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

extension DataPermissionOptionsQueryObject on QueryBuilder<
    DataPermissionOptions, DataPermissionOptions, QFilterCondition> {}

extension DataPermissionOptionsQueryLinks on QueryBuilder<DataPermissionOptions,
    DataPermissionOptions, QFilterCondition> {}

extension DataPermissionOptionsQuerySortBy
    on QueryBuilder<DataPermissionOptions, DataPermissionOptions, QSortBy> {
  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterSortBy>
      sortByDataselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterSortBy>
      sortByDataselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataselectedvalue', Sort.desc);
    });
  }
}

extension DataPermissionOptionsQuerySortThenBy
    on QueryBuilder<DataPermissionOptions, DataPermissionOptions, QSortThenBy> {
  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterSortBy>
      thenByDataselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterSortBy>
      thenByDataselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dataselectedvalue', Sort.desc);
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DataPermissionOptionsQueryWhereDistinct
    on QueryBuilder<DataPermissionOptions, DataPermissionOptions, QDistinct> {
  QueryBuilder<DataPermissionOptions, DataPermissionOptions, QDistinct>
      distinctByDataselectedvalue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dataselectedvalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension DataPermissionOptionsQueryProperty on QueryBuilder<
    DataPermissionOptions, DataPermissionOptions, QQueryProperty> {
  QueryBuilder<DataPermissionOptions, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DataPermissionOptions, String?, QQueryOperations>
      dataselectedvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dataselectedvalue');
    });
  }
}
