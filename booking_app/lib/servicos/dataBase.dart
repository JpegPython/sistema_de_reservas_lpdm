import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseService {
  static final int _version = 1;
  static final String _name = 'database.db';

  static Future<Database> getDB() async {

    sqfliteFfiInit();
    var databaseFactory = databaseFactoryFfi;
    final io.Directory appDocumentsDir = await getApplicationDocumentsDirectory();
    final path = p.join(appDocumentsDir.path, "databases", _name);

    //await databaseFactory.deleteDatabase(path);
    Database db = await databaseFactory.openDatabase(
        path,
        options: OpenDatabaseOptions(
            version: _version,
            onCreate: (db, version) async {
              String sql = """
                              CREATE TABLE user(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name VARCHAR NOT NULL,
                email VARCHAR NOT NULL,
                password VARCHAR NOT NULL

              );

              CREATE TABLE address(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                cep VARCHAR NOT NULL UNIQUE,
                logradouro VARCHAR NOT NULL,
                bairro VARCHAR NOT NULL,
                localidade VARCHAR NOT NULL,
                uf VARCHAR NOT NULL,
                estado VARCHAR NOT NULL
              );

              CREATE TABLE property(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                address_id INTEGER NOT NULL,
                title VARCHAR NOT NULL,
                description VARCHAR NOT NULL,
                number INTEGER NOT NULL,
                complement VARCHAR,
                price REAL NOT NULL,
                max_guest INTEGER NOT NULL,
                thumbnail VARCHAR NOT NULL,
                FOREIGN KEY(user_id) REFERENCES user(id),
                FOREIGN KEY(address_id) REFERENCES address(id)
              );

              CREATE TABLE images(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                property_id INTEGER NOT NULL,
                path VARCHAR NOT NULL,    
                FOREIGN KEY(property_id) REFERENCES property(id)
              );

              CREATE TABLE booking(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                user_id INTEGER NOT NULL,
                property_id INTEGER NOT NULL,
                checkin_date VARCHAR NOT NULL,
                checkout_date VARCHAR NOT NULL,
                total_days INTEGER NOT NULL,
                total_price REAL NOT NULL,
                amount_guest INTEGER NOT NULL,
                rating REAL,
                FOREIGN KEY(user_id) REFERENCES user(id),
                FOREIGN KEY(property_id) REFERENCES property(id)
              );
          """;

              await db.execute(sql);
            }
        )
    );

    return db;

  }
}