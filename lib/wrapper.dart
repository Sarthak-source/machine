import 'package:machineweb/admin.dart';
import 'package:machineweb/model/models.dart';

import 'package:flutter/material.dart';
import 'package:machineweb/screens/admin/userside/beforesign%20in/auth.dart';
import 'package:provider/provider.dart';

import 'model/models.dart';

class Wrapper extends StatelessWidget {
  static String route = '\wrapperroute';
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    // return either the Home or Authenticate widget
    if (user.uid == null) {
      return Authenticate();
    } else {
      return Admin();
    }
  }
}
