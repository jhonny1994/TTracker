import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ttracker/widgets/date_time_picker.dart';
import 'package:ttracker/widgets/format.dart';
import 'package:ttracker/models/entry.dart';
import 'package:ttracker/models/job.dart';
import 'package:ttracker/services/database.dart';

class EntryPage extends StatefulWidget {
  final Database database;

  final Entry? entry;
  final Job job;
  const EntryPage(
      {Key? key, required this.database, required this.job, this.entry})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryPageState();

  static Future<void> show(
      {required BuildContext context,
      required Database database,
      required Job job,
      Entry? entry}) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            EntryPage(database: database, job: job, entry: entry),
        fullscreenDialog: true,
      ),
    );
  }
}

class _EntryPageState extends State<EntryPage> {
  String? _comment;
  DateTime? _endDate;
  TimeOfDay? _endTime;
  DateTime? _startDate;
  TimeOfDay? _startTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job.name),
        actions: <Widget>[
          TextButton(
            child: Text(
              widget.entry != null ? 'Update' : 'Create',
              style: const TextStyle(fontSize: 18.0, color: Colors.white),
            ),
            onPressed: () => _setEntryAndDismiss(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildStartDate(),
              _buildEndDate(),
              const SizedBox(height: 8.0),
              _buildDuration(),
              const SizedBox(height: 8.0),
              _buildComment(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final start = widget.entry?.start ?? DateTime.now();
    _startDate = DateTime(start.year, start.month, start.day);
    _startTime = TimeOfDay.fromDateTime(start);

    final end = widget.entry?.end ?? DateTime.now();
    _endDate = DateTime(end.year, end.month, end.day);
    _endTime = TimeOfDay.fromDateTime(end);

    _comment = widget.entry?.comment ?? '';
  }

  Widget _buildComment() {
    return TextField(
      keyboardType: TextInputType.text,
      maxLength: 50,
      controller: TextEditingController(text: _comment),
      decoration: const InputDecoration(
        labelText: 'Comment',
        labelStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
      ),
      style: const TextStyle(fontSize: 20.0, color: Colors.black),
      maxLines: null,
      onChanged: (comment) => _comment = comment,
    );
  }

  Widget _buildDuration() {
    final currentEntry = _entryFromState();
    final durationFormatted = Format.hours(currentEntry.durationInHours);
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          'Duration: $durationFormatted',
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildEndDate() {
    return DateTimePicker(
      labelText: 'End',
      selectedDate: _endDate!,
      selectedTime: _endTime!,
      selectDate: (date) => setState(() => _endDate = date),
      selectTime: (time) => setState(() => _endTime = time),
    );
  }

  Widget _buildStartDate() {
    return DateTimePicker(
      labelText: 'Start',
      selectedDate: _startDate!,
      selectedTime: _startTime!,
      selectDate: (date) => setState(() => _startDate = date),
      selectTime: (time) => setState(() => _startTime = time),
    );
  }

  Entry _entryFromState() {
    final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day,
        _startTime!.hour, _startTime!.minute);
    final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day,
        _endTime!.hour, _endTime!.minute);
    final id = widget.entry?.id ?? documentIdFromCurrentDate();
    return Entry(
      id: id,
      jobId: widget.job.id,
      start: start,
      end: end,
      comment: _comment!,
    );
  }

  Future<void> _setEntryAndDismiss(BuildContext context) async {
    try {
      final entry = _entryFromState();
      await widget.database.setEntry(entry);
      Future.delayed(Duration.zero, (() => Navigator.of(context).pop()));
    } on FirebaseException catch (e) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: e.message,
      );
    }
  }
}
