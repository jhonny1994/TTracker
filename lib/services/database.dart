import 'package:ttracker/models/entry.dart';
import 'package:ttracker/models/job.dart';
import 'package:ttracker/services/firestore_service.dart';
import 'package:ttracker/services/paths.dart';

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

abstract class Database {
  Future<void> deleteEntry(Entry entry);

  Future<void> deleteJob(Job job);

  Stream<List<Entry>> entriesStream({Job job});

  Stream<List<Job>> jobsStream();

  Stream<Job> jobStream(jobId);

  Future<void> setEntry(Entry entry);

  Future<void> setJob(Job job);
}

class FirestoreDatabase implements Database {
  final String uid;

  final _service = FirestoreService.instance;

  FirestoreDatabase({required this.uid});

  @override
  Future<void> deleteEntry(Entry entry) => _service.deleteData(
        path: Paths.entry(uid, entry.id),
      );

  @override
  Future<void> deleteJob(Job job) async {
    final allEntries = await entriesStream(job: job).first;
    for (Entry entry in allEntries) {
      if (entry.jobId == job.id) {
        await deleteEntry(entry);
      }
    }
    await _service.deleteData(path: Paths.job(uid, job.id));
  }

  @override
  Stream<List<Entry>> entriesStream({Job? job}) =>
      _service.collectionStream<Entry>(
        path: Paths.entries(uid),
        queryBuilder: job != null
            ? (query) => query.where('jobId', isEqualTo: job.id)
            : null,
        builder: (data, documentID) => Entry.fromMap(data, documentID),
        sort: (lhs, rhs) => rhs.start.compareTo(lhs.start),
      );

  @override
  Stream<List<Job>> jobsStream() => _service.collectionStream(
        path: Paths.jobs(uid),
        builder: (data, documentId) => Job.fromMap(data, documentId),
      );

  @override
  Stream<Job> jobStream(jobId) => _service.documentStream(
      path: Paths.job(uid, jobId),
      builder: (data, documentId) => Job.fromMap(data, documentId));

  @override
  Future<void> setEntry(Entry entry) => _service.setData(
        path: Paths.entry(uid, entry.id),
        data: entry.toMap(),
      );

  @override
  Future<void> setJob(Job job) => _service.setData(
        path: Paths.job(uid, job.id),
        data: job.toMap(),
      );
}
