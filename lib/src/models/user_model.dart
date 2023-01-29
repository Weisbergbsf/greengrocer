import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
//import 'package:json_annotation/json_annotation.dart';

//part 'user_model.g.dart';

//@JsonSerializable()
class UserModel {
  String? id;
  String? name;
  String? email;
  String? phone;
  String? cpf;
  String? password;
  String? token;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.cpf,
    this.password,
    this.token,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (id != null) {
      result.addAll({'id': id});
    }
    if (name != null) {
      result.addAll({'fullname': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phone != null) {
      result.addAll({'phone': phone});
    }
    if (cpf != null) {
      result.addAll({'cpf': cpf});
    }
    if (password != null) {
      result.addAll({'password': password});
    }
    if (token != null) {
      result.addAll({'token': token});
    }

    return result;
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['fullname'],
      email: map['email'],
      phone: map['phone'],
      cpf: map['cpf'],
      password: map['password'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, email: $email, phone: $phone, cpf: $cpf, password: $password, token: $token)';
  }
}
