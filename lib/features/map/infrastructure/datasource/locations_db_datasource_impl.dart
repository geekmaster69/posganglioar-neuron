import 'package:candy_tracker/config/database/data_base.dart';
import 'package:candy_tracker/features/map/domain/domain.dart';
import 'package:sqflite/sqflite.dart';

class LocationsDbDatasourceImpl implements LocationsDbDatasource {
  final Database db;

  LocationsDbDatasourceImpl() : db = DatabaseHelper().db;
  @override
  Future<bool> isVisited(int candyId) async {
    try {
      final list = await db.query(
        'visitedTable',
        where: 'candyId = ?',
        whereArgs: [candyId],
      );

      return list.isNotEmpty;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<void> toggleVisitedLocation(int candyId) async {
    final isOnDb = await isVisited(candyId);

    if (isOnDb) {
      await db.delete(
        'visitedTable',
        where: 'candyId = ?',
        whereArgs: [candyId],
      );
    } else {
      await db.insert('visitedTable', {'candyId': candyId});
    }
  }

  @override
  Future<List<int>> getVisitedLocations() async {
    final visitedList = await db.query('visitedTable');
    return visitedList.map((e) => e['candyId'] as int).toList();
  }
}
