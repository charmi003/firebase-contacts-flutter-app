class Contact{
  final String? id;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String address;
  final String photoUrl;

  Contact(
    {
      this.id,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.email,
      required this.address,
      required this.photoUrl
    }
  );


  Contact copy({
    String? id,
    String? firstName,
    String? lastName,
    String? phone,
    String? email,
    String? address,
    String? photoUrl
  }){
    return Contact(
      id:id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      photoUrl: photoUrl ?? this.photoUrl
    );
  }

  Map<String,Object?> toJson() => {
    // 'id':id,
    'firstName':firstName,
    'lastName':lastName,
    'phone':phone,
    'email':email,
    'address':address,
    'photoUrl':photoUrl
  };


  static Contact fromJson(Map<String,Object?> json) => Contact(
    id: json['id'] as String?,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    phone: json['phone'] as String,
    email: json['email'] as String,
    address: json['address'] as String,
    photoUrl: json['photoUrl'] as String
  );

}