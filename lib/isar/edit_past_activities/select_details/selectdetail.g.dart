// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selectdetail.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSelectDetailCollection on Isar {
  IsarCollection<SelectDetail> get selectDetails => this.collection();
}

const SelectDetailSchema = CollectionSchema(
  name: r'selectdetail',
  id: 8438279681339584921,
  properties: {
    r'selectdetailsvalue': PropertySchema(
      id: 0,
      name: r'selectdetailsvalue',
      type: IsarType.string,
    )
  },
  estimateSize: _selectDetailEstimateSize,
  serialize: _selectDetailSerialize,
  deserialize: _selectDetailDeserialize,
  deserializeProp: _selectDetailDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _selectDetailGetId,
  getLinks: _selectDetailGetLinks,
  attach: _selectDetailAttach,
  version: '3.1.0+1',
);

int _selectDetailEstimateSize(
  SelectDetail object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.selectdetailsvalue.length * 3;
  return bytesCount;
}

void _selectDetailSerialize(
  SelectDetail object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.selectdetailsvalue);
}

SelectDetail _selectDetailDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SelectDetail(
    id: id,
    selectdetailsvalue: reader.readString(offsets[0]),
  );
  return object;
}

P _selectDetailDeserializeProp<P>(
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

Id _selectDetailGetId(SelectDetail object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _selectDetailGetLinks(SelectDetail object) {
  return [];
}

void _selectDetailAttach(
    IsarCollection<dynamic> col, Id id, SelectDetail object) {
  object.id = id;
}

extension SelectDetailQueryWhereSort
    on QueryBuilder<SelectDetail, SelectDetail, QWhere> {
  QueryBuilder<SelectDetail, SelectDetail, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SelectDetailQueryWhere
    on QueryBuilder<SelectDetail, SelectDetail, QWhereClause> {
  QueryBuilder<SelectDetail, SelectDetail, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<SelectDetail, SelectDetail, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterWhereClause> idBetween(
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

extension SelectDetailQueryFilter
    on QueryBuilder<SelectDetail, SelectDetail, QFilterCondition> {
  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectdetailsvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectdetailsvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectdetailsvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectdetailsvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectdetailsvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectdetailsvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectdetailsvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectdetailsvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectdetailsvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterFilterCondition>
      selectdetailsvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectdetailsvalue',
        value: '',
      ));
    });
  }
}

extension SelectDetailQueryObject
    on QueryBuilder<SelectDetail, SelectDetail, QFilterCondition> {}

extension SelectDetailQueryLinks
    on QueryBuilder<SelectDetail, SelectDetail, QFilterCondition> {}

extension SelectDetailQuerySortBy
    on QueryBuilder<SelectDetail, SelectDetail, QSortBy> {
  QueryBuilder<SelectDetail, SelectDetail, QAfterSortBy>
      sortBySelectdetailsvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectdetailsvalue', Sort.asc);
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterSortBy>
      sortBySelectdetailsvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectdetailsvalue', Sort.desc);
    });
  }
}

extension SelectDetailQuerySortThenBy
    on QueryBuilder<SelectDetail, SelectDetail, QSortThenBy> {
  QueryBuilder<SelectDetail, SelectDetail, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterSortBy>
      thenBySelectdetailsvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectdetailsvalue', Sort.asc);
    });
  }

  QueryBuilder<SelectDetail, SelectDetail, QAfterSortBy>
      thenBySelectdetailsvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectdetailsvalue', Sort.desc);
    });
  }
}

extension SelectDetailQueryWhereDistinct
    on QueryBuilder<SelectDetail, SelectDetail, QDistinct> {
  QueryBuilder<SelectDetail, SelectDetail, QDistinct>
      distinctBySelectdetailsvalue({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectdetailsvalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension SelectDetailQueryProperty
    on QueryBuilder<SelectDetail, SelectDetail, QQueryProperty> {
  QueryBuilder<SelectDetail, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SelectDetail, String, QQueryOperations>
      selectdetailsvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectdetailsvalue');
    });
  }
}
