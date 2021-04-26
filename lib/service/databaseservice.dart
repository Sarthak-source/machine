import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:machineweb/model/models.dart';

class DataBaseService {
  final uid;
  DataBaseService({this.uid});

  final CollectionReference profile =
      FirebaseFirestore.instance.collection('profileData');

  Future<void> updateUserData({
    String? name,
    String? address,
    int? districtpin,
    String? phoneNumber,
    String? info,
  }) async {
    return await profile.doc(uid).set(
      {
        'uid': uid,
        'name': name,
        'address': address,
        'districtpin': districtpin,
        'info': info,
        'phoneNumber': phoneNumber,
        'type': 'vistor',
      },
      SetOptions(
        merge: true,
      ),
    );
  }

  Future<void> updateProduct({
    String? productName,
    List<String?>? price,
    List<String?>? features,
    List<String?>? image,
    String? discription,
    String? type,
  }) async {
    await FirebaseFirestore.instance.collection('productData').add(
      {
        'uid': uid,
        'productName': productName,
        'price': price,
        'features': features,
        'discription': discription,
        'type': type,
        'image': image,
      },
    );
  }

  Future<void> updateField(
      {required String collection, String? field, var value}) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(uid)
        .update(
      {
        field!: value,
      },
    );
  }

  UserProfileData _userProfileDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserProfileData(
      uid: snapshot['uid'],
      name: snapshot['name'] ?? '',
      districtpin: snapshot['districtpin'] ?? '' as int?,
      phoneNumber: snapshot['phoneNumber'] ?? null,
      info: snapshot['info'] ?? '',
      imgUrl: snapshot['imgUrl'],
      address: snapshot['address'],
      type: snapshot['type'] ?? 'vistor',
    );
  }

  Stream<UserProfileData> get userprofiledata {
    return profile.doc(uid).snapshots().map(_userProfileDataFromSnapshot);
  }
}
