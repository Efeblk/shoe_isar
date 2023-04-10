import 'package:isar/isar.dart';

part 'product.g.dart';

@collection
class Product{

  Id id = Isar.autoIncrement;
  bool favorite = false;
  String? model;
  DateTime? favoriteTime;
  List<String> tags = [];
  double? fiyat;

}

 