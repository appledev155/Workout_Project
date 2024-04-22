// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetAppConfigIsarCollection on Isar {
  IsarCollection<AppConfigIsar> get appConfigIsars => this.collection();
}

const AppConfigIsarSchema = CollectionSchema(
  name: r'AppConfig',
  id: -7085420701237142207,
  properties: {
    r'configName': PropertySchema(
      id: 0,
      name: r'configName',
      type: IsarType.string,
    ),
    r'configValue': PropertySchema(
      id: 1,
      name: r'configValue',
      type: IsarType.string,
    )
  },
  estimateSize: _appConfigIsarEstimateSize,
  serialize: _appConfigIsarSerialize,
  deserialize: _appConfigIsarDeserialize,
  deserializeProp: _appConfigIsarDeserializeProp,
  idName: r'id',
  indexes: {
    r'configName': IndexSchema(
      id: 5054090951368614486,
      name: r'configName',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'configName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _appConfigIsarGetId,
  getLinks: _appConfigIsarGetLinks,
  attach: _appConfigIsarAttach,
  version: '3.1.0+1',
);

int _appConfigIsarEstimateSize(
  AppConfigIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.configName.length * 3;
  bytesCount += 3 + object.configValue.length * 3;
  return bytesCount;
}

void _appConfigIsarSerialize(
  AppConfigIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.configName);
  writer.writeString(offsets[1], object.configValue);
}

AppConfigIsar _appConfigIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = AppConfigIsar();
  object.configName = reader.readString(offsets[0]);
  object.configValue = reader.readString(offsets[1]);
  object.id = id;
  return object;
}

P _appConfigIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _appConfigIsarGetId(AppConfigIsar object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _appConfigIsarGetLinks(AppConfigIsar object) {
  return [];
}

void _appConfigIsarAttach(
    IsarCollection<dynamic> col, Id id, AppConfigIsar object) {
  object.id = id;
}

extension AppConfigIsarByIndex on IsarCollection<AppConfigIsar> {
  Future<AppConfigIsar?> getByConfigName(String configName) {
    return getByIndex(r'configName', [configName]);
  }

  AppConfigIsar? getByConfigNameSync(String configName) {
    return getByIndexSync(r'configName', [configName]);
  }

  Future<bool> deleteByConfigName(String configName) {
    return deleteByIndex(r'configName', [configName]);
  }

  bool deleteByConfigNameSync(String configName) {
    return deleteByIndexSync(r'configName', [configName]);
  }

  Future<List<AppConfigIsar?>> getAllByConfigName(
      List<String> configNameValues) {
    final values = configNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'configName', values);
  }

  List<AppConfigIsar?> getAllByConfigNameSync(List<String> configNameValues) {
    final values = configNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'configName', values);
  }

  Future<int> deleteAllByConfigName(List<String> configNameValues) {
    final values = configNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'configName', values);
  }

  int deleteAllByConfigNameSync(List<String> configNameValues) {
    final values = configNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'configName', values);
  }

  Future<Id> putByConfigName(AppConfigIsar object) {
    return putByIndex(r'configName', object);
  }

  Id putByConfigNameSync(AppConfigIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'configName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByConfigName(List<AppConfigIsar> objects) {
    return putAllByIndex(r'configName', objects);
  }

  List<Id> putAllByConfigNameSync(List<AppConfigIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'configName', objects, saveLinks: saveLinks);
  }
}

extension AppConfigIsarQueryWhereSort
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QWhere> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension AppConfigIsarQueryWhere
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QWhereClause> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause>
      configNameEqualTo(String configName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'configName',
        value: [configName],
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterWhereClause>
      configNameNotEqualTo(String configName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configName',
              lower: [],
              upper: [configName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configName',
              lower: [configName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configName',
              lower: [configName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'configName',
              lower: [],
              upper: [configName],
              includeUpper: false,
            ));
      }
    });
  }
}

extension AppConfigIsarQueryFilter
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QFilterCondition> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'configName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'configName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'configName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'configName',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'configValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'configValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'configValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'configValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'configValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'configValue',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'configValue',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'configValue',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      configValueIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'configValue',
        value: '',
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition>
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

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterFilterCondition> idBetween(
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

extension AppConfigIsarQueryObject
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QFilterCondition> {}

extension AppConfigIsarQueryLinks
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QFilterCondition> {}

extension AppConfigIsarQuerySortBy
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QSortBy> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy> sortByConfigName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configName', Sort.asc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy>
      sortByConfigNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configName', Sort.desc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy> sortByConfigValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configValue', Sort.asc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy>
      sortByConfigValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configValue', Sort.desc);
    });
  }
}

extension AppConfigIsarQuerySortThenBy
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QSortThenBy> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy> thenByConfigName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configName', Sort.asc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy>
      thenByConfigNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configName', Sort.desc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy> thenByConfigValue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configValue', Sort.asc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy>
      thenByConfigValueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'configValue', Sort.desc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension AppConfigIsarQueryWhereDistinct
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QDistinct> {
  QueryBuilder<AppConfigIsar, AppConfigIsar, QDistinct> distinctByConfigName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'configName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<AppConfigIsar, AppConfigIsar, QDistinct> distinctByConfigValue(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'configValue', caseSensitive: caseSensitive);
    });
  }
}

extension AppConfigIsarQueryProperty
    on QueryBuilder<AppConfigIsar, AppConfigIsar, QQueryProperty> {
  QueryBuilder<AppConfigIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<AppConfigIsar, String, QQueryOperations> configNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'configName');
    });
  }

  QueryBuilder<AppConfigIsar, String, QQueryOperations> configValueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'configValue');
    });
  }
}
