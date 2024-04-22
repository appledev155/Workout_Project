// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'startendcoordinate.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStartEndCoordinateCollection on Isar {
  IsarCollection<StartEndCoordinate> get startEndCoordinates =>
      this.collection();
}

const StartEndCoordinateSchema = CollectionSchema(
  name: r'startendcoordinate',
  id: 4409455245710820829,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.string,
    ),
    r'distance': PropertySchema(
      id: 1,
      name: r'distance',
      type: IsarType.string,
    ),
    r'duration': PropertySchema(
      id: 2,
      name: r'duration',
      type: IsarType.string,
    ),
    r'endLatlng': PropertySchema(
      id: 3,
      name: r'endLatlng',
      type: IsarType.doubleList,
    ),
    r'startLatlng': PropertySchema(
      id: 4,
      name: r'startLatlng',
      type: IsarType.doubleList,
    )
  },
  estimateSize: _startEndCoordinateEstimateSize,
  serialize: _startEndCoordinateSerialize,
  deserialize: _startEndCoordinateDeserialize,
  deserializeProp: _startEndCoordinateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _startEndCoordinateGetId,
  getLinks: _startEndCoordinateGetLinks,
  attach: _startEndCoordinateAttach,
  version: '3.1.0+1',
);

int _startEndCoordinateEstimateSize(
  StartEndCoordinate object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.date;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.distance;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.duration;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.endLatlng;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  {
    final value = object.startLatlng;
    if (value != null) {
      bytesCount += 3 + value.length * 8;
    }
  }
  return bytesCount;
}

void _startEndCoordinateSerialize(
  StartEndCoordinate object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.date);
  writer.writeString(offsets[1], object.distance);
  writer.writeString(offsets[2], object.duration);
  writer.writeDoubleList(offsets[3], object.endLatlng);
  writer.writeDoubleList(offsets[4], object.startLatlng);
}

StartEndCoordinate _startEndCoordinateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StartEndCoordinate(
    date: reader.readStringOrNull(offsets[0]),
    distance: reader.readStringOrNull(offsets[1]),
    duration: reader.readStringOrNull(offsets[2]),
    endLatlng: reader.readDoubleList(offsets[3]),
    id: id,
    startLatlng: reader.readDoubleList(offsets[4]),
  );
  return object;
}

P _startEndCoordinateDeserializeProp<P>(
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
    case 3:
      return (reader.readDoubleList(offset)) as P;
    case 4:
      return (reader.readDoubleList(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _startEndCoordinateGetId(StartEndCoordinate object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _startEndCoordinateGetLinks(
    StartEndCoordinate object) {
  return [];
}

void _startEndCoordinateAttach(
    IsarCollection<dynamic> col, Id id, StartEndCoordinate object) {
  object.id = id;
}

extension StartEndCoordinateQueryWhereSort
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QWhere> {
  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StartEndCoordinateQueryWhere
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QWhereClause> {
  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterWhereClause>
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

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterWhereClause>
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

extension StartEndCoordinateQueryFilter
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QFilterCondition> {
  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'date',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'date',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      dateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'date',
        value: '',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'distance',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'distance',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'distance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'distance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'distance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'distance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'distance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'distance',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'distance',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'distance',
        value: '',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      distanceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'distance',
        value: '',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'duration',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'duration',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'duration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'duration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'duration',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'duration',
        value: '',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      durationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'duration',
        value: '',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'endLatlng',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'endLatlng',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'endLatlng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'endLatlng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'endLatlng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'endLatlng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'endLatlng',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'endLatlng',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'endLatlng',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'endLatlng',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'endLatlng',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      endLatlngLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'endLatlng',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
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

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
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

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
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

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'startLatlng',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'startLatlng',
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'startLatlng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'startLatlng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'startLatlng',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'startLatlng',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'startLatlng',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'startLatlng',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'startLatlng',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'startLatlng',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'startLatlng',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterFilterCondition>
      startLatlngLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'startLatlng',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension StartEndCoordinateQueryObject
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QFilterCondition> {}

extension StartEndCoordinateQueryLinks
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QFilterCondition> {}

extension StartEndCoordinateQuerySortBy
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QSortBy> {
  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      sortByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.asc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      sortByDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.desc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      sortByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      sortByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }
}

extension StartEndCoordinateQuerySortThenBy
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QSortThenBy> {
  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      thenByDistance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.asc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      thenByDistanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'distance', Sort.desc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      thenByDuration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.asc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      thenByDurationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'duration', Sort.desc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension StartEndCoordinateQueryWhereDistinct
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QDistinct> {
  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QDistinct>
      distinctByDate({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QDistinct>
      distinctByDistance({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'distance', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QDistinct>
      distinctByDuration({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'duration', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QDistinct>
      distinctByEndLatlng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'endLatlng');
    });
  }

  QueryBuilder<StartEndCoordinate, StartEndCoordinate, QDistinct>
      distinctByStartLatlng() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'startLatlng');
    });
  }
}

extension StartEndCoordinateQueryProperty
    on QueryBuilder<StartEndCoordinate, StartEndCoordinate, QQueryProperty> {
  QueryBuilder<StartEndCoordinate, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StartEndCoordinate, String?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<StartEndCoordinate, String?, QQueryOperations>
      distanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'distance');
    });
  }

  QueryBuilder<StartEndCoordinate, String?, QQueryOperations>
      durationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'duration');
    });
  }

  QueryBuilder<StartEndCoordinate, List<double>?, QQueryOperations>
      endLatlngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'endLatlng');
    });
  }

  QueryBuilder<StartEndCoordinate, List<double>?, QQueryOperations>
      startLatlngProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'startLatlng');
    });
  }
}
