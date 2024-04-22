import 'package:anytimeworkout/config/styles.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../../config/app_colors.dart';
import '../../../config/icons.dart';
import '../../../views/components/forms/location_auto_search.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LocationAutoComplete extends StatefulWidget {
  const LocationAutoComplete(
      {Key? key,
      this.locationIDArea,
      this.location,
      this.width,
      this.height,
      this.focusNode,
      this.onlyCity,
      this.selectedLocation,
      this.params,
      this.locationId,
      this.setLoc,
      required this.notifyParent(
          locID, locTxt, algoliaLocationId, locationEnglish)})
      : super(key: key);
  final double? width;
  final String? locationIDArea;
  final String? location;
  final double? height;
  final FocusNode? focusNode;
  final bool? onlyCity;
  final Function? selectedLocation;
  final dynamic params;
  final String? locationId;
  final Function? setLoc;

  @override
  LocationAutoCompleteState createState() => LocationAutoCompleteState();

  final Function(String? locID, String? locTxt, String? algoliaLocationId,
      String? locationEnglish) notifyParent;
}

class LocationAutoCompleteState extends State<LocationAutoComplete> {
  TypeAheadFormField? searchTextField;

  TextEditingController pdcontroller = TextEditingController();
  dynamic listLoc = '';
  String? locationIDArea = '';
  String? location = '';
  String? locationEnglish = '';
  bool? _isEmpty = false;
  bool? onlyCity;

  LocationAutoCompleteState() {
    listLoc = PlayersViewModel.players;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      locationIDArea = widget.locationIDArea!;
      pdcontroller.text = widget.location!;

      if (widget.location != '' && widget.location != null) {
        setState(() {
          _isEmpty = true;
        });
      }
    });
    searchTextField = TypeAheadFormField<Players>(
      getImmediateSuggestions: true,
      hideOnEmpty: true,
      keepSuggestionsOnLoading: false,
      textFieldConfiguration: TextFieldConfiguration(
          style: TextStyle(fontSize: pageTextSize),
          onChanged: (value) {
            if (value != '' &&
                pdcontroller.text.isNotEmpty &&
                pdcontroller.text != '') {
              setState(() {
                _isEmpty = true;
              });
            } else {
              setState(() {
                _isEmpty = false;
              });
            }
          },
          controller: pdcontroller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 10,
                vertical: unitWidth * 15,
              ),
              hintText: 'filter.lbl_type_select_location'.tr(),
              hintStyle: TextStyle(color: greyColor.withOpacity(0.6)),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5)))),
      suggestionsCallback: (pattern) async {
        String lang = context.locale.toString();
        if (pattern.isNotEmpty) {
          return await PlayersViewModel.loadPlayers(
            pattern,
            lang,
            widget.params['MIX_INDEX_NAME_DEV_LOCATION'],
            widget.params['MIX_INDEX_NAME_DEV_LOCATION_AR'],
            widget.params['MIX_ALGOLIA_SEARCH'],
            widget.params['MIX_ALGOLIA_REST_API'],
            widget.notifyParent,
            widget.locationId,
            onlyCity: widget.onlyCity!,
          );
        } else
          return [];
      },
      itemBuilder: (context, item) {
        return ListTile(
          leading: const Icon(locationIcon),
          title: Text(
            item.autocompleteterm!,
            style: const TextStyle(fontSize: 16.0),
          ),
        );
      },
      suggestionsBoxDecoration:
          SuggestionsBoxDecoration(borderRadius: BorderRadius.circular(5)),
      transitionBuilder: (context, suggestionsBox, controller) {
        return FadeTransition(
          child: suggestionsBox,
          opacity:
              CurvedAnimation(parent: controller!, curve: Curves.fastOutSlowIn),
        );
      },
      onSuggestionSelected: (item) {
        _isEmpty = false;
        setState(() {
          locationIDArea = item.id.toString();
          location = item.autocompleteterm;
          locationEnglish = item.autocompleteEnglish;
        });
        this.pdcontroller.clear();
        widget.notifyParent(locationIDArea!, location!,
            item.parentId.toString(), locationEnglish);
        widget.setLoc!(item.parentId.toString());
        widget.selectedLocation!(location, locationEnglish);
      },
    );
  }

  void resetState() async {
    locationIDArea = '';
    pdcontroller.text = '';
    this.pdcontroller.text = '';
    widget.notifyParent(locationIDArea!, '', '0', '');
    widget.selectedLocation!('', '');
    setState(() {
      _isEmpty = false;
    });
  }

  void resetTextField() {
    this.pdcontroller.clear();
    setState(() {
      _isEmpty = false;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        alignment: AlignmentDirectional.centerEnd, // right & center
        children: <Widget>[
          Container(color: lightColor, child: searchTextField),
          Positioned(
            child: (_isEmpty!)
                ? IconButton(
                    icon: const Icon(clearIcon, color: primaryDark),
                    onPressed: () {
                      resetTextField();
                      _isEmpty = false;
                      setState(() {});
                    },
                  )
                : const Icon(
                    addCircleIcon,
                    color: transparentColor,
                  ),
          ),
        ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
