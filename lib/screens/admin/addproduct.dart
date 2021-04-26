import 'dart:async';

import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:machineweb/service/databaseservice.dart';
import 'package:machineweb/shared/style.dart';

import 'dart:typed_data';

import 'package:universal_html/html.dart' as html;
import 'package:machineweb/model/models.dart';

import 'package:provider/provider.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  final _formKey = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  String _productname = '';
  String? _imageUrl;
  List<String?> _listImageUrl = [];
  String? _discription;
  String? _selectedcrop;

  List<String> crops = ['coffee', 'pepper', 'areca'];

  String? error;
  Uint8List? data;

  List<html.File>? _files = [];

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

  late TextEditingController _priceController;
  late TextEditingController _featureController;
  static List<String?> priceList = [null];
  static List<String?> featureList = [null];

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
    _featureController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _featureController.dispose();
    super.dispose();
  }

  stepfunc(Widget one, Widget two, Widget three, Widget four, Widget five,
      Widget six, BuildContext context) {
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
          'product name',
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
          'add price and features',
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
          'add price and features',
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
          'add price and features',
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
          'add price and features',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.normal,
          ),
        ),
        content: six,
      ),
    ];
    return steps;
  }

  pickImage({String? uid, String? collection}) {
    print('pick img');
    final html.InputElement input =
        html.document.createElement('input') as html.InputElement;
    input
      ..type = 'file'
      ..multiple = true
      ..accept = 'image/*';

    input.onChange.listen(
      (e) {
        if (input.files!.isEmpty) return;
        final reader = html.FileReader();

        setState(
          () {
            _files = input.files;
          },
        );

        input.files!.map(
          (file) {
            reader.readAsDataUrl(file);

            reader.onError.listen(
              (err) => setState(
                () {
                  error = err.toString();
                },
              ),
            );
          },
        );
      },
    );

    input.click();
  }

  Future<List<int>> fileAsBytes(html.File _file, {String? collection}) async {
    final Completer<List<int>> bytesFile = Completer<List<int>>();
    final html.FileReader reader = html.FileReader();
    reader.onLoad.listen(
        (event) => bytesFile.complete(reader.result as FutureOr<List<int>>?));
    reader.readAsArrayBuffer(_file);

    reader.onLoad.first.then(
      (res) async {
        var fb = FirebaseStorage.instance.ref().child(collection!);

        String now = DateTime.now().toString();

        UploadTask val =
            fb.child(_file.name.toString()).child(now).putBlob(_file);
        TaskSnapshot i = await val;

        _imageUrl = await i.ref.getDownloadURL();
        print(_imageUrl);
        _listImageUrl.add(_imageUrl);
        print(_listImageUrl);
      },
    );

    return await bytesFile.future;
  }

  list() {
    return Container(
      height: 200,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: _files!.length,
          itemBuilder: (BuildContext context, int index) =>
              FutureBuilder<List<int>>(
            future: fileAsBytes(_files![index], collection: 'productData'),
            builder: (context, snapshot) => snapshot.hasData
                ? Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 200,
                        child: Image.memory(snapshot.data as Uint8List),
                      ),
                    ),
                  )
                : Container(
                    height: 200,
                    child: CircularProgressIndicator(),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser>(context);

    zero() {
      return Form(
        key: _formKey[0],
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            list(),
            SizedBox(height: 10),
            TextButton.icon(
              onPressed: () {
                pickImage(uid: user.uid, collection: 'productData');
              },
              icon: Icon(
                Icons.camera,
                color: Colors.black,
              ),
              label: Text('add image',
                  style: Theme.of(context).textTheme.bodyText2),
            ),
          ],
        ),
      );
    }

    one() {
      return Form(
        key: _formKey[1],
        child: TextFormField(
          style: Theme.of(context).textTheme.bodyText2,
          initialValue: '',
          decoration: textInputDecoration.copyWith(labelText: 'product name'),
          validator: (val) => val!.isEmpty ? 'Please enter product name' : null,
          onChanged: (val) => setState(() => _productname = val),
        ),
      );
    }

    two() {
      return Column(
        children: [
          Form(
            key: _formKey[2],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._getWigets(),
                  ..._getWigetsTwo(),
                ],
              ),
            ),
          ),
        ],
      );
    }

    three() {
      return Form(
        key: _formKey[3],
        child: Column(
          children: [
            DropdownButtonHideUnderline(
              child: DropdownButtonFormField<String>(
                value: crops[0],
                decoration: textInputDecoration.copyWith(labelText: 'crop'),
                items: crops.map((district) {
                  return DropdownMenuItem(
                    value: district,
                    child: Text('$district',
                        style: Theme.of(context).textTheme.bodyText2),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _selectedcrop = val),
                validator: (val) => val!.isEmpty ? 'Please enter a crop' : null,
              ),
            ),
          ],
        ),
      );
    }

    four() {
      return Form(
        key: _formKey[4],
        child: TextFormField(
          maxLines: 4,
          style: Theme.of(context).textTheme.bodyText2,
          initialValue: '',
          decoration: textInputDecoration.copyWith(labelText: 'discription'),
          validator: (val) => val!.isEmpty ? 'Please enter discription' : null,
          onChanged: (val) => setState(() => _discription = val),
        ),
      );
    }

    five() {
      return ElevatedButton(
        child: Text('add product', style: Theme.of(context).textTheme.button),
        onPressed: () async {
          print('wtf');
          await DataBaseService(uid: user.uid).updateProduct(
            productName: _productname,
            price: priceList,
            features: featureList,
            discription: _discription,
            type: _selectedcrop,
            image: _listImageUrl,
          );

          Navigator.pop(context);
        },
      );
    }

    next() {
      if (_formKey[currentStep].currentState!.validate() ||
          (_files!.length != 0)) {
        currentStep + 1 !=
                stepfunc(zero(), one(), two(), three(), four(), five(), context)
                    .length
            ? goTo(currentStep + 1)
            : setState(() => complete = true);
      }
    }

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: (width + 50) / 20, vertical: 50),
      child: SingleChildScrollView(
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Container(
            height: height + 10,
            child: Column(
              children: [
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
                            if (currentStep != 5) {
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
                          steps: stepfunc(zero(), one(), two(), three(), four(),
                              five(), context),
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
      ),
    );
  }

  List<Widget> _getWigets() {
    List<Widget> widgetTextFields = [];

    for (int i = 0; i < priceList.length; i++) {
      widgetTextFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    PriceTextFields(index: i),
                  ],
                ),
              ),

              SizedBox(
                width: 16,
              ),
              //we need add button at last friends row
              Container(
                height: 30,
                width: 30,
              )
            ],
          ),
        ),
      );
    }
    return widgetTextFields;
  }

  List<Widget> _getWigetsTwo() {
    List<Widget> widgetTextFields = [];

    for (int i = 0; i < featureList.length; i++) {
      widgetTextFields.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [FeatureTextFields(index: i)],
                ),
              ),
              SizedBox(
                width: 16,
              ),
              //we need add button at last friends row
              _addRemoveButton(i == priceList.length - 1, i),
            ],
          ),
        ),
      );
    }
    return widgetTextFields;
  }

  /// add / remove button
  Widget _addRemoveButton(bool add, int index) {
    return InkWell(
      onTap: () {
        if (add) {
          //add new text-fields at the top of all friends textfields
          priceList.insert(0, null);
          print(priceList);
          //featureList.insert(0, null);
          //print(featureList);
        } else
          priceList.removeAt(index);
        //featureList.removeAt(index);
        setState(() {});

        if (add) {
          //add new text-fields at the top of all friends textfields
          //priceList.insert(0, null);
          //print(priceList);
          featureList.insert(0, null);
          print(featureList);
        } else
          // priceList.removeAt(index);
          featureList.removeAt(index);
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.black : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class PriceTextFields extends StatefulWidget {
  final int? index;
  PriceTextFields({this.index});
  @override
  _PriceTextFieldsState createState() => _PriceTextFieldsState();
}

class _PriceTextFieldsState extends State<PriceTextFields> {
  TextEditingController? _priceController;
  //TextEditingController _featureController;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController();
    //_featureController = TextEditingController();
  }

  @override
  void dispose() {
    _priceController!.dispose();
    // _featureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        _priceController!.text =
            _AddProductState.priceList[widget.index!] ?? '';
        //_featureController.text =
        // _AddProductState.featureList[widget.index] ?? '';
      },
    );

    return Container(
      width: 250,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text('product price'),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                onChanged: (v) => _AddProductState.priceList[widget.index!] = v,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: textInputDecoration.copyWith(
                    hintText: 'product price',
                    prefixIcon: Icon(Icons.money, color: Colors.black)),
                validator: (v) {
                  if (v!.trim().isEmpty) return 'Please enter something';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FeatureTextFields extends StatefulWidget {
  final int? index;
  FeatureTextFields({this.index});
  @override
  _FeatureTextFieldsState createState() => _FeatureTextFieldsState();
}

class _FeatureTextFieldsState extends State<FeatureTextFields> {
  TextEditingController? _featureController;

  @override
  void initState() {
    super.initState();

    _featureController = TextEditingController();
  }

  @override
  void dispose() {
    _featureController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback(
      (timeStamp) {
        //_priceController.text = _AddProductState.priceList[widget.index] ?? '';
        _featureController!.text =
            _AddProductState.featureList[widget.index!] ?? '';
      },
    );

    return Container(
      width: 250,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text('product features'),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLines: 5,
                controller: _featureController,
                onChanged: (k) =>
                    _AddProductState.featureList[widget.index!] = k,
                style: Theme.of(context).textTheme.bodyText2,
                decoration: textInputDecoration.copyWith(
                    hintText: 'product features',
                    prefixIcon:
                        Icon(Icons.featured_play_list, color: Colors.black)),
                validator: (v) {
                  if (v!.trim().isEmpty) return 'Please enter something';
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
