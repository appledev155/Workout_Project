import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/personal_information/operation.dart' as operation_store;
import 'package:anytimeworkout/isar/personal_information/personalinformation.dart';
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';



class PersonalInformationPage extends StatefulWidget {
  const PersonalInformationPage({super.key});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  bool personalInformation = false;
  operation_store.Operation operationstore = operation_store.Operation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  getdata() async {
    List<PersonalInformation> getdata = await operationstore.getdata();
    if (getdata.isNotEmpty) {
      setState(() {
        personalInformation =
            (getdata.first.selectedvalue == false) ? false : true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:primaryColor,
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PrivacyControlPage()));
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text(
          'Personal Information Sharing',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SwitchListTile(
                activeColor:primaryColor,
                title:  Text(
                  'Do Not Share My Personal Information',
                 style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle:  Padding(
                  padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    '''If you opt out,we will not share your personal Information for third party targeted advertising.For more Information,please see our Privacy Policy.''',
                     style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                  ),
                ),
                value: personalInformation,
                onChanged: (value) => setState(
                  () {
                    personalInformation = value;
                    PersonalInformation getdata = PersonalInformation(
                        id: 1, selectedvalue: personalInformation);
                    operationstore.insert(getdata);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
