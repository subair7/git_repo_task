// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';
import 'package:git_repo/floor/post_response_dao.dart';
import 'package:git_repo/network/Response/git_model.dart';
import 'package:git_repo/network/Response/post_response.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'app_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Repo])
abstract class AppDatabase extends FloorDatabase {
  PostResponseDao get postResponseDao;
}