import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceModel {
  final String lat = '27.442';
  final String lng = '80.339';
  String? id;
  final String? name;
  final String? email;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final bool? isPresent;
  final String? latitude;
  final String? longitude;
  final Timestamp? createAt;
  AttendanceModel({
    this.id,
    this.name,
    this.email,
    this.checkIn,
    this.checkOut,
    this.isPresent,
    this.latitude,
    this.longitude,
    this.createAt,
  });
  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (checkIn != null) {
      result.addAll({'checkIn': checkIn!.millisecondsSinceEpoch});
    }
    if (checkOut != null) {
      result.addAll({'checkOut': checkOut!.millisecondsSinceEpoch});
    }
    if (isPresent != null) {
      result.addAll({'isPresent': isPresent});
    }
    if (latitude != null) {
      result.addAll({'latitude': latitude});
    }
    if (longitude != null) {
      result.addAll({'longitude': longitude});
    }
    if (createAt != null) {
      result.addAll({'createAt': createAt!});
    }
    return result;
  }

  factory AttendanceModel.fromMap(Map<String, dynamic> map) {
    return AttendanceModel(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      checkIn: map['checkIn'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['checkIn'])
          : null,
      checkOut: map['checkOut'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['checkOut'])
          : null,
      isPresent: map['isPresent'] ?? false,
      latitude: map['latitude'],
      longitude: map['longitude'],
      createAt: map['createAt'],
    );
  }
}
