class FirebaseModel {
  String? problemTitle;
  String? problemDecription;
  String? problemLocation;
  String? date;

  FirebaseModel(
      {this.problemTitle,
        this.problemDecription,
        this.problemLocation,
        this.date});

  FirebaseModel.fromJson(Map<String, dynamic> json) {
    problemTitle = json['problemTitle'];
    problemDecription = json['problemDecription'];
    problemLocation = json['problemLocation'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['problemTitle'] = this.problemTitle;
    data['problemDecription'] = this.problemDecription;
    data['problemLocation'] = this.problemLocation;
    data['date'] = this.date;
    return data;
  }
}
