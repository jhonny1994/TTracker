import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ttracker/models/job.dart';
import 'package:ttracker/services/database.dart';

class JobsListTile extends StatelessWidget {
  final Job job;
  final VoidCallback onTap;
  const JobsListTile({
    Key? key,
    required this.job,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Dismissible(
      background: Container(color: Colors.red),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) async {
        try {
          await database.deleteJob(job);
        } on FirebaseException catch (e) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: e.message,
          );
        }
      },
      key: Key('job-${job.id}'),
      child: ListTile(
        title: Text(job.name),
        onTap: onTap,
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
