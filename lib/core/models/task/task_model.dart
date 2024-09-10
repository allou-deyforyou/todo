import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

import 'package:todo/core/assets/_assets.dart';
import 'package:todo/core/models/_models.dart';
import 'package:todo/features/widgets/_widgets.dart';

part 'task_model.g.dart';
part 'task_model.w.dart';

@Collection(inheritance: false)
class Task extends Equatable {
  const Task({
    this.id,
    this.done = false,
    required this.title,
    required this.description,
    required this.priority,
    required this.deadline,
    required this.createdAt,
    required this.updatedAt,
  });

  static const String schema = 'task';

  static const String idKey = 'id';
  static const String doneKey = 'done';
  static const String titleKey = 'title';
  static const String descriptionKey = 'description';
  static const String priorityKey = 'priority';
  static const String deadlineKey = 'deadline';
  static const String createdAtKey = 'created_at';
  static const String updatedAtKey = 'updated_at';

  final Id? id;
  final bool done;
  final String title;
  final String? description;
  @Enumerated(EnumType.name)
  final Priority priority;
  final DateTime deadline;
  final DateTime createdAt;
  final DateTime updatedAt;

  @ignore
  @override
  List<Object?> get props {
    return [
      id,
      done,
      title,
      description,
      priority,
      deadline,
      createdAt,
      updatedAt,
    ];
  }

  Task copyWith({
    int? id,
    bool? done,
    String? title,
    String? description,
    Priority? priority,
    DateTime? deadline,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      done: done ?? this.done,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      deadline: deadline ?? this.deadline,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Task clone() {
    return copyWith(
      id: id,
      done: done,
      title: title,
      description: description,
      priority: priority,
      deadline: deadline,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  static Task? fromMap(dynamic data) {
    if (data == null) return null;

    return Task(
      id: data[idKey],
      done: data[doneKey],
      title: data[titleKey],
      description: data[descriptionKey],
      priority: data[priorityKey],
      deadline: data[deadlineKey],
      createdAt: data[createdAtKey],
      updatedAt: data[updatedAtKey],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      idKey: id,
      doneKey: done,
      titleKey: title,
      descriptionKey: description,
      priorityKey: priority,
      deadlineKey: deadline,
      createdAtKey: createdAt,
      updatedAtKey: updatedAt,
    }..removeWhere((key, value) => value == null);
  }

  static Task fromJson(String source) {
    return fromMap(jsonDecode(source))!;
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  String toString() {
    return "$runtimeType(${toMap()})";
  }
}
