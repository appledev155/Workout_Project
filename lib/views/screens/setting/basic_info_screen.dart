import 'dart:io';
import 'package:anytimeworkout/bloc/current_user_bloc/current_user_bloc.dart';
import 'package:anytimeworkout/model/user_model.dart';
import 'package:anytimeworkout/module/chat/bloc/channel/channel_bloc.dart';
import 'package:anytimeworkout/module/chat/config/chat_config.dart';
import 'package:anytimeworkout/views/components/forms/custom_text_button.dart';
import 'package:anytimeworkout/views/components/root_redirect.dart';
import 'package:anytimeworkout/views/screens/profile_detail/profile_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../../bloc/agent_detail/agent_detail_bloc.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../bloc/setting/basic_info_form_bloc.dart';
import '../../../main.dart';
import '../../../views/components/center_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:convert';
import 'package:anytimeworkout/config.dart' as app_instance;

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({Key? key}) : super(key: key);
  @override
  _BasicInfoScreenState createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  bool isEmailVerified = false;
  bool showEmailLink = true;
  File? image;
  List<dynamic>? images = [];
  BasicInfoFormBloc? basicInfoFormBloc;
  final String gifPath = dotenv.env['GifPath'].toString();
  String? userId = "";

  bool? _isEmailVerified;
  void initState() {
    super.initState();
    _getEmailVerified();
    basicInfoFormBloc = BlocProvider.of<BasicInfoFormBloc>(context);
  }

  void _getEmailVerified() async {
    final result = await app_instance.storage.read(key: 'JWTUser');
    dynamic rec = json.decode(result.toString());

    isEmailVerified = (rec!['emailVerified'].toString() == '1') ? true : false;
    setState(() {
      _isEmailVerified = isEmailVerified;
    });

    await FirebaseAnalytics.instance
        .setCurrentScreen(screenName: 'settings.lbl_basic_information'.tr());

    return rec;
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: lightColor,
          appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: const SystemUiOverlayStyle(
                systemNavigationBarColor: lightColor,
                systemNavigationBarIconBrightness: Brightness.dark,
                statusBarColor: primaryColor,
                statusBarIconBrightness: Brightness.dark),
            iconTheme: const IconThemeData(color: blackColor),
            elevation: 1,
            title: const Text(
              'settings.lbl_basic_information',
              style: TextStyle(color: blackColor),
            ).tr(),
            backgroundColor: primaryColor,
            leading: ModalRoute.of(context)?.canPop == true
                ? IconButton(
                    icon: Icon(
                      (context.locale.toString() == "en_US")
                          ? (Platform.isIOS)
                              ? iosBackButton
                              : backArrow
                          : iosForwardButton,
                      color: blackColor,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : null,
          ),
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: pageHPadding * 3),
            child: FormBlocListener<BasicInfoFormBloc, String, String>(
              onSubmitting: (context, state) async {
                CenterLoader.show(context);
                UserModel currentUser = await app_instance.utility.jwtUser();
                userId = currentUser.id.toString();
                setState(() {});
              },
              onSuccess: (context, state) async {
                if (state.successResponse != '') {
                  emitSignal();
                  BasicInfoFormBloc().getProfile();

                  if (!mounted) return;
                  CenterLoader.hide(context);
                  RootRedirect.successMsg(
                      context, tr(state.successResponse!), '');
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<AgentDetailBloc>(
                      create: (context) => AgentDetailBloc()
                        ..add(AgentDetailFetched(userId: params[0])),
                      child: const ProfileDetailScreen(),
                    ),
                  );
                  if (state.successResponse ==
                      'settings.verification_email_send_successfully') {
                    setState(() {
                      this.showEmailLink = false;
                    });
                  }
                }
                Navigator.pushNamed(context, "/setting");
              },
              onFailure: (context, state) {
                CenterLoader.hide(context);
                Fluttertoast.showToast(
                    msg: state.failureResponse!,
                    toastLength: Toast.LENGTH_LONG,
                    timeInSecForIosWeb: 5);
              },
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20 * unitHeight,
                    ),
                    GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child:
                            Stack(alignment: Alignment.bottomCenter, children: [
                          if (image == null &&
                              basicInfoFormBloc!.imageUrl.value != "")
                            CachedNetworkImage(
                              imageUrl: basicInfoFormBloc!.imageUrl.value,
                              height: 100 * unitWidth,
                              width: 100 * unitWidth,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Image.network(
                                '$gifPath/assets/static/giphy.gif',
                                height: 100 * unitWidth,
                                width: 100 * unitWidth,
                              ),
                              errorWidget: (context, url, error) {
                                return const CircleAvatar(
                                  backgroundColor: lightColor,
                                  backgroundImage:
                                      AssetImage("assets/icon/giphy.gif"),
                                );
                              },
                            )
                          else if (images!.isNotEmpty)
                            ...[
                              if (Platform.isAndroid) ...[
                                ...images!.map((e) => Image.file(
                                      File(e.path),
                                      fit: BoxFit.cover,
                                      height: 100 * unitWidth,
                                      width: 100 * unitWidth,
                                    ))
                              ] else ...[
                                ...images!.map((e) => Image(
                                      image: AssetEntityImageProvider(e,
                                          isOriginal: false),
                                      fit: BoxFit.cover,
                                      height: 100 * unitWidth,
                                      width: 100 * unitWidth,
                                    ))
                              ]
                            ].toList()
                          else
                            Image.asset(
                              'assets/icon/user.png',
                              fit: BoxFit.fill,
                              height: 100 * unitWidth,
                              width: 100 * unitWidth,
                              errorBuilder: (context, error, stackTrace) {
                                return CachedNetworkImage(
                                    fit: BoxFit.fill,
                                    height: 100 * unitWidth,
                                    width: 100 * unitWidth,
                                    imageUrl:
                                        "https://i.uaeaqar.com/assets/images/user.png");
                              },
                            ),
                          Positioned.fill(
                              top: 75 * unitHeight,
                              child: Container(
                                alignment: Alignment.center,
                                color: blackColor.withOpacity(0.4),
                                child: Icon(
                                  editProfileIcon,
                                  size: pageIconSize,
                                  color: lightColor,
                                ),
                              ))
                        ]),
                      ),
                      onTap: () async {
                        UserModel currentUser =
                            await app_instance.utility.jwtUser();
                        userId = currentUser.id.toString();
                        setState(() {});
                        selectProfilePicture();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('register.lbl_name'.tr())),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: basicInfoFormBloc!.name,
                      keyboardType: TextInputType.text,
                      textStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(right: 20.0),
                        filled: true,
                        fillColor: greyColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        // labelText: 'register.lbl_name'.tr(),
                        prefixIcon: const Icon(
                          personIcon,
                          color: blackColorLight,
                        ),
                      ),
                    ),
                    //Email/////////
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 20),
                      child: Align(
                          alignment: Alignment.topLeft,
                          child: Text('register.lbl_email'.tr())),
                    ),
                    TextFieldBlocBuilder(
                      textFieldBloc: basicInfoFormBloc!.email,
                      keyboardType: TextInputType.text,
                      textStyle: const TextStyle(
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.only(right: 20.0),
                        filled: true,
                        fillColor: greyColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                        // labelText: 'register.lbl_name'.tr(),
                        prefixIcon: const Icon(
                          mailIcon,
                          color: blackColorLight,
                        ),
                      ),
                    ),

                    if (this.isEmailVerified)
                      Text('settings.verified',
                              style: TextStyle(
                                  fontSize: pageTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor))
                          .tr(),
                    if (!this.isEmailVerified)
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'settings.not_verified',
                              style: TextStyle(
                                  fontSize: pageTextSize,
                                  fontWeight: FontWeight.bold,
                                  color: favoriteColor),
                            ).tr(),
                            if (this.showEmailLink)
                              TextButton(
                                style: TextButton.styleFrom(
                                    textStyle:
                                        const TextStyle(color: primaryColor)),
                                onPressed: () {
                                  // CenterLoader.show(context);
                                  basicInfoFormBloc!.sendEmail();
                                },
                                child: Text(
                                        'settings.resend_verification_email',
                                        style: TextStyle(
                                            color: primaryColor,
                                            fontSize: pageTextSize))
                                    .tr(),
                              )
                          ]),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'settings.lbl_property_area_unit'.tr(),
                        ),
                      ),
                    ),

                    DropdownFieldBlocBuilder<String>(
                      selectFieldBloc: basicInfoFormBloc!.propertyAreaUnit,
                      decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(right: 20.0),
                          filled: true,
                          fillColor: greyColor,
                          prefixIcon: const Icon(areaSizeIcon),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              width: 0,
                              style: BorderStyle.none,
                            ),
                          )),
                      itemBuilder: (context, value) =>
                          FieldItem(child: Text((value.tr()))),
                      showEmptyItem: false,
                    ),
                    SizedBox(height: 20 * unitHeight),
                    _buildVerifiedButton(),
                  ],
                ),
              ),
            ),
          )),
    );
  }

  selectProfilePicture() async {
    if (Platform.isAndroid) {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        images = result.paths.map((path) => File(path!)).toList();
      }
    } else {
      images = await AssetPicker.pickAssets(context,
          pickerConfig: const AssetPickerConfig(
            maxAssets: 1,
            requestType: RequestType.image,
          ));
    }
    if (images != null && images!.isNotEmpty) {
      if (!mounted) return;
      CenterLoader.show(context);
      dynamic imagePath;
      if (Platform.isAndroid) {
        imagePath = await images![0];
      } else {
        imagePath = await images![0].file;
      }
      setState(() {
        image = imagePath;
      });
      basicInfoFormBloc!.uploadImageUrl.updateValue(image!.path);
      final result = await basicInfoFormBloc!.uploadProfile();
      if (result) {
        emitSignal();
        BasicInfoFormBloc().getProfile();
        if (!mounted) return;
        RootRedirect.successMsg(context, tr('settings.success_msg'), '');
        CenterLoader.hide(context);
      }
      setState(() {});
    }
  }

  // emit signal for profile update
  emitSignal() async {
    String channelName = (environment == "production")
        ? "members-public-production-group"
        : "members-public-staging-group";
    // update the chat image and profile name
    context.read<CurrentUserBloc>().add(const UpdateProfile());

    context.read<ChannelBloc>().add(
          UserSignalSent(
              signalType: signalType.indexOf('profileUpdate').toString(),
              currentChannel: channelName),
        );

    context.read<ChannelBloc>().add(
          UserSignalSent(
              signalType: signalType.indexOf('profileUpdate').toString(),
              currentChannel: 'my-channel-$userId'),
        );
  }

  Widget _buildVerifiedButton() {
    return SizedBox(
        width: deviceWidth/1.8,
        child: CustomTextButton(
          title: 'settings.lbl_update'.tr(),
          titleSize: pageIconSize,
          titleColor: lightColor,
          elevation: 1,
          buttonColor: primaryColor,
          borderColor: lightColor.withOpacity(0),
          onPressed: basicInfoFormBloc!.submit,
          radius: unitWidth * 4,
        ));
  }
}
