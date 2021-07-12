class FetchProject {
  final String id;
  final String firstname;
  final String lastname;
  final String inspectionstatus;
  final String projecttype;
  final String date;
  FetchProject(
      {this.id,
      this.firstname,
      this.lastname,
      this.inspectionstatus,
      this.projecttype,
      this.date});
  factory FetchProject.fromJson(Map<String, dynamic> json) {
    return new FetchProject(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        inspectionstatus: json['inspectionstatus'],
        projecttype: json['projecttype'],
        date: json['date']);
  }
}
