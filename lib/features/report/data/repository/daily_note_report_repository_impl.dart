import 'dart:async';

import 'package:zlux_pos/features/report/data/datasource/daily_report_note_local_datasource.dart';
import 'package:zlux_pos/features/report/data/datasource/daily_report_note_remote_datasource.dart';
import 'package:zlux_pos/features/report/data/models/daily_report_note_model.dart';
import 'package:zlux_pos/features/report/domain/entities/daily_report_note_entity.dart';
import 'package:zlux_pos/features/report/domain/repository/daily_report_note_repository.dart';

class DailyReportNoteRepositoryImpl implements DailyReportNoteRepository {
  final DailyReportNoteLocalDatasource _local;
  final DailyReportNoteRemoteDatasource _remote;
  final String Function() _ownerId;

  DailyReportNoteRepositoryImpl({
    required DailyReportNoteLocalDatasource local,
    required DailyReportNoteRemoteDatasource remote,
    required String Function() ownerId,
  })  : _local = local,
        _remote = remote,
        _ownerId = ownerId;

  @override
  Stream<DailyReportNoteEntity?> watchNoteByDate(DateTime date) =>
      _local.watchNoteByDate(_ownerId(), date);

  @override
  Future<DailyReportNoteEntity> saveNote({
    required DateTime date,
    required String note,
  }) async {
    final ownerId = _ownerId();

    final entity = await _local.saveNote(
      ownerId: ownerId,
      date: date,
      note: note,
    );

    unawaited(_pushOne(ownerId, entity));

    return entity;
  }

  @override
  Future<void> syncPending() async {
    final ownerId = _ownerId();
    final pending = await _local.getUnsynced(ownerId);
    for (final entity in pending) {
      await _pushOne(ownerId, entity);
    }
  }

  @override
  Future<void> pullAll() async {
    final ownerId = _ownerId();
    final remoteNotes = await _remote.fetchNotes(ownerId);
    await _local.pullAll(ownerId, remoteNotes);
  }

  Future<void> _pushOne(String ownerId, DailyReportNoteEntity entity) async {
    try {
      await _remote.pushNote(
        entity.id,
        ownerId,
        DailyReportNoteModel(
          id: entity.id,
          date: entity.date,
          note: entity.note,
          updatedAt: entity.updatedAt,
        ),
      );
      await _local.markSynced(entity.id);
    } catch (_) {}
  }
}
