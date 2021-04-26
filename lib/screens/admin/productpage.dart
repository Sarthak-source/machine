//import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//import 'package:machineweb/model/models.dart';
//import 'package:paginate_firestore/paginate_firestore.dart';

class ProductArgs {
  String? crop;
  ProductArgs({this.crop});
}

class ShowProduct extends StatefulWidget {
  static String route = '\showproductroute';
  @override
  _ShowProductState createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  @override
  Widget build(BuildContext context) {
    double screenWidthSize = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    ProductArgs args =
        ModalRoute.of(context)!.settings.arguments as ProductArgs;

    List<DocumentSnapshot> products = []; // stores fetched products

    bool isLoading = false; // track if products fetching

    bool hasMore = true; // flag for more products available or not

    int documentLimit = 2; // documents to be fetched per request

    DocumentSnapshot?
        lastDocument; // flag for last document from where next 10 records to be fetched

    ScrollController _scrollController = ScrollController();

    print(args.crop);

    getProducts() async {
      if (!hasMore) {
        print('No More Products');
        return;
      }
      if (isLoading) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      QuerySnapshot querySnapshot;
      if (lastDocument == null) {
        querySnapshot = await FirebaseFirestore.instance
            .collection('productData')
            .where('type', isEqualTo: args.crop)
            .limit(documentLimit)
            .get();
      } else {
        querySnapshot = await FirebaseFirestore.instance
            .collection('productData')
            .where('type', isEqualTo: args.crop)
            .startAfterDocument(lastDocument!)
            .limit(documentLimit)
            .get();
        print(1);
      }
      if (querySnapshot.docs.length < documentLimit) {
        hasMore = false;
      }
      lastDocument = querySnapshot.docs[querySnapshot.docs.length - 1];
      products.addAll(querySnapshot.docs);
      setState(
        () {
          isLoading = false;
        },
      );
    }

    _scrollController.addListener(
      () async {
        double maxScroll = _scrollController.position.maxScrollExtent;
        double currentScroll = _scrollController.position.pixels;
        double delta = MediaQuery.of(context).size.height * 0.20;
        if (maxScroll - currentScroll <= delta) {
          await getProducts();
        }
      },
    );

    int _crossAxisCount = 0;

    if (screenWidthSize > 720) {
      _crossAxisCount = 3;
    } else if (screenWidthSize > 520) {
      _crossAxisCount = 2;
    } else {
      _crossAxisCount = 1;
    }

    print(products.length.toString());

    return Container(
      child: Column(
        children: [
          Expanded(
            child: products.length == 0
                ? Center(
                    child: Text(
                      'No Data...',
                      style: TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: EdgeInsets.all(5),
                        title: Text(products[index].data()!['productName']),
                        subtitle: Text('ok'),
                      );
                    },
                  ),
          ),
          isLoading
              ? Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(5),
                  color: Colors.yellowAccent,
                  child: Text(
                    'Loading',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              : Container()
        ],
      ),
    );
  }
}

String o = '''child:PaginateFirestore(
        itemsPerPage: 6,
        itemBuilderType: PaginateBuilderType.gridView,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _crossAxisCount,
        ),
        query: FirebaseFirestore.instance
            .collection('productData')
            .where('type', isEqualTo: args.crop),
        itemBuilder: (index, context, documentSnapshot) {
          Product product = Product(
            productName: documentSnapshot['productName'],
            price: documentSnapshot['price'],
            features: documentSnapshot['features'],
            discription: documentSnapshot['discription'],
            type: documentSnapshot['type'],
            image: documentSnapshot['image'],
          );
          return Padding(
            padding: EdgeInsets.all(12.0),
            child: Container(
              height: height / 10,
              width: screenWidthSize / 2.5,
              child: InkWell(
                onTap: () {
                  print('object');
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  elevation: 8,
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        child: Image.network(product.image[0]),
                      ),
                      Text(product.productName),
                      Row(
                        children: [
                          Text(
                            product.price[0],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),''';
