// dao/person_dao.dart

import 'package:floor/floor.dart';
import 'package:git_repo/network/Response/git_model.dart';
import 'package:git_repo/network/Response/post_response.dart';

@dao
abstract class PostResponseDao {
  @Query('SELECT * FROM Repo')
  Future<List<Repo>> findAllRepo();

  @Query('SELECT * FROM Repo WHERE id = :id')
  Stream<Repo?> findRepoById(int id);

  @insert
  Future<void> insertRepo(Repo repo);
}