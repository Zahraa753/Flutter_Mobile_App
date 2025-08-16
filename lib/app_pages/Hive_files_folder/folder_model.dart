import 'package:hive/hive.dart';
part 'folder_model.g.dart';

@HiveType(typeId: 1)
class FolderModel extends HiveObject {
  @HiveField(0)
  final String label;
  @HiveField(1)
  final int color;
  @HiveField(2)
  final String createAt;

  FolderModel({
    required this.label,
    required this.color,
    required this.createAt,
  });
}
