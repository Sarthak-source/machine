import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:universal_html/html.dart' as html;
import 'package:machineweb/model/models.dart';
import 'package:machineweb/service/databaseservice.dart';
import 'package:machineweb/shared/style.dart';

import 'package:provider/provider.dart';

class NonExistingProfileForm extends StatefulWidget {
  @override
  _NonExistingProfileFormState createState() => _NonExistingProfileFormState();
}

class _NonExistingProfileFormState extends State<NonExistingProfileForm> {
  final _formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  String netimg =
      'https://www.psychowave.org/wp-content/uploads/2015/06/cd1-960x960.jpg';

  String? _name;
  String? _address;
  int? _districtpin;
  String? _phoneNumber;
  String? _info;
  String? _imageUrl;

  int currentStep = 0;
  bool complete = false;

  goTo(int step) {
    setState(() => currentStep = step);
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  stepfunc(Widget one, Widget two, Widget three, Widget four, Widget five,
      Widget six, Widget seven, BuildContext context) {
    List<Step> steps = [
      Step(
        state: StepState.indexed,
        title: Text(
          'add image',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: one,
      ),
      Step(
        state: StepState.indexed,
        title: Text(
          'add name',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: two,
      ),
      Step(
        state: StepState.indexed,
        title: Text(
          'add an address',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: three,
      ),
      Step(
        state: StepState.indexed,
        title: Text(
          'select pin code',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: four,
      ),
      Step(
        state: StepState.indexed,
        title: Text(
          'add phone number',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: five,
      ),
      Step(
        state: StepState.indexed,
        title: Text(
          'add info',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: six,
      ),
      Step(
        state: StepState.indexed,
        title: Text(
          'press the button',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: seven,
      ),
    ];
    return steps;
  }

  String name = '';
  String? error;
  Uint8List? data;

  pickImage({String? uid, String? collection}) {
    final html.InputElement input =
        html.document.createElement('input') as html.InputElement;
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen(
      (e) {
        if (input.files!.isEmpty) return;
        final reader = html.FileReader();
        reader.readAsDataUrl(input.files![0]);
        reader.onError.listen((err) => setState(() {
              error = err.toString();
            }));
        reader.onLoad.first.then(
          (res) async {
            final encoded = reader.result as String;
            // remove data:image/*;base64 preambule
            final stripped =
                encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

            setState(
              () {
                name = input.files![0].name;
                data = base64.decode(stripped);
                error = null;
              },
            );
            var fb = FirebaseStorage.instance.ref().child(collection!);

            String now = DateTime.now().toString();

            UploadTask val = fb
                .child(input.files![0].toString())
                .child(uid!)
                .child(now)
                .putBlob(input.files![0]);
            TaskSnapshot i = await val;

            _imageUrl = await i.ref.getDownloadURL();

            print('pic picked');
          },
        );
      },
    );

    input.click();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    one() {
      return Column(
        children: [
          Center(
            child: error != null
                ? Text(error!)
                : data != null
                    ? Image.memory(data!)
                    : Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
          ),
          SizedBox(height: 10),
          TextButton.icon(
            onPressed: () {
              pickImage(uid: user.uid, collection: 'profileData');
            },
            icon: Icon(
              Icons.camera,
              color: Colors.black,
            ),
            label:
                Text('add image', style: Theme.of(context).textTheme.bodyText2),
          ),
        ],
      );
    }

    two() {
      return Form(
        key: _formKey[1],
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText2,
          initialValue: '',
          decoration: textInputDecoration.copyWith(labelText: 'full name'),
          validator: (val) =>
              val!.isEmpty ? 'Please enter your full name' : null,
          onChanged: (val) => setState(() => _name = val),
        ),
      );
    }

    tree() {
      return Form(
        key: _formKey[2],
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText2,
          initialValue: '',
          decoration: textInputDecoration.copyWith(labelText: 'address'),
          validator: (val) => val!.isEmpty ? 'Please enter address' : null,
          onChanged: (val) => setState(() => _address = val),
        ),
      );
    }

    four() {
      return Form(
        key: _formKey[3],
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText2,
          initialValue: '',
          decoration: textInputDecoration.copyWith(labelText: 'pin code'),
          validator: (val) => val!.isEmpty ? 'Please enter pin code' : null,
          onChanged: (val) => setState(() => _districtpin = int.parse(val)),
        ),
      );
    }

    five() {
      return Form(
        key: _formKey[4],
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText2,
          keyboardType: TextInputType.phone,
          initialValue: '',
          decoration: textInputDecoration.copyWith(labelText: 'phone number'),
          validator: (val) =>
              val!.length != 10 ? 'Please enter phone number' : null,
          onChanged: (val) => setState(() => _phoneNumber = val),
        ),
      );
    }

    six() {
      return Form(
        key: _formKey[5],
        child: TextFormField(
          maxLines: 4,
          style: Theme.of(context).textTheme.bodyText2,
          initialValue: '',
          decoration: textInputDecoration.copyWith(labelText: 'genaral info'),
          validator: (val) => val!.isEmpty ? 'Please enter genaral info' : null,
          onChanged: (val) => setState(() => _info = val),
        ),
      );
    }

    seven() {
      return ElevatedButton(
        child: Text('add profile', style: Theme.of(context).textTheme.button),
        onPressed: () async {
          await DataBaseService(uid: user.uid).updateUserData(
            name: _name,
            address: _address,
            districtpin: _districtpin,
            info: _info,
            phoneNumber: _phoneNumber,
          );
          DataBaseService(uid: user.uid).updateField(
              collection: 'profileData', field: 'imgUrl', value: _imageUrl);
          Navigator.pop(context);
        },
      );
    }

    next() {
      if (_formKey[currentStep].currentState!.validate() ||
          (currentStep == 0)) {
        currentStep + 1 !=
                stepfunc(one(), two(), tree(), four(), five(), six(), seven(),
                        context)
                    .length
            ? goTo(currentStep + 1)
            : setState(() => complete = true);
      }
    }

    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: (width + 50) / 8, vertical: 50),
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Container(
          height: 2000,
          child: Column(
            children: <Widget>[
              complete
                  ? Expanded(
                      child: Center(
                        child: AlertDialog(
                          title: new Text("Profile Created"),
                          content: new Text(
                            "Tada!",
                          ),
                          actions: <Widget>[
                            new TextButton(
                              child: new Text(
                                "Close",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              onPressed: () {
                                setState(() => complete = false);
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: Stepper(
                        controlsBuilder: (context,
                            {onStepCancel, onStepContinue}) {
                          if (currentStep != 6) {
                            return Row(
                              children: <Widget>[
                                TextButton(
                                  onPressed: onStepContinue,
                                  child: Text(
                                    'next',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: onStepCancel,
                                  child: Text(
                                    'previous',
                                    style: TextStyle(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Container();
                          }
                        },
                        type: StepperType.vertical,
                        steps: stepfunc(one(), two(), tree(), four(), five(),
                            six(), seven(), context),
                        currentStep: currentStep,
                        onStepContinue: next,
                        onStepTapped: (step) => goTo(step),
                        onStepCancel: cancel,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
