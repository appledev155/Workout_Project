import 'dart:io';

import 'package:anytimeworkout/bloc/blocked_users_bloc/blocked_users_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../module/chat/pages/components/bottom_loader.dart';
import '../../components/block_user_row.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});
  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final ScrollController _scrollController = ScrollController();
  String? curPage = '0';
  TextEditingController tempScrollFlagcontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    BlocProvider.of<BlockedUsersBloc>(context).state;

    if (_isBottom) {
      if (BlocProvider.of<BlockedUsersBloc>(context).state.hasReachedMax) {
        return;
      }
      context.read<BlockedUsersBloc>().add(const BlockedUsersFetched());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Navigator.popUntil(context, ModalRoute.withName('/channel'));
        Navigator.pushNamed(context, '/channel');
        return true;
      },
      child: Scaffold(
        backgroundColor: lightColor,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
              systemNavigationBarColor: lightColor,
              systemNavigationBarIconBrightness: Brightness.dark,
              statusBarColor: primaryColor,
              statusBarIconBrightness: Brightness.dark),
          title: const Text("settings.lbl_blocked_users",
                  style: TextStyle(color: blackColor))
              .tr(),
          leading: ModalRoute.of(context)?.canPop == true
              ? IconButton(
                  icon: Icon(
                    (context.locale.toString() == "en_US")
                        ? (Platform.isIOS)
                            ? iosBackButton
                            : backArrow
                        // : (context.locale.toString() == "ar_AR")
                        //     ? (Platform.isIOS)
                        //         ? iosForwardButton
                        //         : forwardArrow
                            : iosForwardButton,
                    color: blackColor,
                  ),
                  onPressed: () => Navigator.popUntil(
                      context, ModalRoute.withName('/setting')))
              : null,
          elevation: 1,
          centerTitle: true,
          backgroundColor: primaryColor,
        ),
        body: BlocConsumer<BlockedUsersBloc, BlockedUsersState>(
          listenWhen: (previous, current) {
            return (previous.status != current.status);
          },
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.status) {
              case BlockedUsersStatus.initial:
                return const Center(child: CircularProgressIndicator());
              case BlockedUsersStatus.failure:
                return Center(
                  child: const Text("settings.lbl_failed_to_fetch_data").tr(),
                );
              case BlockedUsersStatus.blocked:
              case BlockedUsersStatus.success:
                if (state.blockedUser.isEmpty) {
                  return Center(
                    child: const Text(
                      "settings.lbl_no_record_found",
                      style: TextStyle(color: blackColor, fontSize: 15),
                    ).tr(),
                  );
                } else {
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return index >= state.blockedUser.length
                          ? (state.blockedUser.length >= 10)
                              ? const BottomLoader()
                              : const SizedBox.shrink()
                          : BlockUserRow(
                              user: state.blockedUser[index],
                            );
                    },
                    itemCount: state.hasReachedMax
                        ? state.blockedUser.length
                        : state.blockedUser.length + 1,
                    controller: _scrollController,
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
