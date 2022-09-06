import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ttracker/services/auth_provider.dart';
import 'package:ttracker/widgets/avatar.dart';

class Account extends StatelessWidget {
  const Account({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final user = auth.currentUser;
    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Avatar(
                photoUrl: user!.photoURL,
                radius: 50,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        title: user.displayName != null
            ? Text('${user.displayName}\'s account')
            : const Text('Account'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              QuickAlert.show(
                  context: context,
                  type: QuickAlertType.confirm,
                  text: 'Do you want to logout?',
                  confirmBtnText: 'Yes',
                  cancelBtnText: 'No',
                  confirmBtnColor: Colors.green,
                  onCancelBtnTap: () => Navigator.of(context).pop(),
                  onConfirmBtnTap: () => Auth()
                      .signOut()
                      .then((value) => Navigator.of(context).pop()));
            },
            child: const Text('Logout',
                style: TextStyle(fontSize: 18.0, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
