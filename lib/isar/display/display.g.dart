// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'display.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDisplayCollection on Isar {
  IsarCollection<Display> get displays => this.collection();
}

const DisplaySchema = CollectionSchema(
  name: r'display',
  id: -2473524358419647650,
  properties: {
    r'selecteddefaultvalue': PropertySchema(
      id: 0,
      name: r'selecteddefaultvalue',
      type: IsarType.string,
    ),
    r'selectedmeasurevalue': PropertySchema(
      id: 1,
      name: r'selectedmeasurevalue',
      type: IsarType.string,
    ),
    r'selectedtempvalue': PropertySchema(
      id: 2,
      name: r'selectedtempvalue',
      type: IsarType.string,
    )
  },
  estimateSize: _displayEstimateSize,
  serialize: _displaySerialize,
  deserialize: _displayDeserialize,
  deserializeProp: _displayDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _displayGetId,
  getLinks: _displayGetLinks,
  attach: _displayAttach,
  version: '3.1.0+1',
);

int _displayEstimateSize(
  Display object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.selecteddefaultvalue;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.selectedmeasurevalue;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.selectedtempvalue;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _displaySerialize(
  Display object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.selecteddefaultvalue);
  writer.writeString(offsets[1], object.selectedmeasurevalue);
  writer.writeString(offsets[2], object.selectedtempvalue);
}

Display _displayDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Display(
    id: id,
    selecteddefaultvalue: reader.readStringOrNull(offsets[0]),
    selectedmeasurevalue: reader.readStringOrNull(offsets[1]),
    selectedtempvalue: reader.readStringOrNull(offsets[2]),
  );
  return object;
}

P _displayDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _displayGetId(Display object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _displayGetLinks(Display object) {
  return [];
}

void _displayAttach(IsarCollection<dynamic> col, Id id, Display object) {
  object.id = id;
}

extension DisplayQueryWhereSort on QueryBuilder<Display, Display, QWhere> {
  QueryBuilder<Display, Display, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DisplayQueryWhere on QueryBuilder<Display, Display, QWhereClause> {
  QueryBuilder<Display, Display, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Display, Display, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Display, Display, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Display, Display, QAfterWhereClause> idBetween(
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

extension DisplayQueryFilter
    on QueryBuilder<Display, Display, QFilterCondition> {
  QueryBuilder<Display, Display, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Display, Display, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Display, Display, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selecteddefaultvalue',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selecteddefaultvalue',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selecteddefaultvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selecteddefaultvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selecteddefaultvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selecteddefaultvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selecteddefaultvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selecteddefaultvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selecteddefaultvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selecteddefaultvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selecteddefaultvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selecteddefaultvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selecteddefaultvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selectedmeasurevalue',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selectedmeasurevalue',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedmeasurevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedmeasurevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedmeasurevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedmeasurevalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedmeasurevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedmeasurevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedmeasurevalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedmeasurevalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedmeasurevalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedmeasurevalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedmeasurevalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'selectedtempvalue',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'selectedtempvalue',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedtempvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'selectedtempvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'selectedtempvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'selectedtempvalue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'selectedtempvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'selectedtempvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'selectedtempvalue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'selectedtempvalue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedtempvalue',
        value: '',
      ));
    });
  }

  QueryBuilder<Display, Display, QAfterFilterCondition>
      selectedtempvalueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'selectedtempvalue',
        value: '',
      ));
    });
  }
}

extension DisplayQueryObject
    on QueryBuilder<Display, Display, QFilterCondition> {}

extension DisplayQueryLinks
    on QueryBuilder<Display, Display, QFilterCondition> {}

extension DisplayQuerySortBy on QueryBuilder<Display, Display, QSortBy> {
  QueryBuilder<Display, Display, QAfterSortBy> sortBySelecteddefaultvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selecteddefaultvalue', Sort.asc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy>
      sortBySelecteddefaultvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selecteddefaultvalue', Sort.desc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy> sortBySelectedmeasurevalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedmeasurevalue', Sort.asc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy>
      sortBySelectedmeasurevalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedmeasurevalue', Sort.desc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy> sortBySelectedtempvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedtempvalue', Sort.asc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy> sortBySelectedtempvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedtempvalue', Sort.desc);
    });
  }
}

extension DisplayQuerySortThenBy
    on QueryBuilder<Display, Display, QSortThenBy> {
  QueryBuilder<Display, Display, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy> thenBySelecteddefaultvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selecteddefaultvalue', Sort.asc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy>
      thenBySelecteddefaultvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selecteddefaultvalue', Sort.desc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy> thenBySelectedmeasurevalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedmeasurevalue', Sort.asc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy>
      thenBySelectedmeasurevalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedmeasurevalue', Sort.desc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy> thenBySelectedtempvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedtempvalue', Sort.asc);
    });
  }

  QueryBuilder<Display, Display, QAfterSortBy> thenBySelectedtempvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedtempvalue', Sort.desc);
    });
  }
}

extension DisplayQueryWhereDistinct
    on QueryBuilder<Display, Display, QDistinct> {
  QueryBuilder<Display, Display, QDistinct> distinctBySelecteddefaultvalue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selecteddefaultvalue',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Display, Display, QDistinct> distinctBySelectedmeasurevalue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedmeasurevalue',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Display, Display, QDistinct> distinctBySelectedtempvalue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedtempvalue',
          caseSensitive: caseSensitive);
    });
  }
}

extension DisplayQueryProperty
    on QueryBuilder<Display, Display, QQueryProperty> {
  QueryBuilder<Display, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Display, String?, QQueryOperations>
      selecteddefaultvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selecteddefaultvalue');
    });
  }

  QueryBuilder<Display, String?, QQueryOperations>
      selectedmeasurevalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedmeasurevalue');
    });
  }

  QueryBuilder<Display, String?, QQueryOperations> selectedtempvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedtempvalue');
    });
  }
}
