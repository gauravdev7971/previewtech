
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:previewtech/models/model_custom.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;

  static Database? _database;

  DatabaseService._internal();

  checkDatabase() async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {


    String path = join(await getDatabasesPath(), 'prev_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT, itemList TEXT, remark TEXT, finalAmount TEXT, type TEXT, date TEXT, time TEXT)',
        );
      },
    );
  }

  Future<void> insertData({required List<ModelPrice> itemList, required String finalAmount, required String type, required String remark, required String date, required String time}) async {
    await checkDatabase();
    String customListJson = jsonEncode(itemList.map((e) => e.toJson()).toList());

    await _database!.insert(
      'items',
      {
        'itemList': customListJson,
        'remark': remark,
        'type': type,
        'finalAmount': finalAmount,
        'date': date,
        'time': time,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateData({required int id, required List<ModelPrice> itemList, required String remark, required String finalAmount, required String type, required String date, required String time}) async {
    String customListJson = jsonEncode(itemList.map((e) => e.toJson()).toList());

    await _database!.update(
      'items',
      {
        'itemList': customListJson,
        'remark': remark,
        'date': date,
        'type': type,
        'finalAmount': finalAmount,
        'time': time,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteData(int id) async {
    await _database!.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<ModelHistory>?> fetchData() async {
    await checkDatabase();
    final List<Map<String, dynamic>> data = await _database!.query('items');
    if(data.isEmpty){return null;}

    List<ModelHistory> responseData = [];

    for(int i=0; i<data.length; i++){
      ModelHistory modelHistory = ModelHistory(
          id: data[i]['id'],
          remark: data[i]['remark'],
          type: data[i]['type'],
          finalAmount: data[i]['finalAmount'],
          date: data[i]['date'],
          time: data[i]['time'],
          itemList: List<ModelPrice>.from(jsonDecode(data[i]["itemList"]).map((x) => ModelPrice.fromJson(x))));
      responseData.add(modelHistory);
    }

    return responseData;


  }


}