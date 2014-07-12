library pizza_controller;

import 'package:angular/angular.dart';

import 'category.dart';
import 'tooltip/tooltip.dart';
import 'order.dart';

@Controller(
    selector: '[pizza-designer]',
    publishAs: 'ctrl')
class PizzaController {

  static const String LOADING_MESSAGE = "Loading pizza options...";
  static const String ERROR_MESSAGE = "Sorry! The cook stepped out of the "
      "kitchen and took the pizza options with him!";

  final Http _http;

  // Determine the initial load state of the app
  String message = LOADING_MESSAGE;
  bool categoriesLoaded = false;
  bool orderInitialized = false;

  // Data objects that are loaded from the server side via json
  List category_list = [];
  Map<String, Category> categories;
  
  // Internal objects
  Category selectedCategory;
  Order currentOrder;
  List<Order> orderList;
  
  PizzaController(this._http) {
    _loadData();
    orderList = new List();
  }

  void addItem() {
    currentOrder = new Order(categories);
    orderList.add(currentOrder);
  }

  void selectCategory(Category category) {
    selectedCategory = category;
  }
  
  void selectOrder(Order order) {
    currentOrder = order;
    print("Selecting: ${currentOrder}");
  }
  
  // Tooltip
  TooltipModel tooltipForOption(String option) {
    print("Tooltip called");
    TooltipModel tooltip = new TooltipModel("Lenna.png",
          "I don't have a picture of these choices, "
          "so here's one of my cat instead!",
          80);
    return tooltip; // recipe.tooltip
  }
  
  void _initOrder()
  {
    currentOrder = new Order(categories);
    orderInitialized = true;
    orderList.add(currentOrder);
  }
  
  void _loadData() {
    categoriesLoaded = false;
    _http.get('config/pizza.json')
      .then((HttpResponse response) {
        print(response);
        category_list = response.data.map((d) => new Category.fromJson(d)).toList();
        categories = new Map.fromIterable(category_list, key: (v) => v.name, value: (v) => v);
        print(categories);
        _initOrder();
        categoriesLoaded = true;
      })
      .catchError((e) {
        print(e);
        categoriesLoaded = false;
        message = ERROR_MESSAGE;
      });
  }
}
