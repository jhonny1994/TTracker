import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ttracker/screens/jobs/job_entries_page.dart';
import 'package:ttracker/models/job.dart';
import 'package:ttracker/screens/jobs/edit_job.dart';
import 'package:ttracker/services/database.dart';
import 'package:ttracker/widgets/jobs_list_tile.dart';
import 'package:ttracker/widgets/list_builder.dart';

class JobsList extends StatelessWidget {
  const JobsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('TTracker'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => EditJob.show(context: context, database: database),
            child: const Text('Add',
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: database.jobsStream(),
        builder: (context, snapshot) {
          return ListItemsBuilder<Job>(
            snapshot: snapshot as AsyncSnapshot<List<Job>>,
            itemBuilder: (context, job) => Dismissible(
              key: Key('job-${job.id}'),
              background: Container(color: Colors.red),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) => {},
              child: JobsListTile(
                job: job,
                onTap: () => JobEntries.show(context, job),
              ),
            ),
          );
        },
      ),
    );
  }
}
