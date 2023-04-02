class FirebaseModel {
  String? problemTitle;
  String? problemDescription;
  String? problemLocation;
  String? date;

  FirebaseModel(
      {this.problemTitle,
        this.problemDescription,
        this.problemLocation,
        this.date});

  FirebaseModel.fromJson(Map<String, dynamic> json) {
    problemTitle = json['problemTitle'];
    problemDescription = json['problemDescription'];
    problemLocation = json['problemLocation'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['problemTitle'] = this.problemTitle;
    data['problemDescription'] = this.problemDescription;
    data['problemLocation'] = this.problemLocation;
    data['date'] = this.date;
    return data;
  }
}
