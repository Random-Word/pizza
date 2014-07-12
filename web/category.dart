library option;

class Category {
  //String id;
  String name;
  //String category;
  List<String> options;
  //List<num> prices;
  String type;
  List<String> imgURLs;

  Category(this.type, this.name, this.options,  this.imgURLs);

  Map<String, dynamic> toJson() => <String, dynamic>{
    "name": name,
    "options": options,
    "type": type,
    "imgURLs": imgURLs
  };

  Category.fromJson(Map<String, dynamic> json) : this(json['type'],
      json['name'], json['values'], json['imgURLs']);
  
  String toString() {
    return name;
  }
}