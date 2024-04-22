// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sharePhoto.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSharePhotoCollection on Isar {
  IsarCollection<SharePhoto> get sharePhotos => this.collection();
}

const SharePhotoSchema = CollectionSchema(
  name: r'sharephoto',
  id: 8517042810942996959,
  properties: {
    r'selectvalue': PropertySchema(
      id: 0,
      name: r'selectvalue',
      type: IsarType.bool,
    )
  },
  estimateSize: _sharePhotoEstimateSize,
  serialize: _sharePhotoSerialize,
  deserialize: _sharePhotoDeserialize,
  deserializeProp: _sharePhotoDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _sharePhotoGetId,
  getLinks: _sharePhotoGetLinks,
  attach: _sharePhotoAttach,
  version: '3.1.0+1',
);

int _sharePhotoEstimateSize(
  SharePhoto object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _sharePhotoSerialize(
  SharePhoto object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.selectvalue);
}

SharePhoto _sharePhotoDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SharePhoto(
    id: id,
    selectvalue: reader.readBool(offsets[0]),
  );
  return object;
}

P _sharePhotoDeserializeProp<P>(
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

Id _sharePhotoGetId(SharePhoto object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _sharePhotoGetLinks(SharePhoto object) {
  return [];
}

void _sharePhotoAttach(IsarCollection<dynamic> col, Id id, SharePhoto object) {
  object.id = id;
}

extension SharePhotoQueryWhereSort
    on QueryBuilder<SharePhoto, SharePhoto, QWhere> {
  QueryBuilder<SharePhoto, SharePhoto, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension SharePhotoQueryWhere
    on QueryBuilder<SharePhoto, SharePhoto, QWhereClause> {
  QueryBuilder<SharePhoto, SharePhoto, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SharePhoto, SharePhoto, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterWhereClause> idBetween(
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

extension SharePhotoQueryFilter
    on QueryBuilder<SharePhoto, SharePhoto, QFilterCondition> {
  QueryBuilder<SharePhoto, SharePhoto, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SharePhoto, SharePhoto, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SharePhoto, SharePhoto, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SharePhoto, SharePhoto, QAfterFilterCondition>
      selectvalueEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'selectvalue',
        value: value,
      ));
    });
  }
}

extension SharePhotoQueryObject
    on QueryBuilder<SharePhoto, SharePhoto, QFilterCondition> {}

extension SharePhotoQueryLinks
    on QueryBuilder<SharePhoto, SharePhoto, QFilterCondition> {}

extension SharePhotoQuerySortBy
    on QueryBuilder<SharePhoto, SharePhoto, QSortBy> {
  QueryBuilder<SharePhoto, SharePhoto, QAfterSortBy> sortBySelectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectvalue', Sort.asc);
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterSortBy> sortBySelectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectvalue', Sort.desc);
    });
  }
}

extension SharePhotoQuerySortThenBy
    on QueryBuilder<SharePhoto, SharePhoto, QSortThenBy> {
  QueryBuilder<SharePhoto, SharePhoto, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterSortBy> thenBySelectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectvalue', Sort.asc);
    });
  }

  QueryBuilder<SharePhoto, SharePhoto, QAfterSortBy> thenBySelectvalueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'selectvalue', Sort.desc);
    });
  }
}

extension SharePhotoQueryWhereDistinct
    on QueryBuilder<SharePhoto, SharePhoto, QDistinct> {
  QueryBuilder<SharePhoto, SharePhoto, QDistinct> distinctBySelectvalue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'selectvalue');
    });
  }
}

extension SharePhotoQueryProperty
    on QueryBuilder<SharePhoto, SharePhoto, QQueryProperty> {
  QueryBuilder<SharePhoto, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SharePhoto, bool, QQueryOperations> selectvalueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'selectvalue');
    });
  }
}
