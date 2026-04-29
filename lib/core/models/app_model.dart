class AppModel {
  String? date;
  String? explanation;
  String? mediaType;
  String? title;
  String? url;

  AppModel(
      {
      this.date,
      this.explanation,
      this.mediaType,
      this.title,
      this.url});

  AppModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    explanation = json['explanation'];
    mediaType = json['media_type'];
    title = json['title'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['explanation'] = this.explanation;
    data['media_type'] = this.mediaType;
    data['title'] = this.title;
    data['url'] = this.url;
    return data;
  }
}
