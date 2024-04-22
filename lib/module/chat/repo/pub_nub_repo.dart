import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pubnub/networking.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

import 'package:pubnub/pubnub.dart';

class PubNubInstance {
  late PubNub _pubnub;
  late Subscription _subscription;

  late String channelGroup = "users";
  final Set<String> _channelList = {"online"};

  var envelopeController = StreamController<Envelope>.broadcast();
  var presenceController = StreamController<PresenceEvent>.broadcast();

  PubNub get instance => _pubnub;
  Subscription get subscription => _subscription;
  Set<String> get channelList => _channelList;
  String get _uuid => _pubnub.keysets.defaultKeyset.userId.toString();

  static int visit = 0;

  set setSubscription(Subscription subscription) =>
      _subscription = subscription;

  static Timer? _heartbeatTimer;

  PubNubInstance(currentUser) {
    _pubnub = PubNub(
      networking: NetworkingModule(retryPolicy: RetryPolicy.exponential()),
      defaultKeyset: Keyset(
        subscribeKey: dotenv.env['PUBNUB_SUBSCRIBE_KEY']!,
        publishKey: dotenv.env['PUBNUB_PUBLISH_KEY'],
        userId: UserId(currentUser.id.toString()),
      ),
    );
    _pubnub.channelGroups.addChannels(channelGroup, _channelList);
    _subscription =
        _pubnub.subscribe(channelGroups: {channelGroup}, withPresence: true);
    _subscription.resume();
    print('Pubnub Creating instance UUID : $_uuid');
    startHeartbeats();
  }

  startHeartbeats() {
    _heartbeatTimer ??=
        Timer.periodic(const Duration(seconds: 30), _heartbeatCall);
  }

  dispose() async {
    envelopeController.close();
    presenceController.close();
    stopHeartbeats();
    await _pubnub.announceLeave(channelGroups: {channelGroup});
    if (!_subscription.isCancelled) await _subscription.cancel();
  }

  stopHeartbeats() {
    if (_heartbeatTimer != null && _heartbeatTimer!.isActive) {
      _heartbeatTimer!.cancel();
      _heartbeatTimer = null;
    }
  }

  Future<void> _heartbeatCall(Timer timer) async {
    // For Debugging connectinvity with pubnub
    // print("**PUBNUBConnected ${utility.getUnixTimeStampInPubNubPrecision()}");
    await _pubnub.announceHeartbeat(channels: _channelList);
  }

  void announceLeave() async =>
      await _pubnub.announceLeave(channelGroups: {channelGroup});

  void resume() => _subscription.resume();

  pauseSubscribeChannel([String channelName = ""]) {
    if (channelName.isNotEmpty) {
      _subscription.pause();
    }
    return;
  }

  sendSignal(String channel, String message) async {
    try {
      if (channel.isEmpty) return null;
      await _pubnub.signal(channel, message);
    } catch (e, stacktrace) {
      print('''Error: $e \n StackTrace: $stacktrace''');
      return null;
    }
  }

  subscribeChannel([dynamic channelName = ""]) async {
    visit++;
    bool isExitSet = false;
    // print('subscribeChannel instance UUID : $_uuid');
    if (channelName.isNotEmpty) {
      if (channelName.runtimeType.toString() == 'String') {
        isExitSet = _channelList.add(channelName);
        if (isExitSet == true) {
          await _pubnub.unsubscribeAll();
          _subscription =
              _pubnub.subscribe(channels: _channelList, withPresence: true);
          print(
              '***** Channel Name $channelName ***** ${_subscription.toString()}');
          setSubscription = _subscription;
        }
      } else {
        await _pubnub.unsubscribeAll();
        // print("-----$channelName");
        _channelList.addAll(channelName);
        _subscription =
            _pubnub.subscribe(channels: _channelList, withPresence: true);
        setSubscription = _subscription;
      }
      if (kDebugMode) {
        print("subscribeChannel: ${_channelList.length}");
      }
      // print("Subscription called: $visit");
      // _subscription.resume();
    }

    _subscription.messages.listen((event) {
      envelopeController.sink.add(event);
    });

    _subscription.presence.listen((event) {
      presenceController.sink.add(event);
    });
  }

  unSubscribeChannel([dynamic channelName = ""]) async {
    var subscription = _pubnub.subscribe(channels: {channelName});
    await subscription.cancel();
  }

  cancelSubscription() async {
    dispose();
    // print('cancelSubscription instance UUID : $_uuid');
    await _subscription.cancel();
  }

  Future<PublishResult> sendMessage(String channel, String message,
      [bool store = true, int storeForHrs = 40]) async {
    PublishResult result = await _pubnub.publish(
      channel,
      jsonEncode({"text": message}),
      storeMessage: store,
      ttl: storeForHrs,
    );
    return result;
  }

  // Remove the function after call finalized from chatRepo
  getHistory(String channel, [String start = '', int count = 10]) async {
    Timetoken sendStart;
    (start.isEmpty)
        ? sendStart = Timetoken(BigInt.parse(
            app_instance.utility.getUnixTimeStampInPubNubPrecision()))
        : sendStart = Timetoken(BigInt.parse(start));

    BatchHistoryResult messageHistory = await _pubnub.batch
        .fetchMessages({channel}, start: sendStart, count: 10);

    return (messageHistory.channels[channel] == null)
        ? []
        : messageHistory.channels[channel];
  }

  clearHistory(channelName) {
    _pubnub.channel(channelName).messages().delete();
  }

  Stream<int> tick({required int ticks}) {
    return Stream.periodic(const Duration(seconds: 1), (x) => ticks - x - 1)
        .take(ticks);
  }

  getPubNubServerTime() async {
    return await _pubnub.time();
  }

  getUnreadCount({
    required String channel,
    required String currentUserId,
    required String lastVisitTime,
  }) async {
    int count = 0;
    BatchHistoryResult messageHistory = await _pubnub.batch.fetchMessages(
      {channel},
      end: Timetoken(BigInt.parse(lastVisitTime)),
    );

    List<BatchHistoryResultEntry>? getMessageHistory =
        messageHistory.channels[channel];

    if (getMessageHistory != null) {
      for (int i = 0; i < getMessageHistory.length; i++) {
        dynamic userId =
            getMessageHistory[i].uuid.toString().replaceAll('"', '');
        if (currentUserId != userId) {
          count++;
        }
      }
    }
    return count.toString();
  }

  checkNumberOfPresence(String channel) async {
    final result = await _pubnub.hereNow(channels: {channel});
    return result.totalOccupancy;
  }

  getChannelUsers(String channel) async {
    final result = await _pubnub.hereNow(channels: {channel});
    print(result.channels[channel]);
    return result.channels[channel];
  }
}
