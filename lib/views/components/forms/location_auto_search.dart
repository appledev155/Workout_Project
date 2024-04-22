import 'package:anytimeworkout/config.dart' as app_instance;

class Players {
  String? keyword;
  int? id;
  String? autocompleteterm;
  int? parentId;
  String? autocompleteEnglish;

  Players({
    this.keyword,
    this.id,
    this.autocompleteterm,
    this.parentId,
    this.autocompleteEnglish,
  });

  factory Players.fromJson(Map<String, dynamic> parsedJson, String lang) {
    return Players(
        keyword: parsedJson['city_area'] ?? '',
        id: parsedJson['id'] ?? 0,
        autocompleteterm: (lang == 'en_US')
            ? parsedJson['city_area'] ?? ''
            : parsedJson.containsKey('city_area_ar')
                ? (parsedJson['city_area_ar'] != null)
                    ? parsedJson['city_area_ar'] ?? ""
                    : parsedJson['city_area'] ?? ''
                : (parsedJson['city_area'] != null)
                    ? parsedJson['city_area'] ?? ''
                    : parsedJson['city_area_ar'] ?? '',
        autocompleteEnglish: parsedJson['city_area'] ?? '',
        parentId: (parsedJson['parent_id'] != 0)
            ? parsedJson['parent_id']
            : parsedJson['id']);
  }
}

class PlayersViewModel {
  static List<Players>? players;

  static Future loadPlayers(
      String? query,
      String? lang,
      String? devLocation,
      String? devLocationAr,
      bool? isAloglia,
      dynamic loc,
      Function? notifyParent,
      String? locationId,
      {bool? onlyCity = false}) async {
    try {
      players = <Players>[];

      if (query != '' && query != null) {
        Map<String, Object> jsonData = {
          'lang': (lang!.isNotEmpty)
              ? (lang.toString() == 'en_US')
                  ? 'en_US'
                  : 'ar_AR'
              : '',
          'indexName': (lang.isNotEmpty)
              ? (lang.toString() == 'en_US')
                  ? devLocation.toString()
                  : devLocationAr.toString()
              : '',
          'only_city': onlyCity.toString(),
          'keyword': query.toString()
        };

        final categoryJson = await app_instance.propertyRepository
            .getLocationList(jsonData, isAloglia, loc, locationId);
        players = <Players>[];
        for (int i = 0; i < categoryJson.length; i++) {
          players!.add(Players.fromJson(categoryJson[i], lang));
        }
        return players;

        /* if (categoryJson.toString().length != 2) {
          print(categoryJson[0]['id']);
          print('id');
          print(categoryJson[0]['parent_id']);
          notifyParent(
              '',
              (lang == 'en_US')
                  ? categoryJson[0]['city_area']
                  : categoryJson[0].containsKey('city_area_ar')
                      ? (categoryJson[0]['city_area_ar'] != null)
                          ? categoryJson[0]['city_area_ar']
                          : categoryJson[0]['city_area']
                      : (categoryJson[0]['city_area'] != null)
                          ? categoryJson[0]['city_area']
                          : categoryJson[0]['city_area_ar'],
              (categoryJson[0]['parent_id'] != 0)
                  ? categoryJson[0]['parent_id']
                  : categoryJson[0]['id']);
          
        } else {
          notifyParent('', '', '');
        } */
      }
    } catch (e, _) {
      print(e);
      print(_);
      print("Exception");
    }
  }
}
