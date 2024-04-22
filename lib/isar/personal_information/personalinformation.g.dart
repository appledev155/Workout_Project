// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personalinformation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPersonalInformationCollection on Isar {
  IsarCollection<PersonalInformation> get personalInformations =>
      this.collection();
}

const PersonalInformationSchema = CollectionSchema(
  name: r'personalinformation',
  id: 639584303842075769,
  properties: {
    r'selectedvalue': PropertySchema(
      id: 0,
      name: r'selectedvalue',
      type: IsarType.bool,
    )
  },
  estimateSize: _personalInformationEstimateSize,
  serialize: _personalInformationSerialize,
  deserialize: _personalInformationDeserialize,
  deserializeProp: _personalInformationDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _personalInformationGetId,
  getLinks: _personalInformationGetLinks,
  attach: _personalInformationAttach,
  version: '3.1.0+1',
);

int _personalInformationEstimateSize(
  PersonalInformation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _personalInformationSerialize(
  PersonalInformation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.selectedvalue);
}

PersonalInformation _personalInformationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PersonalInformation(
    id: id,
    selectedvalue: reader.readBool(offsets[0]),
  );
  return object;
}

P _personalInformationDeserializeProp<P>(
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

Id _personalInformationGetId(PersonalInformation object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _personalInformationGetLinks(
    PersonalInformation object) {
  return [];
}

void _personalInformationAttach(
    IsarCollection<dynamic> col, Id id, PersonalInformation object) {
  object.id = id;
}

extension PersonalInformationQueryWhereSort
    on QueryBuilder<PersonalInformation, PersonalInformation, QWhere> {
  QueryBuilder<PersonalInformation, PersonalInformation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PersonalInformationQueryWhere
    on QueryBuilder<PersonalInformation, PersonalInformation, QWhereClause> {
  QueryBuilder<PersonalInformation, PersonalInformation, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterWhereClause>
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

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterWhereClause>
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

extension PersonalInformationQueryFilter on QueryBuilder<PersonalInformation,
    PersonalInformation, QFilterCondition> {
  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
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

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
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

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
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

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterFilterCondition>
      selectedvalueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectedvalue',
        value: value,
      ));
    });
  }
}

extension PersonalInformationQueryObject on QueryBuilder<PersonalInformation,
    PersonalInformation, QFilterCondition> {}

extension PersonalInformationQueryLinks on QueryBuilder<PersonalInformation,
    PersonalInformation, QFilterCondition> {}

extension PersonalInformationQuerySortBy
    on QueryBuilder<PersonalInformation, PersonalInformation, QSortBy> {
  QueryBuilder<PersonalInformation, PersonalInformation, QAfterSortBy>
      sortBySelectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedvalue', Sort.asc);
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterSortBy>
      sortBySelectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedvalue', Sort.desc);
    });
  }
}

extension PersonalInformationQuerySortThenBy
    on QueryBuilder<PersonalInformation, PersonalInformation, QSortThenBy> {
  QueryBuilder<PersonalInformation, PersonalInformation, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterSortBy>
      thenBySelectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedvalue', Sort.asc);
    });
  }

  QueryBuilder<PersonalInformation, PersonalInformation, QAfterSortBy>
      thenBySelectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectedvalue', Sort.desc);
    });
  }
}

extension PersonalInformationQueryWhereDistinct
    on QueryBuilder<PersonalInformation, PersonalInformation, QDistinct> {
  QueryBuilder<PersonalInformation, PersonalInformation, QDistinct>
      distinctBySelectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectedvalue');
    });
  }
}

extension PersonalInformationQueryProperty
    on QueryBuilder<PersonalInformation, PersonalInformation, QQueryProperty> {
  QueryBuilder<PersonalInformation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PersonalInformation, bool, QQueryOperations>
      selectedvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectedvalue');
    });
  }
}
