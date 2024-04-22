// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aggregate.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAggregateCollection on Isar {
  IsarCollection<Aggregate> get aggregates => this.collection();
}

const AggregateSchema = CollectionSchema(
  name: r'aggregate',
  id: -2363098519127247518,
  properties: {
    r'aggregateselectvalue': PropertySchema(
      id: 0,
      name: r'aggregateselectvalue',
      type: IsarType.bool,
    )
  },
  estimateSize: _aggregateEstimateSize,
  serialize: _aggregateSerialize,
  deserialize: _aggregateDeserialize,
  deserializeProp: _aggregateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _aggregateGetId,
  getLinks: _aggregateGetLinks,
  attach: _aggregateAttach,
  version: '3.1.0+1',
);

int _aggregateEstimateSize(
  Aggregate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _aggregateSerialize(
  Aggregate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.aggregateselectvalue);
}

Aggregate _aggregateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Aggregate(
    aggregateselectvalue: reader.readBool(offsets[0]),
    id: id,
  );
  return object;
}

P _aggregateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _aggregateGetId(Aggregate object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _aggregateGetLinks(Aggregate object) {
  return [];
}

void _aggregateAttach(IsarCollection<dynamic> col, Id id, Aggregate object) {
  object.id = id;
}

extension AggregateQueryWhereSort
    on QueryBuilder<Aggregate, Aggregate, QWhere> {
  QueryBuilder<Aggregate, Aggregate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AggregateQueryWhere
    on QueryBuilder<Aggregate, Aggregate, QWhereClause> {
  QueryBuilder<Aggregate, Aggregate, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Aggregate, Aggregate, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterWhereClause> idBetween(
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

extension AggregateQueryFilter
    on QueryBuilder<Aggregate, Aggregate, QFilterCondition> {
  QueryBuilder<Aggregate, Aggregate, QAfterFilterCondition>
      aggregateselectvalueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aggregateselectvalue',
        value: value,
      ));
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Aggregate, Aggregate, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Aggregate, Aggregate, QAfterFilterCondition> idBetween(
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

extension AggregateQueryObject
    on QueryBuilder<Aggregate, Aggregate, QFilterCondition> {}

extension AggregateQueryLinks
    on QueryBuilder<Aggregate, Aggregate, QFilterCondition> {}

extension AggregateQuerySortBy on QueryBuilder<Aggregate, Aggregate, QSortBy> {
  QueryBuilder<Aggregate, Aggregate, QAfterSortBy>
      sortByAggregateselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aggregateselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterSortBy>
      sortByAggregateselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aggregateselectvalue', Sort.desc);
    });
  }
}

extension AggregateQuerySortThenBy
    on QueryBuilder<Aggregate, Aggregate, QSortThenBy> {
  QueryBuilder<Aggregate, Aggregate, QAfterSortBy>
      thenByAggregateselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aggregateselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterSortBy>
      thenByAggregateselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aggregateselectvalue', Sort.desc);
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Aggregate, Aggregate, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AggregateQueryWhereDistinct
    on QueryBuilder<Aggregate, Aggregate, QDistinct> {
  QueryBuilder<Aggregate, Aggregate, QDistinct>
      distinctByAggregateselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aggregateselectvalue');
    });
  }
}

extension AggregateQueryProperty
    on QueryBuilder<Aggregate, Aggregate, QQueryProperty> {
  QueryBuilder<Aggregate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Aggregate, bool, QQueryOperations>
      aggregateselectvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aggregateselectvalue');
    });
  }
}
