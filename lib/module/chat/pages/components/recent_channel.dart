import 'dart:async';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/pages/components/channel_row.dart';
import 'package:anytimeworkout/views/components/center_loader.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/chat_model.dart';
import 'package:anytimeworkout/isar/channel/channel.dart' as channel_store;
import 'package:anytimeworkout/config.dart' as app_instance;

class RecentChannel extends StatefulWidget {
  const RecentChannel({super.key});

  @override
  State<RecentChannel> createState() => _RecentChannelState();
}

class _RecentChannelState extends State<RecentChannel> {
  final _scrollController = ScrollController();
  Timer indicatorTimer = Timer(const Duration(seconds: 0), () {});
  Color cardColor = lightColor;
  dynamic decodedChannelData;
  channel_store.Channel channelStore = channel_store.Channel();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    BlocProvider.of<ChannelBloc>(context).state;

    if (_isBottom) {
      if (BlocProvider.of<ChannelBloc>(context).state.hasReachedMax) {
        if (context.read<ChannelBloc>().state.totalChannelAtLocal !=
            context.read<ChannelBloc>().state.totalChannelAtServer) {
          await app_instance.appConfigStore
              .saveAppConfig(app_instance.appConfigIsar
                ..configName = "channelLastSyncTime"
                ..configValue = '');
        }
        if (!mounted) return;
        context.read<ChannelBloc>().add(
            const FetchFromStore(status: ChannelStatus.localSyncInprogress));
        return;
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    bool showLoader = false;

    return Stack(
      children: [
        RefreshIndicator(
          onRefresh: () async {
            context
                .read<ChannelBloc>()
                .add(const FetchFromStore(status: ChannelStatus.initial));
          },
          child: BlocConsumer<ChannelBloc, ChannelState>(
            listener: (context, state) {},
            buildWhen: (previous, current) =>
                previous.status != current.status ||
                previous.channelList != current.channelList,
            builder: (context, state) {
              if (state.status == ChannelStatus.initial &&
                  state.channelList.length <= 10) {
                return const CenterLoader();
              } else {
                return Column(
                  children: [
                    if (state.status == ChannelStatus.localSyncStarted ||
                        state.status == ChannelStatus.localSyncInprogress ||
                        state.status == ChannelStatus.serverSyncInprogress ||
                        state.status == ChannelStatus.serverSyncStarted ||
                        state.status == ChannelStatus.loading ||
                        (state.status == ChannelStatus.initial &&
                            state.channelList.length < 10))
                      const LinearProgressIndicator(),
                    if (kDebugMode) ...[Text('${state.status}')],
                    Expanded(
                        child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        int channelCount = 10;
                        return index >= state.channelList.length
                            ? (state.channelList.length <= channelCount)
                                ? const SizedBox.shrink()
                                : const BottomLoader()
                            : ChannelRow(
                                channel: state.channelList[index],
                                cardColor: cardColor,
                              );
                      },
                      itemCount: state.hasReachedMax
                          ? state.channelList.length
                          : state.channelList.length + 1,
                      controller: _scrollController,
                    )),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    indicatorTimer.cancel();
    super.dispose();
  }
}

class BottomLoader extends StatelessWidget {
  const BottomLoader({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(strokeWidth: 1.5),
      ),
    );
  }
}
