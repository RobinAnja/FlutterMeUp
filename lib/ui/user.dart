
class User {
   String uid;
   String email;
   String photoUrl;
   String displayName;
   String coordinates;
   String bio;
   String phone;

   User({this.uid, this.email, this.photoUrl, this.displayName, this.coordinates, this.bio,  this.phone});

    Map toMap(User user) {
    var data = Map<String, dynamic>();
    data['uid'] = user.uid;
    data['email'] = user.email;
    data['photoUrl'] = user.photoUrl;
    data['displayName'] = user.displayName;
    data['coordinates'] = user.coordinates;
    data['bio'] = user.bio;
    data['phone'] = user.phone;
    return data;
  }

  User.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['uid'];
    this.email = mapData['email'];
    this.photoUrl = mapData['photoUrl'];
    this.displayName = mapData['displayName'];
    this.coordinates = mapData['coordinates'];
    this.bio = mapData['bio'];
    this.phone = mapData['phone'];
  }
}

