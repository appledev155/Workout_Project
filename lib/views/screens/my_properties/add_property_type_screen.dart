import 'dart:io';
import 'package:anytimeworkout/config/icons.dart';
import 'package:anytimeworkout/views/components/center_loader.dart';
import 'package:anytimeworkout/views/components/notify.dart';
import 'package:flutter/services.dart';
import '../../../bloc/my_properties/add/add_form_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/app_colors.dart';
import '../../../config/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'add_screen.dart';
import 'package:anytimeworkout/config.dart' as app_instance;

class AddPropertyTypeScreen extends StatefulWidget {
  final String? privateProperty;
  final String? channelName;
  AddPropertyTypeScreen({this.privateProperty, Key? key, this.channelName})
      : super(key: key);
  @override
  _AddPropertyTypeScreenState createState() => _AddPropertyTypeScreenState();
}

class _AddPropertyTypeScreenState extends State<AddPropertyTypeScreen> {
  bool? isLogin;
  String? _isPhoneValidate;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _checkLogin();
    });
  }

  Future<bool> _checkLogin() async {
    isLogin = await Notify().checkLogin();
    setState(() {});
    return isLogin!;
  }

  checkPhone() async {
    _isPhoneValidate =
        await app_instance.storage.read(key: 'phone_number_validate');
    if (_isPhoneValidate != 'true') {
      CenterLoader.show(context);
      bool isPhoneValidate = await Notify().lookup();
      await app_instance.storage.write(
          key: 'phone_number_validate', value: isPhoneValidate.toString());
      CenterLoader.hide(context);
      _isPhoneValidate = isPhoneValidate.toString();
    }
    setState(() {});
  }

  redirectPage(BuildContext context, String type, privateProperty) async {
    if (!isLogin!) {
      Navigator.pushNamed(context, '/login');
    } else if (isLogin!) {
      await checkPhone();
      if (_isPhoneValidate != 'false') {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider<AddFormBloc>(
              create: (context) => AddFormBloc(),
              child: AddScreen(
                  buyrentType: type,
                  privateProperty: privateProperty,
                  channelName: widget.channelName),
            ),
          ),
        );
      } else {
        if (!mounted) return;
        Navigator.pushNamed(context, '/add_new_number');
      }
    }
    setState(() {});
    return isLogin;
  }

  @override
  Widget build(BuildContext context) {
    bool shouldPop = true;
    return WillPopScope(
      onWillPop: () async {
        return shouldPop;
      },
      child: Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            centerTitle: true,
            systemOverlayStyle: SystemUiOverlayStyle.dark,
            elevation: 1,
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
            title: const Text('addproperty.lbl_addproperty',
                    style: TextStyle(color: blackColor))
                .tr(),
          ),
          body: Padding(
              padding: const EdgeInsets.only(left: 10, right: 10, top: 30),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'addproperty.lbl_free_listing',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: pageIconSize),
                          ).tr(),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildSaleButton(widget.privateProperty)
                        ],
                      )),
                  const SizedBox(height: 15),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'addproperty.lbl_free_listing',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: pageIconSize),
                          ).tr(),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildRentButton()
                        ],
                      )),
                  const SizedBox(height: 15),
                  Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: lightColor,
                          borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'addproperty.lbl_free_listing',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: pageIconSize),
                          ).tr(),
                          const SizedBox(
                            height: 15,
                          ),
                          _buildRequestButton()
                        ],
                      ))
                ],
              ))),
    );
  }

  Widget _buildSaleButton(String? privateProperty) {
    return Container(
      width: deviceWidth,
      height: 40 * unitWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: primaryDark),
        child: Text(
          'filter.lbl_for_sale',
          style: TextStyle(color: lightColor, fontSize: pageTextSize),
        ).tr(),
        onPressed: () => redirectPage(context, 'Sell', privateProperty),
      ),
    );
  }

  Widget _buildRentButton() {
    return Container(
      width: deviceWidth,
      height: 40 * unitWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: primaryDark),
        child: Text('filter.lbl_for_rent',
                style: TextStyle(color: lightColor, fontSize: pageTextSize))
            .tr(),
        onPressed: () => redirectPage(context, 'Rent', widget.privateProperty),
      ),
    );
  }

  Widget _buildRequestButton() {
    return Container(
      height: 40 * unitWidth,
      width: deviceWidth,
      padding: EdgeInsets.symmetric(horizontal: pageHPadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            backgroundColor: primaryDark),
        child: Text('request.lbl_title',
                style: TextStyle(color: lightColor, fontSize: pageTextSize))
            .tr(),
        onPressed: () => Navigator.pushNamed(
            context, (isLogin!) ? '/add_request' : '/login'),
      ),
    );
  }
}
