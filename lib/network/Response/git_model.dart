// entity/person.dart

import 'package:floor/floor.dart';

@entity
class Repo {
  @primaryKey
  final int? id;

  final String? name;
  final String? des;

  final String? lan;

  final String? img;
  final String? view;
  final String? count;

  Repo(
      {this.id,
      this.name,
      this.des,
      this.lan,
      this.img,
      this.view,
      this.count});
}
