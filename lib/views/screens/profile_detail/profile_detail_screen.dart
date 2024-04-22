import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/bloc/agent_detail/agent_detail_bloc.dart';
import 'package:anytimeworkout/bloc/agent_property_bloc/agent_property_bloc.dart';
import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class ProfileDetailScreen extends StatefulWidget {
  final int? userId;
  final String? currentScreen;
  const ProfileDetailScreen({Key? key, this.userId, this.currentScreen})
      : super(key: key);

  @override
  _ProfileDetailScreenState createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  // final _key = GlobalKey<NestedScrollViewState>();
  final phoneNumberController = TextEditingController();
  final agentIdController = TextEditingController();
  final TextEditingController tempScrollFlagcontroller =
      TextEditingController();
  late String curPage = '0', propertyName, purpose;
  late int selectedIndex, propertyId;

  final ScrollController _scrollController = ScrollController();
  final String gifPath = dotenv.env['GifPath'].toString();

  @override
  void initState() {
    super.initState();
    tempScrollFlagcontroller.text = '0';
    logScreenEvent();
  }

  logScreenEvent() async {
    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'Agent Profile screen');
  }

  _launchWhatsapp(String phone, String msg) async {
    String url() {
      if (Platform.isIOS) {
        return "whatsapp://wa.me/$phone/?text=${Uri.parse(msg)}";
      } else {
        return "whatsapp://send?phone=$phone&text=${Uri.parse(msg)}";
      }
    }

    if (await canLaunch(url())) {
      await launch(url());
    } else {
      throw 'Could not launch ${url()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    const shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            iconTheme: const IconThemeData(color: blackColor),
            elevation: 1,
            title: Text(
              tr('settings.profile'),
              style: const TextStyle(color: blackColor),
            ),
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
            actions: [
              (widget.userId != 0)
                  ? Padding(
                      padding: const EdgeInsets.all(7),
                      child: CircleAvatar(
                        backgroundColor: lightColor,
                        child: IconButton(
                          icon: const Icon(
                            shareIcon,
                            color: blackColor,
                          ),
                          onPressed: () {
                            Share.share(
                                'https://${dotenv.env['WEBSITE_HOST']}/agent/profile/${agentIdController.text}',
                                sharePositionOrigin: Rect.fromLTWH(
                                    0, 0, size.width, size.height / 2));
                          },
                        ),
                      ))
                  : const SizedBox.shrink()
            ]),
        bottomNavigationBar: (context.read<UserInfo>().userInfo.id.toString() !=
                agentIdController.text)
            ? (phoneNumberController.text.isNotEmpty)
                ? SafeArea(
                    minimum:
                        const EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Container(
                                  height: 35 * unitWidth,
                                  width: deviceWidth,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryDark,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    onPressed: () => launch(
                                        "tel:${phoneNumberController.text}"),
                                    icon: Icon(contactUsIcon,
                                        color: lightColor, size: pageIconSize),
                                    label: Text(
                                      'propertyDetails.lbl_property_callnow',
                                      style: TextStyle(
                                          color: lightColor,
                                          fontSize: pageIconSize),
                                    ).tr(),
                                  ))),
                          const SizedBox(width: 5),
                          Expanded(
                              child: Container(
                                  height: 35 * unitWidth,
                                  width: deviceWidth,
                                  child: ElevatedButton.icon(
                                    onPressed: () => _launchWhatsapp(
                                        phoneNumberController.text, 'Hello'),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: lightColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          side: const BorderSide(
                                              color: primaryDark)),
                                    ),
                                    icon: Icon(
                                      wpIcon,
                                      color: primaryDark,
                                      size: pageIconSize,
                                    ),
                                    label: Text(
                                      'propertyDetails.lbl_property_WhatsApp',
                                      style: TextStyle(
                                          color: primaryDark,
                                          fontSize: pageIconSize),
                                    ).tr(),
                                  )))
                        ]))
                : null
            : null,
        body: (widget.userId == 0)
            ? Container(
                padding: EdgeInsets.only(
                  left: unitWidth * 5,
                  right: unitWidth * 5,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: unitWidth * 10,
                    ),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.asset(
                            'assets/icon/user.png',
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100,
                          ),
                        ),
                        SizedBox(
                          width: unitWidth * 10,
                        ),
                        Text(
                          "chat_section.lbl_inactive_user_name".tr(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        )
                      ],
                    ),
                    Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: 5 * unitWidth, vertical: 5 * unitWidth),
                        decoration: BoxDecoration(
                            color: lightColor,
                            borderRadius:
                                BorderRadius.circular(10 * unitWidth)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "chat_section.lbl_user_not_available".tr(),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    )
                  ],
                ))
            : Container(
                padding: EdgeInsets.only(
                  left: unitWidth * 5,
                  right: unitWidth * 5,
                ),
                child: BlocBuilder<AgentDetailBloc, AgentDetailState>(
                  builder: (context, state) {
                    if (state.agentDetailStatus == AgentDetailStatus.initial) {
                      return const Center(
                        child: CupertinoActivityIndicator(),
                      );
                    }

                    if (state.agentDetailStatus == AgentDetailStatus.failure) {
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
                                      .read<AgentDetailBloc>()
                                      .add(ResetAgentDetailState());
                                  context.read<AgentDetailBloc>().add(
                                      AgentDetailFetched(
                                          userId: widget.userId));
                                },
                              )
                            ]),
                      );
                    }

                    if (state.agentDetailStatus == AgentDetailStatus.success) {
                      phoneNumberController.text =
                          state.agentDetail!.agentPhoneNumber!;

                      if (agentIdController.text.isEmpty) {
                        Future.microtask(() {
                          agentIdController.text =
                              state.agentDetail!.id.toString();
                          // _scrollController =   _key.currentState!.innerController;
                          _scrollController.addListener(_onScroll);
                          setState(() {});
                        });
                      }

                      return Column(children: [
                        Container(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: unitWidth * 10,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: (state.agentDetail!
                                                    .profileImage !=
                                                '')
                                            ? CachedNetworkImage(
                                                imageUrl: state
                                                    .agentDetail!.profileImage!,
                                                height: 100,
                                                width: 100,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Image.network(
                                                  '$gifPath/assets/static/giphy.gif',
                                                  height: 100,
                                                  width: 100,
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(),
                                              )

                                            /*  FadeInImage(
                                                    placeholder: AssetImage(
                                                        'assets/icon/giphy.gif'),
                                                    image: NetworkImage(
                                                      state.agentDetail!
                                                          .profileImage!,
                                                    ),
                                                    fit: BoxFit.cover,
                                                    imageErrorBuilder: (context,
                                                        error, stackTrace) {
                                                      return Text("Agent Image");
                                                    },
                                                    height: 100,
                                                    width: 100,
                                                  ) */
                                            : Image.asset(
                                                'assets/icon/user.png',
                                                fit: BoxFit.cover,
                                                height: 100,
                                                width: 100,
                                              )),
                                    SizedBox(
                                      width: unitWidth * 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              state.agentDetail!.agentName!,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: pageTitleSize * 1.2,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            Text(
                                              (context.locale.toString() ==
                                                      'en_US')
                                                  ? state
                                                      .agentDetail!.agencyName!
                                                  : state.agentDetail!
                                                      .agencyNameAr!,
                                              style: TextStyle(
                                                  fontSize: pageTitleSize,
                                                  fontWeight: FontWeight.w300),
                                            )
                                          ]),
                                    )
                                  ]),
                              SizedBox(
                                height: 10 * unitHeight,
                              ),
                              if (widget.currentScreen != 'Details' &&
                                  context.read<UserInfo>().userInfo.id ==
                                      state.agentDetail!.id) ...[
                                profileButton(),
                                SizedBox(
                                  height: 10 * unitHeight,
                                ),
                              ]
                            ],
                          ),
                        ),
                        (state.agentDetail!.propList!.isNotEmpty)
                            ? Expanded(
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5 * unitWidth,
                                      vertical: 5 * unitWidth),
                                  decoration: BoxDecoration(
                                      color: lightColor,
                                      borderRadius: BorderRadius.circular(
                                          10 * unitWidth)),
                                  child: ListView.separated(
                                    separatorBuilder: (context, index) =>
                                        const Divider(),
                                    itemBuilder: (context, index) => ListTile(
                                      title: Text(
                                        '${tr('DATABASE_VAR.${state.agentDetail!.propList![index]['property_type_name']}')} ${state.agentDetail!.propList![index]['purpose'] == 'Sell' ? tr('filter.lbl_for_sale') : tr('filter.lbl_for_rent')}',
                                        style: TextStyle(
                                            fontSize: pageIconSize,
                                            color: blackColor),
                                      ),
                                      trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              '${state.agentDetail!.propList![index]['propertyCount']}',
                                              style: TextStyle(
                                                  color: greyColor,
                                                  fontSize: pageTitleSize,
                                                  fontWeight: FontWeight.w500),
                                              textAlign: TextAlign.center,
                                            ),
                                            SizedBox(
                                              width: 10 * unitWidth,
                                            ),
                                            Icon((context.locale.toString() ==
                                                    'en_US')
                                                ? iosForwardButton
                                                : iosBackButton)
                                          ]),
                                      onTap: () => Navigator.pushNamed(
                                          context, '/agent_property_screen',
                                          arguments: [
                                            state.agentDetail!.propList![index]
                                                ['purpose'],
                                            state.agentDetail!.propList![index]
                                                ['property_type_id'],
                                            state.agentDetail!.propList![index]
                                                ['property_type_name'],
                                            '${tr('DATABASE_VAR.${state.agentDetail!.propList![index]['property_type_name']}')} ${state.agentDetail!.propList![index]['purpose'] == 'Sell' ? tr('filter.lbl_for_sale') : tr('filter.lbl_for_rent')}',
                                            state.agentDetail!.id
                                          ]),
                                    ),
                                    itemCount:
                                        state.agentDetail!.propList!.length,
                                  ),
                                ),
                              )
                            : Container()
                      ]);
                    }
                    return Container();
                  },
                ),
              ),
      ),
    );
  }

  Widget profileButton() => Container(
      height: 35 * unitWidth,
      width: deviceWidth,
      child: ElevatedButton(
          child: Text(
            tr('tabs.lbl_settings'),
            style: TextStyle(fontSize: pageIconSize),
          ),
          onPressed: () => Navigator.pushNamed(context, '/setting')));

  void _onScroll() {
    if (_scrollController.position.extentAfter <
        _scrollController.position.maxScrollExtent / 2) {
      if (tempScrollFlagcontroller.text != this.curPage) {
        BlocProvider.of<AgentPropertyBloc>(context).add(AgentPropertyFetched(
            userId: int.parse(agentIdController.text),
            propertyType: this.propertyName,
            propertyTypeId: this.propertyId,
            buyRentType: this.purpose));
        setState(() {
          curPage = tempScrollFlagcontroller.text;
        });
      }
    }
  }
}

class UserInfo with ChangeNotifier {
  UserModel? userModel;

  UserModel get userInfo => userModel!;

  // To Do : to be remove this call
  void getUserInfo() async {
    final data = await app_instance.storage.read(key: 'JWTUser');
    if (data != null) {
      final user = jsonDecode(data);
      userModel = UserModel.recJson(user);
      notifyListeners();
    } else {
      userModel = const UserModel(
          id: 0,
          name: '',
          email: '',
          number: '',
          profileImage: '',
          emailVerified: 0,
          phoneVerified: 0);
    }
  }
}
