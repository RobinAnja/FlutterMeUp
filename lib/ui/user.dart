
class User {
   String uid;
   String email;
   String photoUrl;
   String displayName;
   double longitude;
   double latitude;

   String bio;
   String phone;

   User({this.uid, this.email, this.photoUrl, this.displayName, this.latitude, this.longitude, this.bio,  this.phone});

    Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['photoUrl'] = user.photoUrl;
    data['displayName'] = user.displayName;
    data['longitude'] = user.longitude;
    data['latitude'] = user.latitude;

    data['bio'] = user.bio;
    data['phone'] = user.phone;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.latitude = mapData['latitude'];
    this.longitude = mapData['longitude'];
    this.bio = mapData['bio'];
    this.phone = mapData['phone'];
  }
}

