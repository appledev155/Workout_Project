// import 'dart:async';

// import 'package:anytimeworkout/bloc/search_result/search_result_bloc.dart';
// import 'package:anytimeworkout/config/app_colors.dart';
// import 'package:anytimeworkout/config/styles.dart';
// import 'package:anytimeworkout/main.dart';
// import 'package:anytimeworkout/module/internet/bloc/internet_bloc.dart';
// import 'package:anytimeworkout/module/internet/config.dart';
// import 'package:anytimeworkout/module/internet/pages/offline_page.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:anytimeworkout/config.dart' as app_instance;

// class SearchScreenLoader extends StatefulWidget {
//   static void show(BuildContext context, {Key? key}) => showDialog<void>(
//         context: context,
//         useRootNavigator: false,
//         barrierDismissible: false,
//         builder: (_) => SearchScreenLoader(key: key),
//       ).then((_) => FocusScope.of(context).requestFocus(FocusNode()));

//   static void hide(BuildContext context) => Navigator.pop(context);

//   final SearchResultState? searchState;
//   final String? tabFor;
//   const SearchScreenLoader({Key? key, this.searchState, this.tabFor})
//       : super(key: key);

//   @override
//   State<SearchScreenLoader> createState() => _SearchScreenLoaderState();
// }

// class _SearchScreenLoaderState extends State<SearchScreenLoader> {
//   int seconds = 0;
//   Timer? timer;

//   @override
//   void initState() {
//     super.initState();
//     // startTimer();
//   }

//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (kDebugMode) {
//         // print("********SEARCH RESULT*********");
//         // print(widget.searchState!.status);
//         // print("********SEARCH RESULT*********");
//       }
//       setState(() {
//         seconds++;
//       });
//       if (seconds > app_instance.appConfig.algoliaTimeOut &&
//           widget.searchState!.status != SearchResultStatus.initial) {
//         timer.cancel();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     timer?.cancel();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ((widget.searchState!.status != SearchResultStatus.initial) &&
//             (context.read<InternetBloc>().state.connectionSpeed == -1.0 ||
//                 context.read<InternetBloc>().state.connectionStatus ==
//                     ConnectionStatus.disconnected ||
//                 widget.searchState!.status == SearchResultStatus.failure))
//         ? const OfflinePage()
//         : WillPopScope(
//             onWillPop: () async => false,
//             child: Center(
//               child: (widget.searchState!.status != SearchResultStatus.success)
//                   ? Card(
//                       child: Container(
//                         width: 150,
//                         padding: const EdgeInsets.all(12.0),
//                         child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               const CircularProgressIndicator(
//                                 color: primaryDark,
//                               ),
//                               const SizedBox(width: 15),
//                               const Text('list.lbl_loading').tr()
//                             ]),
//                       ),
//                     )
//                   : ((widget.searchState!.status ==
//                                   SearchResultStatus.success &&
//                               widget.searchState!.items!.isEmpty) ||
//                           widget.searchState!.agentStatus ==
//                                   SearchResultStatus.success &&
//                               widget.searchState!.agentitems!.isEmpty)
//                       ? Center(
//                           child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text('list.lbl_no_results_found',
//                                         style: TextStyle(
//                                             color: primaryDark,
//                                             fontWeight: FontWeight.w500,
//                                             fontSize: pageTitleSize))
//                                     .tr(),
//                                 const SizedBox(
//                                   height: 10,
//                                 ),
//                                 const Text('list.lbl_matching_results').tr(),
//                                 const Text('list.lbl_try_somethingelse').tr(),
//                                 Text(context
//                                     .read<InternetBloc>()
//                                     .state
//                                     .connectionSpeed
//                                     .toString())
//                               ]),
//                         )
//                       : Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             const Text(
//                               "Something went wrong",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w600, fontSize: 17),
//                             ),
//                             Text(context
//                                 .read<InternetBloc>()
//                                 .state
//                                 .connectionSpeed
//                                 .toString()),
//                             const SizedBox(height: 10),
//                             ElevatedButton(
//                                 onPressed: () {
//                                   Navigator.pushNamed(
//                                       context, "/search_result");
//                                 },
//                                 child: const Text("Retry"))
//                           ],
//                         ),
//             ),
//           );
//   }
// }
