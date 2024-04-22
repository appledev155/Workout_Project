

import 'package:anytimeworkout/isar/public_photos/sharePhoto.dart';
import 'package:anytimeworkout/isar/public_photos/sharephotooperation.dart' as  store_value;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';

class PublicPhotoPage extends StatefulWidget {
  const PublicPhotoPage({super.key});

  @override
  State<PublicPhotoPage> createState() => _PublicPhotoPageState();
}

class _PublicPhotoPageState extends State<PublicPhotoPage> {
  bool share_photo = false;
  store_value.SharePhotoOperation storevalue =
      store_value.SharePhotoOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getvalue();
  }

  getvalue() async {
    List<SharePhoto> getselectedvalue = await storevalue.getvalue();
    if (getselectedvalue.isNotEmpty) {
      setState(() {
        share_photo =
            (getselectedvalue.first.selectvalue == false) ? false : true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
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
          'Public photos on routes',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        //color: Colors.amber,
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: MediaQuery.of(context).size.width,
              child: CheckboxListTile(
                  title: const Text(
                    'Share photos with the community',
                    style: TextStyle(fontSize: 14),
                  ),
                  activeColor: Colors.orange.shade900,
                  value: share_photo,
                  onChanged: ((value) {
                    setState(() {
                      share_photo = value!;
                      SharePhoto getvalue =
                          SharePhoto(id: 1, selectvalue: share_photo);
                      storevalue.inser(getvalue);
                    });
                  })),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Divider(
                color: Colors.grey,
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              height: 180,
              width: MediaQuery.of(context).size.width,
              child: const Text(
                '''When you opt in your profile visibility in set to public (set to 'Everyone').photos uploaded to your public activities (set to 'Everyone')may be visible to other Strava users to help them better understand outdoor routes and places.We exclude all photos taken in areas you've hidden using our "hide a specific address" setting.We aim to exclude photos that contain identifiable faces or specific gear (a bike,for example.)If you delete a photo from your activity,or change a public activity to 'Followers Only' or 'Only you,' your photo will be removed from public view.''',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
              child: Text(
                'Why Share?',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: const Text(
                '''We use public photos to inspire other members of the Strava community to get out and explore.When you share a photo of a trail or viewpoint,this can help other users better understand the routes they plan on taking and prepare for great adventures.''',
                style: TextStyle(fontSize: 12),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Text(
                'Learn more',
                style: TextStyle(color: Colors.orange.shade800),
              ),
            )
          ],
        ),
      ),
    );
  }
}
