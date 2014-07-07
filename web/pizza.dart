import 'dart:html';
import 'dart:convert' show JSON;
import 'dart:async' show Future;

List<String> pizzaOptionCategories = [];
Map pizzaOptions = new Map();
Map pizzaOptionType = new Map();

ButtonElement addToOrderButton;

Future loadPizzaOptions() {
  var path = 'config/pizza.json';
  return HttpRequest.getString(path).then(_parsePizzaOptionsFromJSON);
}

_parsePizzaOptionsFromJSON(String jsonString) {
    Map pizzaData = JSON.decode(jsonString);
    pizzaOptionCategories = pizzaData['categories'];
    for (String c in pizzaOptionCategories) {
      pizzaOptions[c] = pizzaData[c]['values'];
      pizzaOptionType[c] = pizzaData[c]['type'];
    }
}

List createButtonsWithLabels(String category, List<String> options, String type) {
  List<Element> newElements = [];
  
  for (String o in options){
    var button = type=='single' ? new RadioButtonInputElement() : new CheckboxInputElement();
    button.name = category;
    button.value = o;
    button.id = "${category}_${o}";
    var label = new LabelElement();
    label.attributes['for'] = button.id;
    label.text = o;
    newElements.add(button);
    newElements.add(label);
  }
  return newElements;
}

void addToOrder(MouseEvent event) {
  for (FormElement f in querySelectorAll('form')) {
    
    f.reset();
  }
}

void main() {
  addToOrderButton = querySelector("#pizza-add-to-order");
  addToOrderButton.onClick.listen(addToOrder);
  
  loadPizzaOptions().then((_) {
    for (String c in pizzaOptionCategories) {
      var form = new FormElement();
      form.id = "${c}_form";
      form.nodes.addAll(createButtonsWithLabels(c, pizzaOptions[c], pizzaOptionType[c]));
      querySelector('#pizza-designer').nodes.add(form);
    }
  }).catchError((NoOptsFound) {
    print(NoOptsFound);
    print("No pizza options found.");
    }
  );
}

class PizzaOrder {
  List<String> _categories;
  Map _choices;
  
  PizzaOrder(List<String> categories, Map choices) {
    _categories = categories;
    _choices = choices;
  }
  
  PizzaOrder.fromJSON(String jsonString) {
    Map storedName = JSON.decode(jsonString);
    _categories = storedName['categories'];
    _choices = storedName['choices'];
  }
  
  String get orderString {
    String orderString = "Pizza ";
    for (String c in _categories) {
      orderString = orderString + _choices[c];
    }
    return orderString;
  }
  
  String get jsonString => JSON.encode({"categories": _categories, "choices": _choices});
}