// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:convert';
import 'package:polymer/polymer.dart';

@CustomTag('pizza-design-form')
class PizzaDesignComponent extends FormElement with Polymer, Observable {
  
  PizzaDesignComponent.created(List categories, Map data) : super.created() { 
    buildDOM(categories, data);
  }
  
  // Set up the maps for the form and give initial values.
  // Boolean values in this map are bound with bind-checked to checkboxes.
  @observable Map<String, bool> favoriteThings = toObservable({
    'kittens': true, 'raindrops': false,
    'mittens': true, 'kettles': false});
  
  // This map contains the rest of the forma data.
  @observable Map theData = toObservable({
    'firstName':      'mem',
    'favoriteQuote':  'Enjoy all your meals.',
    'favoriteColor':  '#4169E1',
    'birthday':       '1963-08-30',
    'volume':         '11', //I want this to be bound to an integer!
    'catOrDog':       'dog',
    'music':          2,
    'zombies':        true
    // Add favoriteThings later...can't do it here...there is no this.
  });

  @observable String serverResponse = '';
  HttpRequest request;

  void submitForm(Event e, var detail, Node target) {
    e.preventDefault(); // Don't do the default submit.
       
    request = new HttpRequest();
    
    request.onReadyStateChange.listen(onData); 
    
    // POST the data to the server.
    var url = 'http://127.0.0.1:4040';
    request.open('POST', url);
    request.send(_slambookAsJsonData());
  }
  
  void catOrDog(Event e, var detail, Element target) {
    theData['catOrDog'] = (target as RadioButtonInputElement).value;
  }
  
  void onData(_) {
    if (request.readyState == HttpRequest.DONE &&
        request.status == 200) {
      // Data saved OK.
      serverResponse = 'Server Sez: ' + request.responseText;
    } else if (request.readyState == HttpRequest.DONE &&
        request.status == 0) {
      // Status is 0...most likely the server isn't running.
      serverResponse = 'No server';
    }
  }
   
  void resetForm(Event e, var detail, Node target) {
    e.preventDefault(); // Default behavior clears elements,
                        // but bound values don't follow
                        // so have to do this explicitly.
    favoriteThings['kittens'] = false;
    favoriteThings['raindrops'] = false;
    favoriteThings['mittens'] = false;
    favoriteThings['kettles'] = false;
    
    theData['firstName'] = '';
    theData['favoriteQuote'] = '';
    theData['favoriteColor'] = '#FFFFFF';
    theData['birthday'] = '2013-01-01';
    theData['volume'] = '0';
    theData['catOrDog'] = 'cat';
    theData['music'] = 0;
    theData['zombies'] = false;
    serverResponse = 'Data cleared.';
  }
  
  String _slambookAsJsonData() {
    // Put favoriteThings in the map.
    theData['favoriteThings'] = favoriteThings;
    return JSON.encode(theData);
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
  
  void buildDOM(List<String> categories, Map data) {
    for (String c in categories) {
      Map<String, bool> test = new Map();
      for (String v in data[c]['values']) {
        
      }
      @observable Map<String, bool> temp = toObservable();
    }
  }
}
