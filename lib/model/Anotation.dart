class Anotation {
  int id;
  String title;
  String description;
  String date;

  Anotation(
    this.title,
    this.description,
    this.date,
  );

  Map<String, dynamic> toMap() => {
        'title': title,
        'description': description,
        'date': date,
      };

  Anotation.fromMap(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.date = map['date'];
  }
}
