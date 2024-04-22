import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../views/screens/main_layout.dart';
import '../bloc/channel/channel_bloc.dart';
import 'components/recent_channel.dart';

class ChannelPage extends StatelessWidget {
  final bool? fromNotification;
  const ChannelPage({super.key, this.fromNotification});

  @override
  Widget build(BuildContext context) {
    if (fromNotification == true) {
      context
          .read<ChannelBloc>()
          .add(const FetchFromStore(status: ChannelStatus.initial));
    }
    return MainLayout(
        color: true,
        appBarTitle: 'chat_section.lbl_message'.tr(),
        ctx: 2,
        status: 3,
        bottomMenu: true,
        child: BlocListener<ChannelBloc, ChannelState>(
          listener: (context, state) {},
          child: const RecentChannel(),
        ));
  }
}
