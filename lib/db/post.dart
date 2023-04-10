import 'package:isar/isar.dart';

part 'post.g.dart';

@collection
class Post {
  Id id = Isar.autoIncrement;

  String? model = "";
  String? renk = "";
  String? resim = "";
  int? numara = 0;
  DateTime time = DateTime.now();
}
