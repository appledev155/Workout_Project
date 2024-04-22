import 'dart:convert';
import 'dart:io';
import 'package:anytimeworkout/module/chat/model/chat_model.dart';
import 'package:anytimeworkout/views/components/center_loader.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/views/components/forms/confirmation_dialog.dart';
import 'package:anytimeworkout/views/components/forms/input_field.dart';
import 'package:anytimeworkout/views/components/forms/input_field_prefix.dart';
import 'package:anytimeworkout/views/components/forms/round_icon_button.dart';
import 'package:anytimeworkout/views/components/forms/text_icon_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

import 'package:fluttertoast/fluttertoast.dart';

import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../../module/chat/bloc/chat/chat_bloc.dart';
import '../../module/chat/bloc/upload_progress_bloc/upload_progress_bloc.dart';

class AddPrivatePropertyScreen extends StatefulWidget {
  ChatChannel? chatChannel;
  AddPrivatePropertyScreen({super.key, this.chatChannel});

  @override
  State<AddPrivatePropertyScreen> createState() =>
      _AddPrivatePropertyScreenState();
}

class _AddPrivatePropertyScreenState extends State<AddPrivatePropertyScreen> {
  ScrollController scrollController = ScrollController();

  FocusNode titleNode = FocusNode();

  FocusNode descNode = FocusNode();

  FocusNode priceNode = FocusNode();

  TextEditingController propertyTitleController = TextEditingController();

  TextEditingController propertyDescriptionController = TextEditingController();

  TextEditingController propertyPriceController = TextEditingController();

  String propertyTitleFieldError = '';

  String propertyDescriptionFieldError = '';

  String propertyPriceFieldError = '';

  bool? adminApproved = false;

  List<dynamic> propertyImages = <dynamic>[];
  List<File> propertyImagesFile = <File>[];

  List propertyEditImages = [];

  bool enableSubmit = true;

  late bool isGalleryOpen = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<MessageContent> selectedPropertyList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final mediaProgressBloc = BlocProvider.of<UploadProgressBloc>(context);
    final chatBloc = BlocProvider.of<ChatBloc>(context);

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: lightColor,
        appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            backgroundColor: lightColor,
            elevation: 1,
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
            iconTheme: const IconThemeData(color: blackColor),
            title: const Text('chat_section.lbl_addproperty',
                    style: TextStyle(color: blackColor))
                .tr()),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.only(top: 10, left: 7, right: 7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSpace(),
                  _buildPropertyTitleEditView(),
                  _buildSpace(),
                  _buildPropertyDescEditView(),
                  _buildPropertyPriceEditView(),
                  _buildSpace(),
                  _buildPickPropertyImagesButton(context),
                  _buildSpace(),
                  _buildPickedPropertyImagesPreview(context),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: SafeArea(
            minimum: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 40 * unitWidth,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    if (propertyImages.isNotEmpty) {
                      ChatChannel currentChannel = widget.chatChannel!;
                      String uniqueTimeStamp = app_instance.utility
                          .getUnixTimeStampInPubNubPrecision();
                      String uniqueId =
                          '${currentChannel.chatUser.userId}-${currentChannel.channelId}-$uniqueTimeStamp';

                      List<dynamic> propertyImagesList = propertyImages;
                      print(propertyImagesList.length);

                      Map<String, dynamic> propertyDetails = {
                        "propertyTitle": propertyTitleController.text,
                        "propertyDescription":
                            propertyDescriptionController.text,
                        "price": propertyPriceController.text,
                      };
                      List<dynamic> fileList = await app_instance.utility
                          .getFileList(propertyImagesList);
                      Map<String, dynamic> otherData = {
                        "upload_from": "chat",
                        "cardType": "privateProperty",
                        "data": jsonEncode({
                          "currentChannel": jsonEncode(currentChannel),
                          'propertyDetails': jsonEncode(propertyDetails)
                        }),
                        "timetoken": uniqueTimeStamp,
                        "upload_path":
                            'chat-media/channels/${currentChannel.channelId.toString()}/${currentChannel.chatUser.userId}/',
                      };

                      UploadBox uploadBox = UploadBox(
                        uniqueId: uniqueId,
                        uploadBoxStatus: UploadBoxStatus.start,
                        uploadFiles: await app_instance.utility
                            .getFileList(propertyImagesList),
                        otherData: jsonEncode(otherData),
                        progressValue: '0.0',
                      );

                      // widget.chatChannel,
                      if (fileList.isNotEmpty) {
                        mediaProgressBloc.add(MediaPicked(
                          uploadBox: uploadBox,
                          chatUser: widget.chatChannel!.chatUser,
                        ));
                      }

                      // For Message to display in chat
                      if (fileList.isNotEmpty) {
                        MessageContent selectedProperty = MessageContent(
                          cardType: "privatePropertyPlaceholder",
                          timeStamp: app_instance.utility
                              .getUnixTimeStampInPubNubPrecision(),
                          data: jsonEncode({
                            "propertyTitle": propertyTitleController.text,
                            "propertyDescription":
                                propertyDescriptionController.text,
                            "price": propertyPriceController.text,
                            "uniqueId": uniqueId,
                            "uploadFiles": jsonEncode(await app_instance.utility
                                .getFileList(propertyImages)),
                            "mediaForChannel":
                                // Kept some item empty just to save message size.
                                ChatChannel(
                              channelName: currentChannel.channelName,
                              channelId: currentChannel.channelId,
                              chatToUser: [],
                              chatUser: ChatUser.empty,
                              lastMessageRow: MessageRow.empty,
                              lastMessageTime: '',
                              unreadMessageCount: '',
                            ).toString(),
                            "timetoken": uniqueTimeStamp,
                          }),
                        );

                        chatBloc.add(ChatMessageSent(
                            selectedProperty, currentChannel,
                            storeInDB: false, messageId: uniqueId));
                      }

                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/chatScreen'));
                    } else {
                      addPrivateProperty(widget.chatChannel);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                    backgroundColor: (enableSubmit) ? primaryDark : greyColor),
                child: const Text('chat_section.lbl_addproperty').tr(),
              ),
            )),
      ),
    );
  }

  Widget _buildPropertyTitleEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      // ignore: missing_required_param
      child: InputField(
        focusNode: titleNode,
        height: unitWidth * 15,
        validator: (value) {
          return (value!.isEmpty) ? "chat_section.lbl_titleName".tr() : null;
        },
        width: double.infinity,
        controller: propertyTitleController,
        borderColor: (propertyTitleFieldError == '')
            ? (adminApproved!)
                ? greyColor.withOpacity(0.6)
                : darkColor
            : favoriteColor,
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: (adminApproved!) ? greyColor.withOpacity(0.6) : blackColor,
        hint: 'chat_section.lbl_property_title'.tr(),
        hintColor: darkColor.withOpacity(0.8),
        hintSize: pageIconSize,
        label: '',
        labelColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
        labelSize: pageTextSize,
        readOnly: (adminApproved!) ? true : false,
        inputFormatters: [
          FilteringTextInputFormatter.deny(RegExp('[#_/=@,*;:]')),
        ],
      ),
    );
  }

  Widget _buildPropertyDescEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      // ignore: missing_required_param
      child: InputField(
        focusNode: descNode,
        height: unitWidth * 15,
        width: double.infinity,
        validator: (value) {
          return (value!.isEmpty) ? "chat_section.lbl_description".tr() : null;
        },
        keyboardType: TextInputType.multiline,
        controller: propertyDescriptionController,
        borderColor: (propertyDescriptionFieldError == '')
            ? (adminApproved!)
                ? greyColor.withOpacity(0.6)
                : darkColor
            : favoriteColor,
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: (adminApproved!) ? greyColor.withOpacity(0.6) : blackColor,
        hint: 'chat_section.lbl_property_description'.tr(),
        hintColor: darkColor.withOpacity(0.8),
        hintSize: pageIconSize,
        label: '',
        labelColor: (adminApproved!) ? greyColor.withOpacity(0.6) : darkColor,
        labelSize: pageTextSize,
        maxLines: null,
        textInputAction: TextInputAction.newline,
        readOnly: (adminApproved!) ? true : false,
      ),
    );
  }

  Widget _buildPropertyPriceEditView() {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: InputFieldPrefix(
        focusNode: priceNode,
        height: unitWidth * 15,
        width: double.infinity,
        controller: propertyPriceController,
        borderColor:
            (propertyPriceFieldError == '') ? darkColor : favoriteColor,
        radius: unitWidth * 5,
        fontSize: pageIconSize,
        fontColor: blackColor,
        validator: (value) {
          return (value!.isEmpty) ? "chat_section.lbl_enterprice".tr() : null;
        },
        hint: 'chat_section.lbl_price'.tr(),
        hintColor: darkColor.withOpacity(0.8),
        hintSize: pageIconSize,
        label: '',
        labelColor: darkColor,
        labelSize: pageTextSize,
        prefixIcon: priceIcon,
        prefixIconSize: pageSmallIconSize,
        prefixIconColor: greyColor,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp('[\u0660-\u06690-9]'))
        ],
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.done,
        suffixText: 'currency.AED'.tr(),
      ),
    );
  }

  Widget _buildPickPropertyImagesButton(BuildContext context) {
    return ((propertyImages.length + propertyEditImages.length) > 7)
        ? const SizedBox.shrink()
        : Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: TextIconButton(
              title: 'chat_section.btn_pick_images'.tr(),
              iconData: plusIcon,
              titleSize: pageTextSize,
              iconSize: pageIconSize,
              titleColor: primaryDark,
              iconColor: primaryDark,
              buttonColor: lightColor,
              borderColor: primaryDark,
              radius: unitWidth * 5,
              itemSpace: unitWidth * 4,
              onPressed: () {
                FocusScope.of(context).unfocus();
                _onPickPropertyImage(context);
              },
            ),
          );
  }

  _onPickPropertyImage(context) async {
    try {
      propertyImages.clear();

      /*  final List<AssetEntity>? selectedImages =
          await AssetPicker.pickAssets(context,
              pickerConfig: AssetPickerConfig(
                maxAssets: 8 - propertyImages.length,
                requestType: RequestType.image,
              )); */
      List<dynamic>? selectedImages = [];

      if (Platform.isAndroid) {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'HEIC'],
          allowMultiple: true,
        );

        if (result != null) {
          selectedImages = result.paths.map((path) => File(path!)).toList();
        }
      } else {
        selectedImages = await AssetPicker.pickAssets(context,
            pickerConfig: AssetPickerConfig(
              maxAssets: 8 - propertyImages.length,
              requestType: RequestType.all,
            ));
      }
      if (selectedImages != null) {
        propertyImages.addAll(selectedImages);

        setState(() {});
      }
    } catch (e, _) {
      setState(() {});
      print(e);
      print(_);
      print("Exception");
    }
  }

  _buildSpace() {
    return SizedBox(height: unitWidth * 15);
  }

  Widget _buildPickedPropertyImagesPreview(BuildContext context) {
    return Container(
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: Wrap(
        children: propertyImages.map((propertyImage) {
          return SizedBox(
            width: unitWidth * 120,
            height: unitWidth * 120,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: (Platform.isAndroid)
                      ? Image.file(
                          File(propertyImage.path),
                          width: int.parse((unitWidth * 110).toStringAsFixed(0))
                              .toDouble(),
                          height:
                              int.parse((unitWidth * 110).toStringAsFixed(0))
                                  .toDouble(),
                        )
                      : Image(
                          image: AssetEntityImageProvider(propertyImage,
                              isOriginal: false),
                          width: int.parse((unitWidth * 110).toStringAsFixed(0))
                              .toDouble(),
                          height:
                              int.parse((unitWidth * 110).toStringAsFixed(0))
                                  .toDouble(),
                        ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: RoundIconButton(
                    radius: 30,
                    color: lightColor,
                    iconData: clearIcon,
                    iconSize: pageSmallIconSize,
                    iconColor: favoriteColor,
                    width: unitWidth * 22,
                    height: unitWidth * 22,
                    onTap: () async {
                      var response = await showDialog(
                        context: context,
                        builder: (context) {
                          return ConfirmationDialog(
                            width: unitWidth * 260,
                            height: unitWidth * 140,
                            pageTextSize: pageTextSize,
                            pageTitleSize: pageTitleSize,
                            unitWidth: unitWidth,
                            title: 'ANYTIME WORKOUT',
                            bodyText:
                                'chat_section.lbl_are_you_sure_remove_image'
                                    .tr(),
                          );
                        },
                      );
                      if (response != null) {
                        (Platform.isAndroid)
                            ? propertyImages.remove(File(propertyImage.path))
                            : propertyImages.remove(File(propertyImage));
                        if (response != null) {
                          if (!mounted) return;
                          setState(() {
                            propertyImages.remove(propertyImage);
                          });
                          checkImageCount(
                              propertyImages.length + propertyImages.length);
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  checkImageCount(length) {
    if (length < 9) {
      isGalleryOpen = false;
    } else {
      Fluttertoast.showToast(
          backgroundColor: blackColor,
          msg: "chat_section.lbl_image_required".tr(),
          toastLength: Toast.LENGTH_LONG);
      isGalleryOpen = true;
    }
  }

  addPrivateProperty(ChatChannel? chatChannel) {
    Map<String, dynamic> propertyDetails = {
      "propertyTitle": propertyTitleController.text,
      "propertyDescription": propertyDescriptionController.text,
      "price": propertyPriceController.text,
      "propertyImage": ''
    };

    selectedPropertyList.add(MessageContent(
      cardType: "privateProperty",
      timeStamp: app_instance.utility.getUnixTimeStampInPubNubPrecision(),
      data: jsonEncode(propertyDetails),
    ));

    for (int i = 0; i < selectedPropertyList.length; i++) {
      context.read<ChatBloc>().add(ChatMessageUpdated('Shared $i'));

      MessageContent selectedProperty = selectedPropertyList[i];

      context
          .read<ChatBloc>()
          .add(ChatMessageSent(selectedProperty, chatChannel!));
    }
    CenterLoader.hide(context);
    selectedPropertyList.clear();
    Navigator.of(context).popUntil(ModalRoute.withName('/chatScreen'));
  }
}
