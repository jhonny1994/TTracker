import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ttracker/screens/jobs/entry_list_item.dart';
import 'package:ttracker/screens/jobs/entry_page.dart';
import 'package:ttracker/screens/jobs/edit_job.dart';
import 'package:ttracker/widgets/list_builder.dart';
import 'package:ttracker/models/entry.dart';
import 'package:ttracker/models/job.dart';
import 'package:ttracker/services/database.dart';

class JobEntries extends StatelessWidget {
  const JobEntries({Key? key, required this.database, required this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntries(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(job.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final job = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                elevation: 2.0,
                title: Text(job!.name),
                actions: <Widget>[
                  TextButton(
                    child: const Text(
                      'Edit',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                    onPressed: () => EditJob.show(
                        job: job, context: context, database: database),
                  ),
                ],
              ),
              body: _buildContent(context, job),
              floatingActionButton: FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () => EntryPage.show(
                    context: context, database: database, job: job),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
