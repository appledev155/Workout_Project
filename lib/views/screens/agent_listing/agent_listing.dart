import "package:flutter/material.dart";
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../components/agent_detail_row.dart';

class AgentListing extends StatelessWidget {
  final _scrollController = ScrollController();
  final String gifPath = dotenv.env['GifPath'].toString();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (BuildContext context, int index) {
            return AgentDetailRow(item: {
              "image": '$gifPath/assets/static/giphy.gif',
              "agentName": "Agent Name"
            });
          },
          controller: _scrollController,
        ));
  }
}
