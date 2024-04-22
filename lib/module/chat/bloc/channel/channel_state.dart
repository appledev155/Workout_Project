part of 'channel_bloc.dart';

enum ChannelStatus {
  initial,
  loading,
  success,
  failure,
  updated,
  updating,
  newChannelInitiate,
  channelDeleted,
  movetochat,
  newRequestCreated,
  localSyncStarted,
  localSyncInprogress,
  localSyncEnd,
  serverSyncStarted,
  serverSyncInprogress,
  serverSyncEnd
}

class ChannelState extends Equatable {
  const ChannelState({
    this.status = ChannelStatus.initial,
    this.totalChannelAtServer = 0,
    this.totalChannelAtLocal = 0,
    this.channelList = const <ChatChannel>[],
    this.serverChannelList = const <ChatChannel>[],
    this.toUsers = const <ChatUser>[],
    this.hasReachedMax = false,
    this.lastVisitedChannel = ChatChannel.empty,
    this.typingIndicator = '',
    this.unreadChannelCount = 0,
    this.unreadPrivateChannelCount = 0,
    this.channelLastSyncTime = '',
    this.currentActiveChannel = ChatChannel.empty,
  });

  final ChannelStatus status;
  final List<ChatChannel> channelList;
  final List<ChatChannel> serverChannelList;
  final List<ChatUser> toUsers;
  final ChatChannel lastVisitedChannel;
  final bool hasReachedMax;
  final String typingIndicator;
  final int unreadChannelCount;
  final int unreadPrivateChannelCount;
  final String channelLastSyncTime;
  final ChatChannel currentActiveChannel;
  final int totalChannelAtServer;
  final int totalChannelAtLocal;

  ChannelState copyWith({
    ChannelStatus? status,
    List<ChatChannel>? channelList,
    List<ChatChannel>? serverChannelList,
    List<ChatUser>? toUsers,
    bool? hasReachedMax,
    String? typingIndicator,
    ChatChannel? lastVisitedChannel,
    ChatChannel? currentActiveChannel,
    int? unreadChannelCount,
    int? unreadPrivateChannelCount,
    String? channelLastSyncTime,
    int? totalChannelAtServer,
    int? totalChannelAtLocal,
  }) {
    ChannelState channelState = ChannelState(
      status: status ?? this.status,
      channelList: channelList ?? this.channelList,
      serverChannelList: serverChannelList ?? this.serverChannelList,
      toUsers: toUsersUnique(toUsers),
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      lastVisitedChannel: lastVisitedChannel ?? this.lastVisitedChannel,
      currentActiveChannel: currentActiveChannel ?? this.currentActiveChannel,
      typingIndicator: typingIndicator ?? this.typingIndicator,
      unreadChannelCount: (status == ChannelStatus.success ||
              status == ChannelStatus.newChannelInitiate ||
              status == ChannelStatus.serverSyncEnd ||
              status == ChannelStatus.localSyncEnd)
          ? countUnreadChannel(channelList ?? this.channelList)[0]
          : this.unreadChannelCount,
      unreadPrivateChannelCount: (status == ChannelStatus.success ||
              status == ChannelStatus.newChannelInitiate ||
              status == ChannelStatus.serverSyncEnd ||
              status == ChannelStatus.localSyncEnd)
          ? countUnreadChannel(channelList ?? this.channelList)[1]
          : this.unreadPrivateChannelCount,
      channelLastSyncTime: channelLastSyncTime ?? this.channelLastSyncTime,
      totalChannelAtServer: totalChannelAtServer ?? this.totalChannelAtServer,
      totalChannelAtLocal: totalChannelAtLocal ?? this.totalChannelAtLocal,
    );

    return channelState;
  }

  List<ChatUser> toUsersUnique(toUsers) {
    if (toUsers != null && toUsers.isNotEmpty) {
      return [
        ...{...toUsers}
      ];
    } else {
      return [
        ...{...this.toUsers}
      ];
    }
  }

  dynamic countUnreadChannel(channelList) {
    int count = 0;
    int unreadPrivateChannelCount = 0;
    for (var element in channelList) {
      if (element.channelId != currentActiveChannel.channelId) {
        if (element.unreadMessageCount != '0') {
          count++;
          if (int.parse(element.channelId) > 2) {
            unreadPrivateChannelCount++;
          }
        }
      }
    }
    return [count, unreadPrivateChannelCount];
  }

  factory ChannelState.fromJson(Map<String, dynamic> json) {
    try {
      ChannelStatus status = ChannelStatus.values
          .firstWhere((e) => e.toString() == json['status']);

      List<ChatChannel> channelList = [];
      if (json['channelList'].length > 0) {
        List channelListArray = json['channelList'];
        for (int i = 0; i < channelListArray.length; i++) {
          if (channelList.contains(channelListArray[i]) == false) {
            channelList.add(ChatChannel.fromJson(channelListArray[i]));
          }
        }
      }

      List<ChatUser> chatUser = [];
      if (json['toUsers'].length > 0) {
        List toUsersArray = json['toUsers'];
        for (int i = 0; i < toUsersArray.length; i++) {
          chatUser.add(ChatUser.fromJson(toUsersArray[i]));
        }
      }

      ChannelState chatState = ChannelState(
        status: status,
        toUsers: chatUser,
        channelList: channelList,
      );

      return chatState;
    } catch (e, stacktrace) {
      print('Exception occurred: $e stackTrace: $stacktrace');
      rethrow;
    }
  }

  /// Useful if Hydreddbloc used
  Map<String, dynamic> toJson() {
    try {
      String currentChannelList = '';
      for (var element in channelList) {
        "$currentChannelList, ${element.toJson()}";
      }

      return {
        'status': status.toString(),
        'toUsers': toUsers,
        'channelList': currentChannelList,
      };
    } catch (e, stacktrace) {
      print('Exception occurred: $e stackTrace: $stacktrace');
      rethrow;
    }
  }

  @override
  String toString() {
    return 'ChannelState {status: $status, channelList: ${channelList.length}, serverChannelList: ${serverChannelList.length} toUsers: ${toUsers.length}, hasReachedMax: $hasReachedMax, lastVisitedChannel: $lastVisitedChannel, typingIndicator: $typingIndicator, unreadChannelCount: $unreadChannelCount, currentActiveChannel: $currentActiveChannel, totalChannelAtServer: $totalChannelAtServer, totalChannelAtLocal: $totalChannelAtLocal, channelLastSyncTime: $channelLastSyncTime, unreadPrivateChannelCount: $unreadPrivateChannelCount,}';
  }

  @override
  List<Object> get props => [
        status,
        channelList,
        hasReachedMax,
        toUsers,
        lastVisitedChannel,
        typingIndicator,
        unreadChannelCount,
        currentActiveChannel,
        totalChannelAtServer,
        totalChannelAtLocal,
        channelLastSyncTime,
        unreadPrivateChannelCount,
      ];
}
