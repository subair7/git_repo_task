import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:git_repo/network/Response/git_model.dart';
import 'package:git_repo/network/Response/post_response.dart';
import 'package:git_repo/view/widget/ShimmerWidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../provider/git_provider.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with WidgetsBindingObserver {
  var _post;
  bool isInternet = false;


  final _pagingController = PagingController<int, PostResponse>(
    // 2
    firstPageKey: 1,
  );

  @override
  void initState() {
    // TODO: implement initState
    triggerObservers();
    checkInternet();
    super.initState();
    _post = Provider.of<PostProvider>(context, listen: false);
    _pagingController.addPageRequestListener((pageKey) {
      hitpostDetails(pageKey);
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _pagingController.dispose();
    super.dispose();
  }

  void triggerObservers() {
    WidgetsBinding.instance!.addObserver(this);
  }

  Future<void> hitpostDetails(int pageKey) async {
    // try {
    //   final newPage = await _post.fetchPost(context, pageKey);
    try {
      final newItems = await _post.fetchPost(context, pageKey);
      final isLastPage = newItems.length < 15;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        pageKey = pageKey + 1;
        // final nextPageKey = pageKey + 15;


        _pagingController.appendPage(newItems, pageKey.toInt());
      }
    } catch (error) {
      _pagingController.error = error;
    }
    // pageKey++;
  }

  Widget _title(BuildContext context) {
    return Container(
      child: const Text(
        'Interview Task',
        style: TextStyle(
            fontSize: 18.0,
            fontFamily: "Roboto",
            fontWeight: FontWeight.w500,
            color: Colors.black),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Colors.white,
        // Color(0xFF662D91),
        title: _title(context),
        elevation: 0,
      ),
      body: SafeArea(
          child: RefreshIndicator(
        onRefresh: () async {
          await checkInternet();
          return Future.sync(
            // 2
            () => _pagingController.refresh(),
          );
        },
        // 3
        child: isInternet
            ? PagedListView.separated(
                // 4
                pagingController: _pagingController,
                // padding: const EdgeInsets.all(16),
                separatorBuilder: (context, index) => const SizedBox(
                  height: 0,
                ),
                builderDelegate: PagedChildBuilderDelegate<PostResponse>(
                  itemBuilder: (context, post, index) {
                    dao!.insertRepo(Repo(
                        id: post.id,
                        name: post.name,
                        des: post.description,
                        lan: post.language,
                        img: post.owner!.avatarUrl,
                        view: post.watchers.toString(),
                        count: post.forks.toString()));

                    print(dao!.findAllRepo());

                    return Card(
                      elevation: 4.0,
                      margin: new EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                        // leading: Image.asset('assets/logo.png'),
                        leading: Container(
                          padding: const EdgeInsets.only(right: 12.0),
                          decoration: BoxDecoration(
                              border: Border(
                                  right: new BorderSide(
                                      width: 1.0, color: Colors.grey))),
                          child: post.owner!.avatarUrl != null &&
                                  post.owner!.avatarUrl != ''
                              ? ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: "${post.owner!.avatarUrl}",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          // colorFilter:
                                          // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) => ClipOval(
                                      child: Container(
                                          height: 36,
                                          width: 36,
                                          child: Image.asset(
                                              'assets/programmer.png')),
                                    ),
                                    errorWidget: (context, url, error) => Icon(
                                      Icons.error,
                                      size: 36,
                                    ),
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 14,
                                  backgroundColor: Colors.white,
                                  child: Image.asset('assets/programmer.png')),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              post.name!.length > 20
                                  ? post.name!.substring(0, 20) + '...'
                                  : post.name ?? "",
                            ),
                            // PopupMenuButton(
                            //     child: Icon(
                            //       Icons.more_vert,
                            //       size: 16,
                            //     ),
                            //     elevation: 40,
                            //     enabled: true,
                            //     offset: Offset(0, 50),
                            //     onSelected: (value) async {
                            //       if (value == 1) {
                            //         await Provider.of<PostProvider>(context,
                            //             listen: false)
                            //             .removePost(index);
                            //       }
                            //     },
                            //     itemBuilder: (context) {
                            //       return popUpMenu.map((dynamic choice) {
                            //         return PopupMenuItem(
                            //           value: choice["value"],
                            //           child: Text(
                            //             choice["name"],
                            //           ),
                            //         );
                            //       }).toList();
                            //     }),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              post.description ?? '',
                              maxLines: 2,
                              style: TextStyle(fontSize: 10),
                            ),
                            SizedBox(
                              height: 2,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.code,
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      post.language ?? '',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.bug_report,
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      post.forks.toString() ?? '',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.remove_red_eye_outlined,
                                      size: 14,
                                      color: Colors.black,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      post.watchersCount.toString() ?? '',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            // Text(" Intermediate", style: TextStyle(color: Colors.white))
                          ],
                        ),
                      ),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) => Text('Error'),
                  noItemsFoundIndicatorBuilder: (context) => Text('No Items'),
                ),
              )
            : FutureBuilder<List<Repo>>(
                future: dao!.findAllRepo(),
                builder: (_, snapshot) {
                  if (!snapshot.hasData)
                    return ListView.builder(
                        itemCount: 10,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildShimmer();
                        });

                  final tasks = snapshot.requireData;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (_, index) {
                      return Card(
                        elevation: 4.0,
                        margin: new EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 6.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: const EdgeInsets.only(right: 12.0),
                            decoration: BoxDecoration(
                                border: Border(
                                    right: new BorderSide(
                                        width: 1.0, color: Colors.grey))),
                            child: tasks[index].img != null &&
                                    tasks[index].img != ''
                                ? ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: "${tasks[index].img}",
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                            // colorFilter:
                                            // ColorFilter.mode(Colors.red, BlendMode.colorBurn)
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => ClipOval(
                                        child: Container(
                                            height: 36,
                                            width: 36,
                                            child: Image.asset(
                                                'assets/programmer.png')),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(
                                        Icons.error,
                                        size: 36,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 14,
                                    backgroundColor: Colors.white,
                                    child:
                                        Image.asset('assets/programmer.png')),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                tasks[index].name!.length > 20
                                    ? tasks[index].name!.substring(0, 20) +
                                        '...'
                                    : tasks[index].name ?? "",
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                tasks[index].des ?? '',
                                maxLines: 2,
                                style: TextStyle(fontSize: 10),
                              ),
                              SizedBox(
                                height: 2,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.code,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        tasks[index].lan ?? '',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.bug_report,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        tasks[index].count.toString() ?? '',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 14,
                                        color: Colors.black,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        tasks[index].view.toString() ?? '',
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              // Text(" Intermediate", style: TextStyle(color: Colors.white))
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      )),
    );
  }

  Widget buildShimmer() => ListTile(
      leading: ShimmerWidget.circular(
        width: 48,
        height: 48,
        shapeBorder:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      ),
      title: Align(
          alignment: Alignment.centerLeft,
          child: ShimmerWidget.rectangular(
            height: 16,
            width: MediaQuery.of(context).size.width * 0.3,
          )),
      subtitle: ShimmerWidget.rectangular(height: 14));

  Future<void> checkInternet() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          isInternet = true;
        });
        print('connected');
      }
    } on SocketException catch (_) {
      setState(() {
        isInternet = false;
      });
      print('not connected');
    }
  }
}
