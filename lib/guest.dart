import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
);

/// Guest Datatype
/// support conversion from and too db Objects
@immutable
class Guest {
  Guest(
      {required this.vName,
      required this.nName,
      required this.email,
      required this.location,
      required this.entryTime,
      required this.phone, } )
  ;
  ///constructs Guest Object from Parameters
  Guest.fromParams(
      this.vName, this.nName, this.email,
      this.location, this.entryTime, this.phone,
      );

  ///constructs Guest Object from json
  Guest.fromJson(Map<String, Object?> json)
      : this(
            vName: json['v_name']! as String,
            nName: json['n_name']! as String,
            email: json['email']! as String,
            location: json['location']! as String,
            entryTime: (json['entryTime']! as Timestamp).toDate(),
            phone: json['phone']! as String,);

  late final String vName;
  late final String nName;
  late final String email;
  late final String location;
  late final DateTime entryTime;
  late final String phone;

  @override
  String toString() {
    return 'Guest{vName: $vName, nName: $nName, '
        'email: $email, location: $location, entryTime: $entryTime, phone: $phone, guests: $guests}';
  }
  final CollectionReference guests =
      FirebaseFirestore.instance.collection('guests');

  void addToDB() {
    guests
        .add({
          'n_name': nName,
          'v_name': vName,
          'email': email,
          'location': location,
          'entryTime': entryTime,
          'phone': phone,
        })
        .then((value) => logger.i('Guest Added'))
        .catchError((dynamic error) => logger.e('Failed to add Guest: $error'));
  }

  Map<String, Object?> toJson() {
    return {
      'n_name': nName,
      'v_name': vName,
      'email': email,
      'location': location,
      'entryTime': entryTime,
      'phone': phone
    };
  }
}
