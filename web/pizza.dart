library pizza;

import 'pizzaController.dart';

import 'package:angular/angular.dart';
import 'package:angular/application_factory.dart';

void main() {
  applicationFactory()
      .addModule(new PizzaAppModule())
      .run();
}

class PizzaAppModule extends Module {
  PizzaAppModule() {
    type(PizzaController);
  }
}