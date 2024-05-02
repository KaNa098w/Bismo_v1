class UserInfo {
  String? sub;
  Address? address;
  String? name;
  String? picture;
  String? email;
  String? about;
  bool? emailVerified;
  String? phoneNumber;
  String? preferredUsername;
  String? languageCode;
  String? subscriptionType;
  String? addressCoordinates;
  String? addressApartmentNumber;
  String? addressHomeNumber;
  String? addressType;
  String? givenName;
  String? familyName;

  UserInfo({
    required this.sub,
    required this.address,
    required this.name,
    required this.picture,
    required this.email,
    required this.about,
    required this.emailVerified,
    required this.phoneNumber,
    required this.preferredUsername,
    required this.languageCode,
    required this.subscriptionType,
    required this.addressCoordinates,
    required this.addressType,
    required this.givenName,
    required this.familyName,
    required this.addressApartmentNumber,
    required this.addressHomeNumber,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      sub: json['sub'],
      address: Address.fromJson(json['address']),
      name: json['name'],
      picture: json['picture'],
      email: json['email'],
      about: json['about'],
      emailVerified: json['email_verified'],
      phoneNumber: json['phone_number'],
      preferredUsername: json['preferred_username'],
      languageCode: json['language_code'],
      subscriptionType: json['subscription_type'],
      addressCoordinates: json['address_coordinates'],
      addressType: json['address_type'],
      givenName: json['given_name'],
      familyName: json['family_name'],
      addressApartmentNumber: json['address_apartment_number'],
      addressHomeNumber: json['address_home_number'],
    );
  }

  Map<String, dynamic> toJson() => {
        'sub': sub,
        'address': address!.toJson(),
        'name': name,
        'picture': picture,
        'email': email,
        'about': about,
        'email_verified': emailVerified,
        'phone_number': phoneNumber,
        'preferred_username': preferredUsername,
        'language_code': languageCode,
        'subscription_type': subscriptionType,
        'address_coordinates': addressCoordinates,
        'address_type': addressType,
        'given_name': givenName,
        'family_name': familyName,
        'address_apartment_number': addressApartmentNumber,
        'address_home_number': addressHomeNumber,
      };
}

class Address {
  String? streetAddress;
  String? locality;
  String? region;
  String? postalCode;

  Address({
    required this.streetAddress,
    required this.locality,
    required this.region,
    required this.postalCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      streetAddress: json['street_address'],
      locality: json['locality'],
      region: json['region'],
      postalCode: json['postal_code'],
    );
  }

  Map<String, dynamic> toJson() => {
        'street_address': streetAddress,
        'locality': locality,
        'region': region,
        'postal_code': postalCode,
      };
}
