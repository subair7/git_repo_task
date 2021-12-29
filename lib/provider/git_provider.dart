import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../network/Api/api_handler.dart';
import '../network/Response/post_response.dart';

class PostProvider extends ChangeNotifier {
  bool isFetching = true;

  List<PostResponse> _getPostRes = [];

  addPost(PostResponse data){
    _getPostRes.insert(0,data);
    notifyListeners();
  }

  removePost(int index){
    _getPostRes.removeAt(index);
    notifyListeners();
  }

  setPostResponse(List<PostResponse> data) {
    // notifyListeners();
    _getPostRes.clear();
    notifyListeners();
    _getPostRes.addAll(data);
    print('list : ${_getPostRes.toString()}');
    isFetching = false;
    notifyListeners();
  }

  List<PostResponse> getPostResponse() {
    return _getPostRes;
  }

  Future<List<PostResponse?>> fetchPost(BuildContext context,int pageKey) async {
    try {
      var getPostResponse = await ApiHandler.fetchPost(context,pageKey);

      setPostResponse(getPostResponse!);
    } catch (e) {
      print("PostFetch() -> ${e.toString()}");
    }
    return _getPostRes;
    /*  Navigator.push(context, MaterialPageRoute(builder: (context) => Home()),);*/
  }
}
