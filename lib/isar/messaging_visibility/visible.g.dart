// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'visible.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetVisibleCollection on Isar {
  IsarCollection<Visible> get visibles => this.collection();
}

const VisibleSchema = CollectionSchema(
  name: r'visible',
  id: -4949542428643659390,
  properties: {
    r'visibilityselectvalue': PropertySchema(
      id: 0,
      name: r'visibilityselectvalue',
      type: IsarType.bool,
    )
  },
  estimateSize: _visibleEstimateSize,
  serialize: _visibleSerialize,
  deserialize: _visibleDeserialize,
  deserializeProp: _visibleDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _visibleGetId,
  getLinks: _visibleGetLinks,
  attach: _visibleAttach,
  version: '3.1.0+1',
);

int _visibleEstimateSize(
  Visible object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _visibleSerialize(
  Visible object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.visibilityselectvalue);
}

Visible _visibleDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Visible(
    id: id,
    visibilityselectvalue: reader.readBool(offsets[0]),
  );
  return object;
}

P _visibleDeserializeProp<P>(
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

Id _visibleGetId(Visible object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _visibleGetLinks(Visible object) {
  return [];
}

void _visibleAttach(IsarCollection<dynamic> col, Id id, Visible object) {
  object.id = id;
}

extension VisibleQueryWhereSort on QueryBuilder<Visible, Visible, QWhere> {
  QueryBuilder<Visible, Visible, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension VisibleQueryWhere on QueryBuilder<Visible, Visible, QWhereClause> {
  QueryBuilder<Visible, Visible, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Visible, Visible, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Visible, Visible, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Visible, Visible, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Visible, Visible, QAfterWhereClause> idBetween(
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

extension VisibleQueryFilter
    on QueryBuilder<Visible, Visible, QFilterCondition> {
  QueryBuilder<Visible, Visible, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Visible, Visible, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Visible, Visible, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Visible, Visible, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Visible, Visible, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Visible, Visible, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Visible, Visible, QAfterFilterCondition>
      visibilityselectvalueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'visibilityselectvalue',
        value: value,
      ));
    });
  }
}

extension VisibleQueryObject
    on QueryBuilder<Visible, Visible, QFilterCondition> {}

extension VisibleQueryLinks
    on QueryBuilder<Visible, Visible, QFilterCondition> {}

extension VisibleQuerySortBy on QueryBuilder<Visible, Visible, QSortBy> {
  QueryBuilder<Visible, Visible, QAfterSortBy> sortByVisibilityselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visibilityselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Visible, Visible, QAfterSortBy>
      sortByVisibilityselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visibilityselectvalue', Sort.desc);
    });
  }
}

extension VisibleQuerySortThenBy
    on QueryBuilder<Visible, Visible, QSortThenBy> {
  QueryBuilder<Visible, Visible, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Visible, Visible, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Visible, Visible, QAfterSortBy> thenByVisibilityselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visibilityselectvalue', Sort.asc);
    });
  }

  QueryBuilder<Visible, Visible, QAfterSortBy>
      thenByVisibilityselectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'visibilityselectvalue', Sort.desc);
    });
  }
}

extension VisibleQueryWhereDistinct
    on QueryBuilder<Visible, Visible, QDistinct> {
  QueryBuilder<Visible, Visible, QDistinct> distinctByVisibilityselectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'visibilityselectvalue');
    });
  }
}

extension VisibleQueryProperty
    on QueryBuilder<Visible, Visible, QQueryProperty> {
  QueryBuilder<Visible, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Visible, bool, QQueryOperations>
      visibilityselectvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'visibilityselectvalue');
    });
  }
}
