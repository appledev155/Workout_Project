// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetUserIsarCollection on Isar {
  IsarCollection<UserIsar> get userIsars => this.collection();
}

const UserIsarSchema = CollectionSchema(
  name: r'User',
  id: -7838171048429979076,
  properties: {
    r'publicUpdatedTimeToken': PropertySchema(
      id: 0,
      name: r'publicUpdatedTimeToken',
      type: IsarType.long,
    ),
    r'roleTypeId': PropertySchema(
      id: 1,
      name: r'roleTypeId',
      type: IsarType.string,
    ),
    r'userImage': PropertySchema(
      id: 2,
      name: r'userImage',
      type: IsarType.string,
    ),
    r'username': PropertySchema(
      id: 3,
      name: r'username',
      type: IsarType.string,
    )
  },
  estimateSize: _userIsarEstimateSize,
  serialize: _userIsarSerialize,
  deserialize: _userIsarDeserialize,
  deserializeProp: _userIsarDeserializeProp,
  idName: r'userId',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _userIsarGetId,
  getLinks: _userIsarGetLinks,
  attach: _userIsarAttach,
  version: '3.1.0+1',
);

int _userIsarEstimateSize(
  UserIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.roleTypeId.length * 3;
  bytesCount += 3 + object.userImage.length * 3;
  bytesCount += 3 + object.username.length * 3;
  return bytesCount;
}

void _userIsarSerialize(
  UserIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.publicUpdatedTimeToken);
  writer.writeString(offsets[1], object.roleTypeId);
  writer.writeString(offsets[2], object.userImage);
  writer.writeString(offsets[3], object.username);
}

UserIsar _userIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = UserIsar();
  object.publicUpdatedTimeToken = reader.readLong(offsets[0]);
  object.roleTypeId = reader.readString(offsets[1]);
  object.id = id;
  object.userImage = reader.readString(offsets[2]);
  object.username = reader.readString(offsets[3]);
  return object;
}

P _userIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _userIsarGetId(UserIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _userIsarGetLinks(UserIsar object) {
  return [];
}

void _userIsarAttach(IsarCollection<dynamic> col, Id id, UserIsar object) {
  object.id = id;
}

extension UserIsarQueryWhereSort on QueryBuilder<UserIsar, UserIsar, QWhere> {
  QueryBuilder<UserIsar, UserIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension UserIsarQueryWhere on QueryBuilder<UserIsar, UserIsar, QWhereClause> {
  QueryBuilder<UserIsar, UserIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<UserIsar, UserIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterWhereClause> idBetween(
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

extension UserIsarQueryFilter
    on QueryBuilder<UserIsar, UserIsar, QFilterCondition> {
  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition>
      publicUpdatedTimeTokenEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'publicUpdatedTimeToken',
        value: value,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition>
      publicUpdatedTimeTokenGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'publicUpdatedTimeToken',
        value: value,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition>
      publicUpdatedTimeTokenLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'publicUpdatedTimeToken',
        value: value,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition>
      publicUpdatedTimeTokenBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'publicUpdatedTimeToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'roleTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'roleTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'roleTypeId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'roleTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'roleTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'roleTypeId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'roleTypeId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> roleTypeIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'roleTypeId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition>
      roleTypeIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'roleTypeId',
        value: '',
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userId',
        value: value,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userImage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userImage',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userImage',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> userImageIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userImage',
        value: '',
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition>
      userImageIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userImage',
        value: '',
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'username',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'username',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'username',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'username',
        value: '',
      ));
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterFilterCondition> usernameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'username',
        value: '',
      ));
    });
  }
}

extension UserIsarQueryObject
    on QueryBuilder<UserIsar, UserIsar, QFilterCondition> {}

extension UserIsarQueryLinks
    on QueryBuilder<UserIsar, UserIsar, QFilterCondition> {}

extension UserIsarQuerySortBy on QueryBuilder<UserIsar, UserIsar, QSortBy> {
  QueryBuilder<UserIsar, UserIsar, QAfterSortBy>
      sortByPublicUpdatedTimeToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicUpdatedTimeToken', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy>
      sortByPublicUpdatedTimeTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicUpdatedTimeToken', Sort.desc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> sortByRoleTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleTypeId', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> sortByRoleTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleTypeId', Sort.desc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> sortByUserImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userImage', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> sortByUserImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userImage', Sort.desc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> sortByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> sortByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension UserIsarQuerySortThenBy
    on QueryBuilder<UserIsar, UserIsar, QSortThenBy> {
  QueryBuilder<UserIsar, UserIsar, QAfterSortBy>
      thenByPublicUpdatedTimeToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicUpdatedTimeToken', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy>
      thenByPublicUpdatedTimeTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'publicUpdatedTimeToken', Sort.desc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> thenByRoleTypeId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleTypeId', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> thenByRoleTypeIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'roleTypeId', Sort.desc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userId', Sort.desc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> thenByUserImage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userImage', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> thenByUserImageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userImage', Sort.desc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> thenByUsername() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.asc);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QAfterSortBy> thenByUsernameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'username', Sort.desc);
    });
  }
}

extension UserIsarQueryWhereDistinct
    on QueryBuilder<UserIsar, UserIsar, QDistinct> {
  QueryBuilder<UserIsar, UserIsar, QDistinct>
      distinctByPublicUpdatedTimeToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'publicUpdatedTimeToken');
    });
  }

  QueryBuilder<UserIsar, UserIsar, QDistinct> distinctByRoleTypeId(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'roleTypeId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QDistinct> distinctByUserImage(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userImage', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<UserIsar, UserIsar, QDistinct> distinctByUsername(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'username', caseSensitive: caseSensitive);
    });
  }
}

extension UserIsarQueryProperty
    on QueryBuilder<UserIsar, UserIsar, QQueryProperty> {
  QueryBuilder<UserIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userId');
    });
  }

  QueryBuilder<UserIsar, int, QQueryOperations>
      publicUpdatedTimeTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'publicUpdatedTimeToken');
    });
  }

  QueryBuilder<UserIsar, String, QQueryOperations> roleTypeIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'roleTypeId');
    });
  }

  QueryBuilder<UserIsar, String, QQueryOperations> userImageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userImage');
    });
  }

  QueryBuilder<UserIsar, String, QQueryOperations> usernameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'username');
    });
  }
}
