import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:vibration/vibration.dart';

class ActivitySavePage extends StatefulWidget {
  const ActivitySavePage({super.key});

  @override
  State<ActivitySavePage> createState() => _ActivitySavePageState();
}

class _ActivitySavePageState extends State<ActivitySavePage> {
  double _sliderValue = 0;
  bool _buttonflag=false;
  String _text = 'How did that activity feel?';
  String _details = '''What is Perceived Exertion?''';
  String _subdetails =
      '''Perceived Exertion is how hard your workout felt overall. Add it to your activities to track how your body is responding to your training. Perceived Exertion can also be used in place of heart rate data with subscription features, so you can better understand how your fitness is trending over time.''';
  TextButton _textButton = TextButton(onPressed: () {}, child: const Text(''));
  void _vibrate() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 100);
    }
  }

  void _clearSlider() {
    setState(() {
      _sliderValue = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange.shade900,
        automaticallyImplyLeading: false,
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text(
                'SAVE',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13),
              ))
        ],
        title: const Text(
          'Save Activity',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: TextFormField(
                cursorColor: Colors.black,
                cursorWidth: 1,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    hintText: 'Title your run',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: TextFormField(
                maxLines: 3,
                cursorColor: Colors.black,
                cursorWidth: 1,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    hintText:
                        '''How'd it go? Share more about your activity and use @ to tag someone''',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: TextFormField(
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    hintText: 'Run',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Text(
                'Details',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: TextFormField(
                showCursor: false,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    suffixIcon: const Icon(Icons.expand_more_sharp),
                    suffixIconColor: Colors.black45,
                    prefixIcon: const Icon(Icons.route),
                    prefixIconColor: Colors.black45,
                    hintText: 'Type of run',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: TextFormField(
                keyboardType: TextInputType.none,
                showCursor: false,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    hintText: 'How did that activity feel?',
                    hintStyle: const TextStyle(fontSize: 14),
                    prefixIcon: const Icon(Icons.star),
                    prefixIconColor: Colors.black45,
                    suffixIcon: const Icon(Icons.expand_more_sharp),
                    suffixIconColor: Colors.black45),
                onTap: () {
                  showModalBottomSheet(
                      shape: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(5)),
                      context: context,
                      builder: (BuildContext context) {
                        return StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Container(
                            height: 350,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(
                                      'Perceived Exertion',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 10, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        _text,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Spacer(),
                                      SizedBox(height: 30, child: _textButton)
                                    ],
                                  ),
                                ),
                                Slider(
                                  thumbColor: Colors.white,
                                  inactiveColor: Colors.grey.shade400,
                                  activeColor: Colors.orange.shade900,
                                  value: _sliderValue,
                                  divisions: 9,
                                  max: 100,
                                  onChanged: (double value) {
                                    setState(() {
                                      _sliderValue = value;
                                      if (value <= 33.33) {
                                        _text = 'Easy';
                                        _details = '''What's Easy?''';
                                        _subdetails =
                                            '''could talk normally \nBreathing naturally \nFelt very comfortable''';
                                      } else if (value <= 66.66) {
                                        _text = 'Moderate';
                                        _details = '''What's Moderate?''';
                                        _subdetails =
                                            '''could talk in short spurts \nBreathing more labored \nWithin your comfort Zone,but working''';
                                      } else if (value <= 99.99) {
                                        _text = 'Hard';
                                        _details = '''What's Hard?''';
                                        _subdetails =
                                            '''could barely talk \nBreathing heavily \nOutside your control Zone''';
                                      } else {
                                        _text = 'Max Effort';
                                        _details = '''What's Max Effort?''';
                                        _subdetails =
                                            '''At your physical limit\nGasping for breath \ncouldn't talk/could barely remember your name''';
                                      }
                                      _textButton = TextButton(
                                          onPressed: () {
                                            setState(() {
                                              _clearSlider();
                                              _details =
                                                  '''What is Perceived Exertion?''';
                                              _subdetails =
                                                  '''Perceived Exertion is how hard your workout felt overall. Add it to your activities to track how your body is responding to your training. Perceived Exertion can also be used in place of heart rate data with subscription features, so you can better understand how your fitness is trending over time.''';
                                              _textButton = TextButton(
                                                  onPressed: () {},
                                                  child: const Text(''));
                                              _text =
                                                  'How did that activity feel?';
                                            });
                                          },
                                          child: Text(
                                            'Clear Entry',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.orange.shade900),
                                          ));
                                    });
                                    _vibrate();
                                  },
                                ),
                                Row(
                                  children: const [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                      child: Text(
                                        'Easy',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(130, 0, 0, 0),
                                      child: Text(
                                        'Moderate',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(110, 0, 0, 0),
                                      child: Text(
                                        'Max Effort',
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    )
                                  ],
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 15, 0),
                                  child: TextButton(
                                      onPressed: () {
                                        setState(() {
                                          _buttonflag=!_buttonflag;
                                        },);
                                        if(_buttonflag==true){
                                             print(_buttonflag);
                                        }
                                        if(_buttonflag==false){
                                        }
                                      },
                                      child:_buttonflag==false?Text('Hide details'):Text('Show details')
                                      ),
                                ),
                                _buttonflag==false? Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 0, 15, 0),
                                  child: Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      //color: Colors.amber,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey)),
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 10, 0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            RichText(
                                                text: TextSpan(
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                    text: _details)),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            RichText(
                                                text: TextSpan(
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12),
                                                    text: _subdetails))
                                          ],
                                        ),
                                      )),
                                ):Text('')
                              ],
                            ),
                          );
                        });
                      });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: TextFormField(
                maxLines: 2,
                cursorColor: Colors.black,
                cursorWidth: 1,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 40, 10, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    prefixIcon: const Icon(Icons.lock_outline_sharp),
                    prefixIconColor: Colors.black45,
                    hintText:
                        'Jot down private notes here.Only you can see these.',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Text(
                'Visibility',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Text(
                'Who can see',
                style: TextStyle(fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: TextFormField(
                showCursor: false,
                readOnly: true,
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    prefixIcon: const Icon(Icons.language_outlined),
                    prefixIconColor: Colors.black45,
                    suffixIcon: const Icon(Icons.expand_more),
                    suffixIconColor: Colors.black45,
                    hintText: 'Everyone',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: Text(
                'Hide Stats',
                style: TextStyle(fontSize: 13),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: TextFormField(
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5)),
                    focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.black)),
                    enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(width: 1, color: Colors.grey)),
                    prefixIcon: const Icon(Icons.visibility_outlined),
                    prefixIconColor: Colors.black45,
                    suffixIcon: const Icon(Icons.expand_more),
                    hintText: 'Choose',
                    hintStyle: const TextStyle(fontSize: 14)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
              child: Row(
                children: [
                  const Text(
                    'Mute Activity',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Icon(
                    Icons.perm_device_information_rounded,
                    size: 19,
                    color: Colors.black,
                  )
                ],
              ),
            ),
            CheckboxListTile(
                activeColor: Colors.orange.shade900,
                title: const Text(
                  '''Don't publish to Home or club feeds''',
                  style: TextStyle(fontSize: 14),
                ),
                subtitle: const Text(
                  'This activity will still be visible on your profile',
                  style: TextStyle(fontSize: 13),
                ),
                value: true,
                onChanged: (bool) {}),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.orange.shade900)),
                      onPressed: () {},
                      child: Text(
                        'Discard activity',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade900),
                      ))),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
//  onChangeEnd: (double value) {
//                                 setState(() {
//                                   if (value < 33.33) {
//                                     _exertionText = 'Easy';
//                                   } else if (value < 66.66) {
//                                     _exertionText = 'Moderate';
//                                   } else {
//                                     _exertionText = 'Max Effort';
//                                   }
//                                 });
//                               },
