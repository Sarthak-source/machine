class Product {
  final String? productName;
  final List<String>? price;
  final List<String>? features;
  final String? discription;
  final List<String>? image;
  final String? type;
  Product(
      {this.discription,
      this.price,
      this.productName,
      this.image,
      this.type,
      this.features});
}

class AppUser {
  final String? uid;
  AppUser({this.uid});
}

class UserProfileData {
  final String? uid;
  final String? name;
  final String? address;
  final int? districtpin;
  final String? info;
  final int? phoneNumber;
  final String? type;
  final String? imgUrl;

  UserProfileData({
    this.uid,
    this.name,
    this.address,
    this.districtpin,
    this.info,
    this.phoneNumber,
    this.type,
    this.imgUrl,
  });
}
