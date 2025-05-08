class User {
  final int id;
  final String username;
  final String email;
  final String? password;
  final Name? name;
  final Address? address;
  final String? phone;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.password,
    this.name,
    this.address,
    this.phone,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      name: json['name'] != null ? Name.fromJson(json['name']) : null,
      address: json['address'] != null ? Address.fromJson(json['address']) : null,
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      if (password != null) 'password': password,
      if (name != null) 'name': name!.toJson(),
      if (address != null) 'address': address!.toJson(),
      if (phone != null) 'phone': phone,
    };
  }
}

class Name {
  final String firstname;
  final String lastname;

  const Name({
    required this.firstname,
    required this.lastname,
  });

  factory Name.fromJson(Map<String, dynamic> json) {
    return Name(
      firstname: json['firstname'],
      lastname: json['lastname'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstname': firstname,
      'lastname': lastname,
    };
  }

  String get fullName => '$firstname $lastname';
}

class Address {
  final String city;
  final String street;
  final String number;
  final String zipcode;
  final Geolocation? geolocation;

  const Address({
    required this.city,
    required this.street,
    required this.number,
    required this.zipcode,
    this.geolocation,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    // Handle number field which could be an integer or string
    final dynamic numberValue = json['number'];
    final String numberString = numberValue is int 
        ? numberValue.toString() 
        : numberValue as String;

    return Address(
      city: json['city'],
      street: json['street'],
      number: numberString,
      zipcode: json['zipcode'],
      geolocation: json['geolocation'] != null
          ? Geolocation.fromJson(json['geolocation'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'street': street,
      'number': number,
      'zipcode': zipcode,
      if (geolocation != null) 'geolocation': geolocation!.toJson(),
    };
  }

  String get fullAddress => '$number $street, $city, $zipcode';
}

class Geolocation {
  final String lat;
  final String lng;

  const Geolocation({
    required this.lat,
    required this.lng,
  });

  factory Geolocation.fromJson(Map<String, dynamic> json) {
    // Handle possible different key names
    final String latitude = json['lat'] ?? json['latitude'] ?? "";
    final String longitude = json['lng'] ?? json['long'] ?? json['longitude'] ?? "";
    
    return Geolocation(
      lat: latitude,
      lng: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}