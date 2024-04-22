import 'package:anytimeworkout/config/data.dart';

import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../config/styles.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../chat/bloc/channel/channel_bloc.dart';
import '../bloc/my_request/my_request_bloc.dart';
import '../model/request_model.dart';

class RequestRow extends StatefulWidget {
  final RequestModel? item;

  const RequestRow({
    super.key,
    required this.item,
  });

  @override
  State<RequestRow> createState() => _RequestRowState();
}

class _RequestRowState extends State<RequestRow> {
  Future<void> showActivateDeactivateDialog(BuildContext context,
      RequestModel item, dynamic myRequestBlocRead) async {
    await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "request.lbl_delete_confirmation".tr(),
              style: const TextStyle(color: blackColor),
            ),
            actions: [
              ElevatedButton(
                onPressed: () async {
                  context
                      .read<ChannelBloc>()
                      .add(const NewRequestCreated(selfNewRequest: true));
                  // delete channel by request id when we delete request
                  context.read<ChannelBloc>().add(DeleteChannelsByRequestId(
                      requestId: widget.item!.id.toString()));

                  myRequestBlocRead.add(RequestDelete(requestDetails: item));

                  Fluttertoast.showToast(
                      msg: "request.lbl_request_deleted_successfully".tr(),
                      toastLength: Toast.LENGTH_SHORT,
                      timeInSecForIosWeb: 5,
                      backgroundColor: blackColor);

                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: primaryDark),
                child: const Text("request.lbl_delete").tr(),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                    backgroundColor: lightColor,
                    side: const BorderSide(color: primaryDark, width: 1)),
                child: const Text(
                  "request.lbl_cancel",
                  style: TextStyle(color: primaryDark),
                ).tr(),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    dynamic myRequestBlocRead = context.read<MyRequestBloc>();
    String requestNo = "request.lbl_request_no".tr();
    String location = '_';
    for (var i in selectOneCity) {
      if (i.last.toString() == widget.item!.location.toString()) {
        location = i[1].toString().tr();
      }
    }
    return Container(
        margin: const EdgeInsets.fromLTRB(1.5, 4, 1.5, 4),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: greyColor.withOpacity(0.4),
              blurRadius: 1.0,
              spreadRadius: 0.7,
              offset: const Offset(0, 0.1))
        ], color: lightColor, borderRadius: BorderRadius.circular(5)),
        child: Stack(children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                          child: Text(
                        (context.locale.toString() == 'ar_AR')
                            ? (widget.item!.descriptionAr != null)
                                ? widget.item!.descriptionAr!
                                : widget.item!.descriptionEn!
                            : (widget.item!.descriptionEn != null)
                                ? widget.item!.descriptionEn!
                                : widget.item!.descriptionAr!,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: pageIconSize),
                      )),
                    ],
                  ),
                  if (widget.item!.agencyNameEn != null &&
                          widget.item!.agencyNameEn!.isNotEmpty ||
                      widget.item!.agencyNameAr != null &&
                          widget.item!.agencyNameAr!.isNotEmpty) ...[
                    Text(
                        (context.locale.toString() == 'ar_AR')
                            ? (widget.item!.agencyNameAr != null &&
                                    widget.item!.agencyNameAr!.isNotEmpty)
                                ? widget.item!.agencyNameAr!
                                : widget.item!.agencyNameEn!
                            : (widget.item!.agencyNameEn != null &&
                                    widget.item!.agencyNameEn!.isNotEmpty)
                                ? widget.item!.agencyNameEn!
                                : widget.item!.agencyNameAr!,
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: pageIconSize))
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'request.lbl_city'.tr(),
                            style: TextStyle(
                                fontFamily: 'DM Sans',
                                fontSize: pageTextSize,
                                color: blackColor)),
                        const TextSpan(
                            text: ':', style: TextStyle(color: greyColor)),
                        TextSpan(
                            text: location.toString(),
                            style: TextStyle(
                              fontSize: pageTextSize,
                              color: blackColor,
                              fontFamily: 'DM Sans',
                            )),
                      ])),
                      const Spacer(),
                      (widget.item!.status == 1 || widget.item!.status == 2)
                          ? const Text(
                              "request.lbl_active",
                              style: TextStyle(
                                  color: activeColor,
                                  fontWeight: FontWeight.w700),
                            ).tr()
                          : const Text(
                              "request.lbl_not_active",
                              style: TextStyle(
                                  color: redColor, fontWeight: FontWeight.w700),
                            ).tr()
                    ],
                  ),
                  Row(
                    children: [
                      if (widget.item!.budget != '' &&
                          widget.item!.budget != null)
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: 'request.lbl_budget'.tr(),
                              style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: pageTextSize,
                                  color: blackColor)),
                          const TextSpan(
                              text: ':', style: TextStyle(color: greyColor)),
                          TextSpan(
                              text: '${widget.item!.budget}' +
                                  ' ' +
                                  'currency.AED'.tr(),
                              style: TextStyle(
                                  fontFamily: 'DM Sans',
                                  fontSize: pageTextSize,
                                  color: blackColor))
                        ])),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          trashIcon,
                          size: 28,
                          color: redColor,
                        ),
                        constraints: const BoxConstraints(maxWidth: 35),
                        onPressed: () {
                          if (widget.item!.status == 1 ||
                              widget.item!.status == 2) {
                            showActivateDeactivateDialog(
                                context, widget.item!, myRequestBlocRead);
                          } else {
                            context.read<ChannelBloc>().add(
                                DeleteChannelsByRequestId(
                                    requestId: widget.item!.id.toString()));
                            myRequestBlocRead.add(
                                RequestDelete(requestDetails: widget.item!));
                          }
                        },
                      ),
                      (context.locale.toString() == "en_US")
                          ? const SizedBox(width: 10)
                          : const SizedBox(width: 0),
                    ],
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                '$requestNo : ',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('${widget.item!.id}'),
                            ],
                          ),
                          Text('${widget.item!.friendlyName}')
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                ],
              )),
        ]));
  }
}
