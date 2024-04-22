import '../../../config/data.dart';
import 'package:flutter/services.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import '../../../views/screens/result/result_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class RequestFilterScreen extends StatefulWidget {
 
  const RequestFilterScreen({Key? key}) : super(key: key);
  @override
  _RequestFilterScreenState createState() => _RequestFilterScreenState();
}

class _RequestFilterScreenState extends State<RequestFilterScreen> {
  FocusNode locationFocus = FocusNode();
  

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark
        .copyWith(statusBarIconBrightness: Brightness.dark));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: lightColor,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(clearIcon, color: primaryColor),
            onPressed: () => {
              Navigator.pop(context),
            },
          ),
          title: Text('filter.lbl_filter'.tr(),
              style: const TextStyle(color: blackColor)),
        ),
      
      );
  }


  
}
