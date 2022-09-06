import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ttracker/models/job.dart';
import 'package:ttracker/services/auth_provider.dart';
import 'package:ttracker/services/database.dart';

class EditJob extends StatefulWidget {
  final AuthBase auth;

  final Database database;
  final Job? job;
  const EditJob(
      {Key? key, required this.database, required this.auth, this.job})
      : super(key: key);

  @override
  State<EditJob> createState() => _EditJobState();

  static Future<void> show(
      {required BuildContext context,
      required Database database,
      Job? job}) async {
    final auth = Provider.of<AuthBase>(context, listen: false);
    await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => EditJob(
                auth: auth,
                database: database,
                job: job,
              ),
          fullscreenDialog: true),
    );
  }
}

class _EditJobState extends State<EditJob> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  int? _rate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: _submit,
              child: const Text(
                'save',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ))
        ],
        elevation: 2,
        title: Text(widget.job != null ? 'Edit job' : 'New job'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: _name,
                    onSaved: (value) => _name = value!.trim(),
                    validator: (value) =>
                        value!.isNotEmpty ? null : 'Name can\'t be empty.',
                    decoration: const InputDecoration(
                      labelText: 'Job name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    initialValue: _rate != null ? _rate.toString() : null,
                    validator: (value) =>
                        value!.isNotEmpty ? null : 'Rate can\'t be empty.',
                    onSaved: (value) => _rate = int.tryParse(value!) ?? 0,
                    decoration: const InputDecoration(
                      labelText: 'Rate per hour',
                      border: OutlineInputBorder(),
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _rate = widget.job!.rate;
    }
  }

  _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final names = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          names.remove(widget.job!.name);
        }
        if (names.contains(_name)) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            title: 'Oops...',
            text: 'Name already used.',
          );
        } else {
          final id = widget.job != null
              ? widget.job!.id
              : DateTime.now().toIso8601String();
          final job = Job(_name!, _rate!, id);
          await widget.database.setJob(job).then((value) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.success,
            ).then((value) => Navigator.of(context).pop());
          });
        }
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

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
