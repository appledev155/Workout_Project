import 'package:anytimeworkout/config/app_colors.dart';
import 'package:anytimeworkout/config/styles.dart';
import 'package:anytimeworkout/isar/push_notification1/notificationpush.dart';
import 'package:anytimeworkout/module/settings_page/subpages/push_notification/pages/divider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:anytimeworkout/isar/push_notification1/operation.dart'
    as operation_store;

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  bool kudos_and_like = false;
  bool post_comments = false;
  bool mentions_onpost = false;
  operation_store.NotificationOperationPage operationstore =
      operation_store.NotificationOperationPage();
  List<String> posts = [];
  getpostsvalue() async {
    List<NotificationPush> getvalue = await operationstore.getpostsvalue();
    if (getvalue.isNotEmpty) {
      setState(() {
        for (var item in getvalue) {
          posts = item.posts!;
        }
      });
      setState(() {
        if (posts.contains('Post Kudos and Likes')) {
          kudos_and_like = true;
        }
        if (posts.contains('Post Comments')) {
          post_comments = true;
        }
        if (posts.contains('Mentions on Posts')) {
          mentions_onpost = true;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getpostsvalue();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 15, 0, 0),
            child: Text(
              'Posts',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: drawerMenuItemSize,
                  color: blackColorDark),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Post Kudos and Likes',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when I receive kudos on a post or likes on my comments',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: kudos_and_like,
                onChanged: (value) {
                  setState(() {
                    kudos_and_like = value!;
                    if (kudos_and_like == true) {
                      var tempposts = List<String>.from(posts);
                      tempposts.add('Post Kudos and Likes');
                      posts = tempposts;
                    } else if (kudos_and_like == false) {
                      if (posts.contains('Post Kudos and Likes')) {
                        var tempposts = List<String>.from(posts);
                        tempposts.remove('Post Kudos and Likes');
                        posts = tempposts;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 6, posts: posts);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Post Comments',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone comments on my post or replies to my comment on a post',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: post_comments,
                onChanged: (value) {
                  setState(() {
                    post_comments = value!;
                    if (post_comments == true) {
                      var tempposts = List<String>.from(posts);
                      tempposts.add('Post Comments');
                      posts = tempposts;
                    } else if (post_comments == false) {
                      if (posts.contains('Post Comments')) {
                        var tempposts = List<String>.from(posts);
                        tempposts.remove('Post Comments');
                        posts = tempposts;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 6, posts: posts);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: CheckboxListTile(
                activeColor: primaryColor,
                title: Text(
                  'Mentions on Posts',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorDark),
                ),
                subtitle: Text(
                  'Notify me when someone mentions me in a post comment',
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: pageIconSize,
                      color: blackColorLight),
                ),
                value: mentions_onpost,
                onChanged: (value) {
                  setState(() {
                    mentions_onpost = value!;
                    if (mentions_onpost == true) {
                      var tempposts = List<String>.from(posts);
                      tempposts.add('Mentions on Posts');
                      posts = tempposts;
                    } else if (mentions_onpost == false) {
                      if (posts.contains('Mentions on Posts')) {
                        var tempposts = List<String>.from(posts);
                        tempposts.remove('Mentions on Posts');
                        posts = tempposts;
                      }
                    }
                    NotificationPush getvalue =
                        NotificationPush(id: 6, posts: posts);
                    operationstore.insert(getvalue);
                  });
                }),
          ),
          SizedBox(
            height: 15,
          ),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: dividerColor,
          ),
        ],
      ),
    );
  }
}
