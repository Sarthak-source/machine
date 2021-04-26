import 'package:machineweb/model/models.dart';
import 'package:machineweb/screens/admin/addproduct.dart';

import 'package:machineweb/service/databaseservice.dart';

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:machineweb/screens/admin/userside/profilecreate.dart';

import 'model/models.dart';

class Admin extends StatefulWidget {
  static String route = '\adminroute';
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);
    DataBaseService service = DataBaseService(uid: user.uid);

    print(user.uid);
    print('hellopoppp');

    return Scaffold(
      appBar: AppBar(
        title: Text('cart'),
      ),
      body: StreamBuilder<UserProfileData>(
        stream: service.userprofiledata,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AddProduct();
          } else {
            return NonExistingProfileForm();
          }
        },
      ),
    );
  }
}
