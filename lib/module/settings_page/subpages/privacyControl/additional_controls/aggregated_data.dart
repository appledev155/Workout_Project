import 'package:anytimeworkout/isar/aggregated_data_usage/aggregate.dart';
import 'package:anytimeworkout/isar/aggregated_data_usage/aggregateoperation.dart' as aggregate_store;
import 'package:anytimeworkout/module/settings_page/subpages/privacyControl/privacy_controls.dart';
import 'package:flutter/material.dart';

class DataUsagePage extends StatefulWidget {
  const DataUsagePage({super.key});

  @override
  State<DataUsagePage> createState() => _DataUsagePageState();
}

class _DataUsagePageState extends State<DataUsagePage> {
  bool aggregate_data_sets = false;
  aggregate_store.AggregateOperation aggregatestore =
      aggregate_store.AggregateOperation();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getaggregatevalue();
  }

  getaggregatevalue() async {
    List<Aggregate> getvalue = await aggregatestore.getaggregate();
    if (getvalue.isNotEmpty) {
      setState(() {
        aggregate_data_sets =
            (getvalue.first.aggregateselectvalue == false) ? false : true;
        print(aggregate_data_sets);
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
          'Aggregated Data Usage',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CheckboxListTile(
                  activeColor: Colors.orange.shade900,
                  title: const Text(
                    'Contribute your activity data to de-identified,aggregate data sets',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: const Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      '''When you contribute your activity data using this checkboc,your data is de-identified and aggregated with other athletes' activity data to support our community-powered features such as Metro,Heatmap,Points of Interest and start/End points.These aggregate data sets do not include activities set to 'only you' visibility.''',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  value: aggregate_data_sets,
                  onChanged: (value) => setState(() {
                        aggregate_data_sets = value!;
                        Aggregate getvalue = Aggregate(
                            id: 1, aggregateselectvalue: aggregate_data_sets);
                        aggregatestore.insert(getvalue);
                        wait();
                      })),
              const Divider(
                thickness: 0.5,
                height: 40,
                color: Colors.grey,
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                child: Text('Why contribute?'),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 10, 10, 0),
                child: Text(
                  '''Strava Metro,the Global Heatmap,Points of Interest and Start/End Points are examples of community-powered features that improve the Strava experience.The Metro data set is used exclusively by Urban planners,advocacy groups,and research institutions to build safer towns and citites for pedestrians and cyclists.The other features source the collective knowledge and route usage of athletes to help the Strava community find places to run ,ride and walk.All data is aggregated and de-identified.''',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                child: Text(
                  'Learn more',
                  style: TextStyle(color: Colors.orange.shade900),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void wait() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: SizedBox(
              height: 70,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  CircularProgressIndicator(
                    color: Colors.orange.shade900,
                  ),
                  const SizedBox(
                    width: 30,
                  ),
                  Text('Please wait...')
                ],
              ),
            ),
          );
        });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }
}
