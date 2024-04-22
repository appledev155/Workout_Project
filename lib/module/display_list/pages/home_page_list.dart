import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/home_lists/homelist.dart';
import 'package:anytimeworkout/isar/home_lists/operation.dart' as home_list;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePageList extends StatefulWidget {
  const HomePageList({super.key});

  @override
  State<HomePageList> createState() => _HomePageListState();
}

class _HomePageListState extends State<HomePageList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController distanceController = TextEditingController();
  TextEditingController latitudeController = TextEditingController();
  TextEditingController longitudeController = TextEditingController();

  home_list.HomeListOperation homeList = home_list.HomeListOperation();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Form"),
        systemOverlayStyle: const SystemUiOverlayStyle(
            systemNavigationBarColor: lightColor,
            systemNavigationBarIconBrightness: Brightness.dark,
            statusBarColor: primaryColor,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          margin: const EdgeInsets.only(top: 30, left: 15, right: 15),
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                  controller: nameController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(right: 20.0),
                    filled: true,
                    fillColor: greyColor,
                    hintText: 'Name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: blackColorLight,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Duration';
                    }
                    return null;
                  },
                  controller: durationController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(right: 20.0),
                    filled: true,
                    fillColor: greyColor,
                    hintText: 'Duration',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: blackColorLight,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Date';
                    }
                    return null;
                  },
                  controller: dateController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(right: 20.0),
                    filled: true,
                    fillColor: greyColor,
                    hintText: 'Date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: blackColorLight,
                    ),
                    // prefixIcon: const Icon(
                    //   lockIcon,
                    //   color: blackColorLight,
                    // ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Distance';
                    }
                    return null;
                  },
                  controller: distanceController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(right: 20.0),
                    filled: true,
                    fillColor: greyColor,
                    hintText: 'Distance',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: blackColorLight,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter latitude';
                    }
                    return null;
                  },
                  controller: latitudeController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(right: 20.0),
                    filled: true,
                    fillColor: greyColor,
                    hintText: 'latitude',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: blackColorLight,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter longitude';
                    }
                  },
                  controller: longitudeController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.only(right: 20.0),
                    filled: true,
                    fillColor: greyColor,
                    hintText: 'longitude',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      color: blackColorLight,
                    ),
                  ),
                  // onSaved:(value) => longitudeController = double.parse(value!),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))),
                  onPressed: () async {
                    if (nameController.text.isEmpty ||
                        dateController.text.isEmpty ||
                        durationController.text.isEmpty ||
                        distanceController.text.isEmpty ||
                        latitudeController.text.isEmpty ||
                        longitudeController.text.isEmpty) {
                      Fluttertoast.showToast(
                          msg: "All Fields are required",
                          timeInSecForIosWeb: 2,
                          textColor: favoriteColor,
                          backgroundColor: lightColor);
                    } else {
                      HomeList listrecord = HomeList(
                        name: nameController.text,
                          duration: durationController.text,
                          date: dateController.text,
                          distance: distanceController.text,
                          latitude: double.parse(latitudeController.text),
                          longitude: double.parse(longitudeController.text));
                      await homeList.saveData(listrecord);
                      Fluttertoast.showToast(
                          msg: " submitted Successfully",
                          timeInSecForIosWeb: 1,
                          textColor: lightColor,
                          backgroundColor: primaryColor);
                      nameController.clear();
                      durationController.clear();
                      dateController.clear();
                      distanceController.clear();
                      latitudeController.clear();
                      longitudeController.clear();
                    }
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Submit',
                            style: TextStyle(
                                fontSize: pageIconSize,
                                fontWeight: FontWeight.bold,
                                color: lightColor)),
                      ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
