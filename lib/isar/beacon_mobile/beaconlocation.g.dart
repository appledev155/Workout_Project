// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'beaconlocation.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBeaconLocationCollection on Isar {
  IsarCollection<BeaconLocation> get beaconLocations => this.collection();
}

const BeaconLocationSchema = CollectionSchema(
  name: r'beaconlocation',
  id: -7750969921175079872,
  properties: {
    r'locationselectedvalue': PropertySchema(
      id: 0,
      name: r'locationselectedvalue',
      type: IsarType.bool,
    )
  },
  estimateSize: _beaconLocationEstimateSize,
  serialize: _beaconLocationSerialize,
  deserialize: _beaconLocationDeserialize,
  deserializeProp: _beaconLocationDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _beaconLocationGetId,
  getLinks: _beaconLocationGetLinks,
  attach: _beaconLocationAttach,
  version: '3.1.0+1',
);

int _beaconLocationEstimateSize(
  BeaconLocation object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _beaconLocationSerialize(
  BeaconLocation object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.locationselectedvalue);
}

BeaconLocation _beaconLocationDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BeaconLocation(
    id: id,
    locationselectedvalue: reader.readBool(offsets[0]),
  );
  return object;
}

P _beaconLocationDeserializeProp<P>(
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

Id _beaconLocationGetId(BeaconLocation object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _beaconLocationGetLinks(BeaconLocation object) {
  return [];
}

void _beaconLocationAttach(
    IsarCollection<dynamic> col, Id id, BeaconLocation object) {
  object.id = id;
}

extension BeaconLocationQueryWhereSort
    on QueryBuilder<BeaconLocation, BeaconLocation, QWhere> {
  QueryBuilder<BeaconLocation, BeaconLocation, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension BeaconLocationQueryWhere
    on QueryBuilder<BeaconLocation, BeaconLocation, QWhereClause> {
  QueryBuilder<BeaconLocation, BeaconLocation, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterWhereClause> idBetween(
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

extension BeaconLocationQueryFilter
    on QueryBuilder<BeaconLocation, BeaconLocation, QFilterCondition> {
  QueryBuilder<BeaconLocation, BeaconLocation, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterFilterCondition>
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

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterFilterCondition>
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

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterFilterCondition> idBetween(
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

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterFilterCondition>
      locationselectedvalueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'locationselectedvalue',
        value: value,
      ));
    });
  }
}

extension BeaconLocationQueryObject
    on QueryBuilder<BeaconLocation, BeaconLocation, QFilterCondition> {}

extension BeaconLocationQueryLinks
    on QueryBuilder<BeaconLocation, BeaconLocation, QFilterCondition> {}

extension BeaconLocationQuerySortBy
    on QueryBuilder<BeaconLocation, BeaconLocation, QSortBy> {
  QueryBuilder<BeaconLocation, BeaconLocation, QAfterSortBy>
      sortByLocationselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterSortBy>
      sortByLocationselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationselectedvalue', Sort.desc);
    });
  }
}

extension BeaconLocationQuerySortThenBy
    on QueryBuilder<BeaconLocation, BeaconLocation, QSortThenBy> {
  QueryBuilder<BeaconLocation, BeaconLocation, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterSortBy>
      thenByLocationselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationselectedvalue', Sort.asc);
    });
  }

  QueryBuilder<BeaconLocation, BeaconLocation, QAfterSortBy>
      thenByLocationselectedvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'locationselectedvalue', Sort.desc);
    });
  }
}

extension BeaconLocationQueryWhereDistinct
    on QueryBuilder<BeaconLocation, BeaconLocation, QDistinct> {
  QueryBuilder<BeaconLocation, BeaconLocation, QDistinct>
      distinctByLocationselectedvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'locationselectedvalue');
    });
  }
}

extension BeaconLocationQueryProperty
    on QueryBuilder<BeaconLocation, BeaconLocation, QQueryProperty> {
  QueryBuilder<BeaconLocation, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BeaconLocation, bool, QQueryOperations>
      locationselectedvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'locationselectedvalue');
    });
  }
}
