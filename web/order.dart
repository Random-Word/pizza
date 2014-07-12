import 'category.dart';

class Order {
  Map<Category, Map<String, bool>> ochoices;
  Map<String, Map<String, bool>> choices;
  
  Order(Map<String, Category> categories) {
    ochoices = new Map();
    choices = new Map();
    categories.values.forEach(
        (c){
          ochoices[c]=new Map();
          choices[c.name]=new Map();
          c.options.forEach((o){
            ochoices[c][o]=false;
            choices[c.name][o]=false;
          });
        });
  }
  
  setChoices(Map<String, Map<String, bool>> init) {
    choices = init;
  }
  
  void newChoice(Category category, String option) {
    print("Category: ${category}, Option: ${option}");
    if (category.type == 'radio') {
      choices[category.name].keys.forEach((f) {choices[category.name][f]=false;});
      choices[category.name][option] = true;
    } else {
      choices[category.name][option] = !choices[category.name][option];
    }
  }
  
  String toString() {
    String to_ret = "";
    for (String c in choices.keys) {
      to_ret+=c+'\n';
      num items = 0;
      for (String s in choices[c].keys){
        if (choices[c][s]) {
          if (items!=0) {to_ret+=', ';}
          to_ret+=s;
          items++;
        }
      }
      if (items==0) {to_ret+='None';}
      to_ret=to_ret+'\n';
    }
    return to_ret;
  }
}