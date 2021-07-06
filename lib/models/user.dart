class User {
  String username;
  String description;
  String first_name;
  int followers;
  int following;
  String job_title;
  String last_name;
  String profile_photo_url;

  User({
    this.username,
    this.description,
    // ignore: non_constant_identifier_names
    this.first_name,
    this.followers,
    this.following,
    this.job_title,
    // ignore: non_constant_identifier_names
    this.last_name,
    this.profile_photo_url,
  });
}
