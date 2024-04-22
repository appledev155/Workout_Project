// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channel_isar.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetChannelIsarCollection on Isar {
  IsarCollection<ChannelIsar> get channelIsars => this.collection();
}

const ChannelIsarSchema = CollectionSchema(
  name: r'Channel',
  id: 3096422491918372507,
  properties: {
    r'channelData': PropertySchema(
      id: 0,
      name: r'channelData',
      type: IsarType.string,
    ),
    r'channelName': PropertySchema(
      id: 1,
      name: r'channelName',
      type: IsarType.string,
    ),
    r'chatFlag': PropertySchema(
      id: 2,
      name: r'chatFlag',
      type: IsarType.string,
    ),
    r'chatToUserId': PropertySchema(
      id: 3,
      name: r'chatToUserId',
      type: IsarType.longList,
    ),
    r'chatUserId': PropertySchema(
      id: 4,
      name: r'chatUserId',
      type: IsarType.long,
    ),
    r'lastMessageRow': PropertySchema(
      id: 5,
      name: r'lastMessageRow',
      type: IsarType.string,
    ),
    r'lastMessageSentTime': PropertySchema(
      id: 6,
      name: r'lastMessageSentTime',
      type: IsarType.long,
    ),
    r'lastMessageTime': PropertySchema(
      id: 7,
      name: r'lastMessageTime',
      type: IsarType.long,
    ),
    r'lastVisitTime': PropertySchema(
      id: 8,
      name: r'lastVisitTime',
      type: IsarType.long,
    ),
    r'totalNumberOfMessages': PropertySchema(
      id: 9,
      name: r'totalNumberOfMessages',
      type: IsarType.long,
    ),
    r'typingIndicator': PropertySchema(
      id: 10,
      name: r'typingIndicator',
      type: IsarType.string,
    ),
    r'typingIndicatorStartTime': PropertySchema(
      id: 11,
      name: r'typingIndicatorStartTime',
      type: IsarType.string,
    ),
    r'unreadMessageCount': PropertySchema(
      id: 12,
      name: r'unreadMessageCount',
      type: IsarType.string,
    )
  },
  estimateSize: _channelIsarEstimateSize,
  serialize: _channelIsarSerialize,
  deserialize: _channelIsarDeserialize,
  deserializeProp: _channelIsarDeserializeProp,
  idName: r'channelId',
  indexes: {
    r'channelName': IndexSchema(
      id: 1722217242319557722,
      name: r'channelName',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'channelName',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'lastMessageTime': IndexSchema(
      id: -209683041052770976,
      name: r'lastMessageTime',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'lastMessageTime',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _channelIsarGetId,
  getLinks: _channelIsarGetLinks,
  attach: _channelIsarAttach,
  version: '3.1.0+1',
);

int _channelIsarEstimateSize(
  ChannelIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.channelData;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.channelName.length * 3;
  {
    final value = object.chatFlag;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.chatToUserId.length * 8;
  bytesCount += 3 + object.lastMessageRow.length * 3;
  {
    final value = object.typingIndicator;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.typingIndicatorStartTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.unreadMessageCount.length * 3;
  return bytesCount;
}

void _channelIsarSerialize(
  ChannelIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.channelData);
  writer.writeString(offsets[1], object.channelName);
  writer.writeString(offsets[2], object.chatFlag);
  writer.writeLongList(offsets[3], object.chatToUserId);
  writer.writeLong(offsets[4], object.chatUserId);
  writer.writeString(offsets[5], object.lastMessageRow);
  writer.writeLong(offsets[6], object.lastMessageSentTime);
  writer.writeLong(offsets[7], object.lastMessageTime);
  writer.writeLong(offsets[8], object.lastVisitTime);
  writer.writeLong(offsets[9], object.totalNumberOfMessages);
  writer.writeString(offsets[10], object.typingIndicator);
  writer.writeString(offsets[11], object.typingIndicatorStartTime);
  writer.writeString(offsets[12], object.unreadMessageCount);
}

ChannelIsar _channelIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ChannelIsar();
  object.channelData = reader.readStringOrNull(offsets[0]);
  object.id = id;
  object.channelName = reader.readString(offsets[1]);
  object.chatFlag = reader.readStringOrNull(offsets[2]);
  object.chatToUserId = reader.readLongList(offsets[3]) ?? [];
  object.chatUserId = reader.readLong(offsets[4]);
  object.lastMessageRow = reader.readString(offsets[5]);
  object.lastMessageSentTime = reader.readLong(offsets[6]);
  object.lastMessageTime = reader.readLong(offsets[7]);
  object.lastVisitTime = reader.readLong(offsets[8]);
  object.totalNumberOfMessages = reader.readLong(offsets[9]);
  object.typingIndicator = reader.readStringOrNull(offsets[10]);
  object.typingIndicatorStartTime = reader.readStringOrNull(offsets[11]);
  object.unreadMessageCount = reader.readString(offsets[12]);
  return object;
}

P _channelIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readLongList(offset) ?? []) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readStringOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _channelIsarGetId(ChannelIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _channelIsarGetLinks(ChannelIsar object) {
  return [];
}

void _channelIsarAttach(
    IsarCollection<dynamic> col, Id id, ChannelIsar object) {
  object.id = id;
}

extension ChannelIsarByIndex on IsarCollection<ChannelIsar> {
  Future<ChannelIsar?> getByChannelName(String channelName) {
    return getByIndex(r'channelName', [channelName]);
  }

  ChannelIsar? getByChannelNameSync(String channelName) {
    return getByIndexSync(r'channelName', [channelName]);
  }

  Future<bool> deleteByChannelName(String channelName) {
    return deleteByIndex(r'channelName', [channelName]);
  }

  bool deleteByChannelNameSync(String channelName) {
    return deleteByIndexSync(r'channelName', [channelName]);
  }

  Future<List<ChannelIsar?>> getAllByChannelName(
      List<String> channelNameValues) {
    final values = channelNameValues.map((e) => [e]).toList();
    return getAllByIndex(r'channelName', values);
  }

  List<ChannelIsar?> getAllByChannelNameSync(List<String> channelNameValues) {
    final values = channelNameValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'channelName', values);
  }

  Future<int> deleteAllByChannelName(List<String> channelNameValues) {
    final values = channelNameValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'channelName', values);
  }

  int deleteAllByChannelNameSync(List<String> channelNameValues) {
    final values = channelNameValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'channelName', values);
  }

  Future<Id> putByChannelName(ChannelIsar object) {
    return putByIndex(r'channelName', object);
  }

  Id putByChannelNameSync(ChannelIsar object, {bool saveLinks = true}) {
    return putByIndexSync(r'channelName', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByChannelName(List<ChannelIsar> objects) {
    return putAllByIndex(r'channelName', objects);
  }

  List<Id> putAllByChannelNameSync(List<ChannelIsar> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'channelName', objects, saveLinks: saveLinks);
  }
}

extension ChannelIsarQueryWhereSort
    on QueryBuilder<ChannelIsar, ChannelIsar, QWhere> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhere> anyLastMessageTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'lastMessageTime'),
      );
    });
  }
}

extension ChannelIsarQueryWhere
    on QueryBuilder<ChannelIsar, ChannelIsar, QWhereClause> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> idBetween(
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

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause> channelNameEqualTo(
      String channelName) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'channelName',
        value: [channelName],
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause>
      channelNameNotEqualTo(String channelName) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'channelName',
              lower: [],
              upper: [channelName],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'channelName',
              lower: [channelName],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'channelName',
              lower: [channelName],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'channelName',
              lower: [],
              upper: [channelName],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause>
      lastMessageTimeEqualTo(int lastMessageTime) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'lastMessageTime',
        value: [lastMessageTime],
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause>
      lastMessageTimeNotEqualTo(int lastMessageTime) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastMessageTime',
              lower: [],
              upper: [lastMessageTime],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastMessageTime',
              lower: [lastMessageTime],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastMessageTime',
              lower: [lastMessageTime],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'lastMessageTime',
              lower: [],
              upper: [lastMessageTime],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause>
      lastMessageTimeGreaterThan(
    int lastMessageTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastMessageTime',
        lower: [lastMessageTime],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause>
      lastMessageTimeLessThan(
    int lastMessageTime, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastMessageTime',
        lower: [],
        upper: [lastMessageTime],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterWhereClause>
      lastMessageTimeBetween(
    int lowerLastMessageTime,
    int upperLastMessageTime, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'lastMessageTime',
        lower: [lowerLastMessageTime],
        includeLower: includeLower,
        upper: [upperLastMessageTime],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ChannelIsarQueryFilter
    on QueryBuilder<ChannelIsar, ChannelIsar, QFilterCondition> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'channelData',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'channelData',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelData',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'channelData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'channelData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'channelData',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'channelData',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelData',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelDataIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'channelData',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'channelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'channelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'channelName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'channelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'channelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'channelName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'channelName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'channelName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      channelNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'channelName',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'chatFlag',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'chatFlag',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> chatFlagEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatFlag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatFlag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatFlag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> chatFlagBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatFlag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'chatFlag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'chatFlag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'chatFlag',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition> chatFlagMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'chatFlag',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatFlag',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatFlagIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'chatFlag',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdElementEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatToUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdElementGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatToUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdElementLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatToUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdElementBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatToUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatToUserId',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatToUserId',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatToUserId',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatToUserId',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatToUserId',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatToUserIdLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'chatToUserId',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatUserIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chatUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatUserIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chatUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatUserIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chatUserId',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      chatUserIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chatUserId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageRow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessageRow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessageRow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessageRow',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastMessageRow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastMessageRow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastMessageRow',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastMessageRow',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageRow',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageRowIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastMessageRow',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageSentTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageSentTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageSentTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessageSentTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageSentTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessageSentTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageSentTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessageSentTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastMessageTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastMessageTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastMessageTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastMessageTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastMessageTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastVisitTimeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastVisitTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastVisitTimeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastVisitTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastVisitTimeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastVisitTime',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      lastVisitTimeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastVisitTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      totalNumberOfMessagesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalNumberOfMessages',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      totalNumberOfMessagesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalNumberOfMessages',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      totalNumberOfMessagesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalNumberOfMessages',
        value: value,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      totalNumberOfMessagesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalNumberOfMessages',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'typingIndicator',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'typingIndicator',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typingIndicator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typingIndicator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typingIndicator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typingIndicator',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typingIndicator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typingIndicator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typingIndicator',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typingIndicator',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typingIndicator',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typingIndicator',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'typingIndicatorStartTime',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'typingIndicatorStartTime',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typingIndicatorStartTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'typingIndicatorStartTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'typingIndicatorStartTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'typingIndicatorStartTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'typingIndicatorStartTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'typingIndicatorStartTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'typingIndicatorStartTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'typingIndicatorStartTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'typingIndicatorStartTime',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      typingIndicatorStartTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'typingIndicatorStartTime',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unreadMessageCount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'unreadMessageCount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'unreadMessageCount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'unreadMessageCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'unreadMessageCount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'unreadMessageCount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'unreadMessageCount',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'unreadMessageCount',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'unreadMessageCount',
        value: '',
      ));
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterFilterCondition>
      unreadMessageCountIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'unreadMessageCount',
        value: '',
      ));
    });
  }
}

extension ChannelIsarQueryObject
    on QueryBuilder<ChannelIsar, ChannelIsar, QFilterCondition> {}

extension ChannelIsarQueryLinks
    on QueryBuilder<ChannelIsar, ChannelIsar, QFilterCondition> {}

extension ChannelIsarQuerySortBy
    on QueryBuilder<ChannelIsar, ChannelIsar, QSortBy> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChannelData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelData', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChannelDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelData', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChannelName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelName', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChannelNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelName', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChatFlag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatFlag', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChatFlagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatFlag', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChatUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatUserId', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByChatUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatUserId', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByLastMessageRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageRow', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByLastMessageRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageRow', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByLastMessageSentTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageSentTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByLastMessageSentTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageSentTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByLastMessageTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByLastMessageTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByLastVisitTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVisitTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByLastVisitTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVisitTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByTotalNumberOfMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalNumberOfMessages', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByTotalNumberOfMessagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalNumberOfMessages', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> sortByTypingIndicator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typingIndicator', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByTypingIndicatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typingIndicator', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByTypingIndicatorStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typingIndicatorStartTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByTypingIndicatorStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typingIndicatorStartTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByUnreadMessageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadMessageCount', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      sortByUnreadMessageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadMessageCount', Sort.desc);
    });
  }
}

extension ChannelIsarQuerySortThenBy
    on QueryBuilder<ChannelIsar, ChannelIsar, QSortThenBy> {
  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChannelData() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelData', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChannelDataDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelData', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelId', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChannelName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelName', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChannelNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'channelName', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChatFlag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatFlag', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChatFlagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatFlag', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChatUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatUserId', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByChatUserIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chatUserId', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByLastMessageRow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageRow', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByLastMessageRowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageRow', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByLastMessageSentTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageSentTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByLastMessageSentTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageSentTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByLastMessageTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByLastMessageTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastMessageTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByLastVisitTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVisitTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByLastVisitTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastVisitTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByTotalNumberOfMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalNumberOfMessages', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByTotalNumberOfMessagesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalNumberOfMessages', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy> thenByTypingIndicator() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typingIndicator', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByTypingIndicatorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typingIndicator', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByTypingIndicatorStartTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typingIndicatorStartTime', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByTypingIndicatorStartTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'typingIndicatorStartTime', Sort.desc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByUnreadMessageCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadMessageCount', Sort.asc);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QAfterSortBy>
      thenByUnreadMessageCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'unreadMessageCount', Sort.desc);
    });
  }
}

extension ChannelIsarQueryWhereDistinct
    on QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> {
  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByChannelData(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelData', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByChannelName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'channelName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByChatFlag(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatFlag', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByChatToUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatToUserId');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByChatUserId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chatUserId');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByLastMessageRow(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessageRow',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByLastMessageSentTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessageSentTime');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByLastMessageTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastMessageTime');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByLastVisitTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastVisitTime');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByTotalNumberOfMessages() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalNumberOfMessages');
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct> distinctByTypingIndicator(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typingIndicator',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByTypingIndicatorStartTime({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'typingIndicatorStartTime',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ChannelIsar, ChannelIsar, QDistinct>
      distinctByUnreadMessageCount({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'unreadMessageCount',
          caseSensitive: caseSensitive);
    });
  }
}

extension ChannelIsarQueryProperty
    on QueryBuilder<ChannelIsar, ChannelIsar, QQueryProperty> {
  QueryBuilder<ChannelIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelId');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations> channelDataProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelData');
    });
  }

  QueryBuilder<ChannelIsar, String, QQueryOperations> channelNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'channelName');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations> chatFlagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatFlag');
    });
  }

  QueryBuilder<ChannelIsar, List<int>, QQueryOperations>
      chatToUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatToUserId');
    });
  }

  QueryBuilder<ChannelIsar, int, QQueryOperations> chatUserIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chatUserId');
    });
  }

  QueryBuilder<ChannelIsar, String, QQueryOperations> lastMessageRowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessageRow');
    });
  }

  QueryBuilder<ChannelIsar, int, QQueryOperations>
      lastMessageSentTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessageSentTime');
    });
  }

  QueryBuilder<ChannelIsar, int, QQueryOperations> lastMessageTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastMessageTime');
    });
  }

  QueryBuilder<ChannelIsar, int, QQueryOperations> lastVisitTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastVisitTime');
    });
  }

  QueryBuilder<ChannelIsar, int, QQueryOperations>
      totalNumberOfMessagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalNumberOfMessages');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations>
      typingIndicatorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typingIndicator');
    });
  }

  QueryBuilder<ChannelIsar, String?, QQueryOperations>
      typingIndicatorStartTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'typingIndicatorStartTime');
    });
  }

  QueryBuilder<ChannelIsar, String, QQueryOperations>
      unreadMessageCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'unreadMessageCount');
    });
  }
}
