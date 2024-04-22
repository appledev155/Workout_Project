// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAccessCollection on Isar {
  IsarCollection<Access> get access => this.collection();
}

const AccessSchema = CollectionSchema(
  name: r'access',
  id: 8228228207383621742,
  properties: {
    r'accessvalue': PropertySchema(
      id: 0,
      name: r'accessvalue',
      type: IsarType.bool,
    )
  },
  estimateSize: _accessEstimateSize,
  serialize: _accessSerialize,
  deserialize: _accessDeserialize,
  deserializeProp: _accessDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _accessGetId,
  getLinks: _accessGetLinks,
  attach: _accessAttach,
  version: '3.1.0+1',
);

int _accessEstimateSize(
  Access object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _accessSerialize(
  Access object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.accessvalue);
}

Access _accessDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Access(
    accessvalue: reader.readBool(offsets[0]),
    id: id,
  );
  return object;
}

P _accessDeserializeProp<P>(
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

Id _accessGetId(Access object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _accessGetLinks(Access object) {
  return [];
}

void _accessAttach(IsarCollection<dynamic> col, Id id, Access object) {
  object.id = id;
}

extension AccessQueryWhereSort on QueryBuilder<Access, Access, QWhere> {
  QueryBuilder<Access, Access, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AccessQueryWhere on QueryBuilder<Access, Access, QWhereClause> {
  QueryBuilder<Access, Access, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Access, Access, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Access, Access, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Access, Access, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Access, Access, QAfterWhereClause> idBetween(
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

extension AccessQueryFilter on QueryBuilder<Access, Access, QFilterCondition> {
  QueryBuilder<Access, Access, QAfterFilterCondition> accessvalueEqualTo(
      bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accessvalue',
        value: value,
      ));
    });
  }

  QueryBuilder<Access, Access, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Access, Access, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Access, Access, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Access, Access, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Access, Access, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Access, Access, QAfterFilterCondition> idBetween(
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

extension AccessQueryObject on QueryBuilder<Access, Access, QFilterCondition> {}

extension AccessQueryLinks on QueryBuilder<Access, Access, QFilterCondition> {}

extension AccessQuerySortBy on QueryBuilder<Access, Access, QSortBy> {
  QueryBuilder<Access, Access, QAfterSortBy> sortByAccessvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessvalue', Sort.asc);
    });
  }

  QueryBuilder<Access, Access, QAfterSortBy> sortByAccessvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessvalue', Sort.desc);
    });
  }
}

extension AccessQuerySortThenBy on QueryBuilder<Access, Access, QSortThenBy> {
  QueryBuilder<Access, Access, QAfterSortBy> thenByAccessvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessvalue', Sort.asc);
    });
  }

  QueryBuilder<Access, Access, QAfterSortBy> thenByAccessvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accessvalue', Sort.desc);
    });
  }

  QueryBuilder<Access, Access, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Access, Access, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AccessQueryWhereDistinct on QueryBuilder<Access, Access, QDistinct> {
  QueryBuilder<Access, Access, QDistinct> distinctByAccessvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accessvalue');
    });
  }
}

extension AccessQueryProperty on QueryBuilder<Access, Access, QQueryProperty> {
  QueryBuilder<Access, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Access, bool, QQueryOperations> accessvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accessvalue');
    });
  }
}
