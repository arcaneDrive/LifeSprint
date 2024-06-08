import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'models.dart';

class DatabaseService {
  static Database? _db;
  static final DatabaseService instance = DatabaseService._constructor();


  final String _usersTableName = "users";
  final String _usersIdColumnName = "id";
  final String _usersNameColumnName = "name";
  final String _usersAgeColumnName = "age";
  final String _usersGenderColumnName = "gender";
  final String _usersBloodTypeColumnName = "blood_type";
  final String _usersMedicalConditionsColumnName = "medical_conditions";
  final String _usersMedicationsColumnName = "medications";
  final String _usersAllergiesColumnName = "allergies";
  final String _usersEmergencyContactNameColumnName = "emergency_contact_name";
  final String _usersEmergencyContactRelationshipColumnName = "emergency_contact_relationship";
  final String _usersEmergencyContactPhoneNumberColumnName = "emergency_contact_phone_number";


  // final String _tasksTableName = "tasks";
  // final String _tasksIdColumnName = "id";
  // final String _tasksContentColumnName = "content";
  // final String _tasksStatusColumnName = "status";

  DatabaseService._constructor();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await getDatabase();
    return _db!;
  }


   Future<Database> getDatabase() async {
    final databaseDirPath = await getDatabasesPath();
    final databasePath = join(databaseDirPath, "master_db.db");
    final database = await openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
        CREATE TABLE $_usersTableName (
          $_usersIdColumnName INTEGER PRIMARY KEY AUTOINCREMENT,
          $_usersNameColumnName TEXT NOT NULL,
          $_usersAgeColumnName INTEGER NOT NULL,
          $_usersGenderColumnName TEXT NOT NULL,
          $_usersBloodTypeColumnName TEXT NOT NULL,
          $_usersMedicalConditionsColumnName TEXT,
          $_usersMedicationsColumnName TEXT,
          $_usersAllergiesColumnName TEXT,
          $_usersEmergencyContactNameColumnName TEXT NOT NULL,
          $_usersEmergencyContactRelationshipColumnName TEXT NOT NULL,
          $_usersEmergencyContactPhoneNumberColumnName TEXT NOT NULL
        )
        ''');
      },
    );
    return database;
  }





  // Future<Database> getDatabase() async {
  //   final databaseDirPath = await getDatabasesPath();
  //   final databsePath = join(databaseDirPath, "master_db.db");
  //   final database = await openDatabase(
  //     databsePath,
  //     version: 1,
  //     onCreate: (db, version) {
  //       db.execute('''
  //       CREATE TABLE $_tasksTableName (
  //         $_tasksIdColumnName INTEGER PRIMARY KEY,
  //         $_tasksContentColumnName TEXT NOT NULL,
  //         $_tasksStatusColumnName INTEGER NOT NULL
  //     )    
  //     ''');
  //     },
  //   );
  //   return database;
  // }

  void addTask(
    String content,
  ) async {
    final db = await database;
    await db.insert(
      _usersTableName,
      {
        _usersNameColumnName: content,
        _usersAgeColumnName: 0,
      },
    );
  }

  Future<List<Task>?> getTask() async {
    final db = await database;
    final data = await db.query(_usersTableName);
    List<Task> tasks = data
        .map((e) => Task(
              id: e["id"] as int,
              status: e["status"] as int,
              content: e["content"] as String,
            ))
        .toList();
    return tasks;
  }

  void updateTaskStatus(int id, int status) async {
    final db = await database;
    await db.update(
        _usesTableName,
        {
          // edit here ......................
          // _tasksIdColumnName: status,
        },
        where: 'id = ?',
        whereArgs: [
          id,
        ]);
  }

  void deleteTask(int id) async {
    final db = await database;
    await db.delete(
      _usesTableName,
      where: 'id = ?',
      whereArgs: [
        id,
      ],
    );
  }
}
