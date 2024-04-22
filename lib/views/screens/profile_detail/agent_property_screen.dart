import 'dart:io';
import 'package:anytimeworkout/bloc/agent_property_bloc/agent_property_bloc.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/views/components/property_row.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgentPropertyScreen extends StatefulWidget {
  final String? title;
  const AgentPropertyScreen({this.title});
  AgentPropertyScreenState createState() => AgentPropertyScreenState();
}

class AgentPropertyScreenState extends State<AgentPropertyScreen> {
  final _scrollController = ScrollController();
  String curPage = '0';

  final TextEditingController tempScrollFlagcontroller =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    tempScrollFlagcontroller.text = '0';
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: widget.title!.tr());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: blackColor),
        elevation: 1,
        title: Text(
          widget.title!,
          style: const TextStyle(color: blackColor),
        ).tr(),
        backgroundColor: lightColor,
        leading: ModalRoute.of(context)?.canPop == true
            ? IconButton(
                icon: Icon(
                  (context.locale.toString() == "en_US")
                      ? (Platform.isIOS)
                          ? iosBackButton
                          : backArrow
                      : (context.locale.toString() == "ar_AR")
                          ? (Platform.isIOS)
                              ? iosForwardButton
                              : forwardArrow
                          : iosForwardButton,
                  color: blackColor,
                ),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: unitWidth * 5),
        child: BlocBuilder<AgentPropertyBloc, AgentPropertyState>(
          builder: (context, state) {
            if (state.status == AgentPropertyStatus.initial) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }

            if (state.status == AgentPropertyStatus.failure) {
              return Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('list.lbl_no_results_found',
                              style: TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: pageTitleSize))
                          .tr(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            backgroundColor: primaryColor),
                        child: const Text(
                          'list.lbl_try_again',
                          style: TextStyle(color: lightColor),
                        ).tr(),
                        onPressed: () {
                          context
                              .read<AgentPropertyBloc>()
                              .add(AgentPropertyFetched());

                          context
                              .read<AgentPropertyBloc>()
                              .add(ResetAgentProperty());
                        },
                      )
                    ]),
              );
            }

            if (state.status == AgentPropertyStatus.success) {
              tempScrollFlagcontroller.text = state.page.toString();
              if (state.items.isEmpty) {
                return Center(
                  child: Text('list.lbl_no_results_found',
                          style: TextStyle(
                              color: primaryDark,
                              fontWeight: FontWeight.w500,
                              fontSize: pageTitleSize))
                      .tr(),
                );
              } else {
                return ListView.builder(
                  controller: _scrollController,
                  itemBuilder: (context, index) =>
                      PropertyRow(item: state.items[index]),
                  itemCount: state.items.length,
                );
              }
            }

            return Container();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter <
        _scrollController.position.maxScrollExtent / 2) {
      if (tempScrollFlagcontroller.text != this.curPage) {
        BlocProvider.of<AgentPropertyBloc>(context).add(AgentPropertyFetched());
        setState(() {
          curPage = tempScrollFlagcontroller.text;
        });
      }
    }
  }
}
