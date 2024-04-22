import '../../../config/icons.dart';

import '../../../config/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class PickImageDialog extends StatefulWidget {
  final String? title;

  final double? pageTextSize;
  final double? pageSmallTextSize;
  final double? unitWidth;
  final double? unitHeight;
  final double? deviceHeight;

  const PickImageDialog(
      {super.key,
      this.title,
      this.pageTextSize,
      this.pageSmallTextSize,
      this.unitWidth,
      this.unitHeight,
      this.deviceHeight})
      : assert(title != null);

  @override
  _PickImageDialogState createState() => _PickImageDialogState();
}

class _PickImageDialogState extends State<PickImageDialog> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        padding: const EdgeInsets.all(10),
        height: 140,
        width: 100,
        //  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        /*  margin: EdgeInsets.only(
          top: (widget.deviceHeight - widget.unitWidth * 220),
        ), */
        /* padding: EdgeInsets.only(
          top: widget.unitHeight * 5,
          left: widget.unitWidth * 10,
        ), */
        //color: lightColor,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 10),
            Container(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.title!,
                  style: TextStyle(
                    color: greyColor,
                    fontSize: widget.pageSmallTextSize,
                  ),
                )),
            const SizedBox(height: 10),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              leading: const Icon(galleryIcon),
              title: RichText(
                text: TextSpan(
                    text: 'addproperty.lbl_action_from_gallery'.tr(),
                    style: TextStyle(
                      color: darkColor,
                      fontSize: widget.pageTextSize,
                    )),
              ),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            /* ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Icon(Icons.camera_alt),
              title: Text(
                'addproperty.lbl_action_from_camera',
                style: TextStyle(
                  color: darkColor,
                  fontSize: widget.pageTextSize,
                ),
              ).tr(),
              onTap: () {
                Navigator.pop(context, 'camera');
              },
            ),  */
            /* ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: Icon(Icons.close),
              title: Text(
                'addproperty.lbl_action_cancel',
                style: TextStyle(
                  color: darkColor,
                  fontSize: widget.pageTextSize,
                ),
              ).tr(),
              onTap: () => Navigator.pop(context),
            ), */
          ],
        ),
      ),
    );
  }
}
