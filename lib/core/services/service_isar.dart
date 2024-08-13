import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:todo/core/models/_models.dart';

class IsarConfig {
  const IsarConfig._();

  static Isar? _isar;
  static Isar get isar => _isar!;

  static const _schemas = [
    TaskSchema,
  ];

  static Future<void> development() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      directory: dir.path,
      name: 'development',
      _schemas,
    );
  }

  static Future<void> production() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      directory: dir.path,
      name: 'production',
      _schemas,
    );
  }
}
