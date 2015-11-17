import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'package:json_object/json_object.dart';

// The list of index numbers from the snippets list of which snippets are being
// displayed in the results
List<int> currentIndexList = [];
// Frequently used html elements
HtmlElement resultsListElement = querySelector('#results-list');
HtmlElement noItemsElement = querySelector('#no-items-in-list');
HtmlElement searchBarElement = querySelector('#search-bar');
// Used to
int timeoutCounter = 0;

// From the JSON file snippets.json
List fullSnippets;
List<String> shortSnippets;

// Text Field Placeholder strings
List<String> tfp = [
  "Splay Trees",
  "Quick Sort",
  "Load JSON",
  "Sticky Footer",
  "Inspirational Quote"
];
int tfpi = 0;

void main() {
  // Get the JSON file
  _loadJSON();

  // Cycle through placeholders for the text field when it's empty
  _startTextFieldPlaceholderTimer();

  // Setup listeners
  searchBarElement.onInput.listen(_updateSearchResults);
}

void clickFavorite(el) {
  print(el);
}

void clickCopy(v) {
  print(v);
}

void _updateSearchResults(Event e) {
  timeoutCounter++;
  new Timer(new Duration(milliseconds: 250), () {
    // If the user is typing fast, wait to update until they pause
    timeoutCounter--;
    if (timeoutCounter < 0) timeoutCounter = 0;
    if (timeoutCounter > 0) return;

    // Get the text from the search bar
    String val = searchBarElement.text;

    // Remove all items if there is no value in the search bar
    if (val == "") {
      currentIndexList = [];
      _clearResults();
      noItemsElement.style.display = "none";
      return;
    }

    List<int> newIndexList = [];

    // Search the JSON for the value from the search bar
    // Add matching items from the JSON to a new list
    for (int i = 0; i < shortSnippets.length; i++) {
      if (shortSnippets[i].contains(new RegExp(val, caseSensitive: false))) {
        newIndexList.add(i);
      }
    }

    // Compare the list that was generated to the current list and update the list if necessary
    if (!_compare(currentIndexList, newIndexList)) {
      currentIndexList = newIndexList.toList();
      _clearResults();
      if (newIndexList.length == 0) {
        noItemsElement.style.display = "";
        return;
      }
      noItemsElement.style.display = "none";
      newIndexList.forEach((int i) {
        _addResult(i);
      });
    }
  });
}

// Removes all result items from the page
void _clearResults() {
  while (resultsListElement.firstChild != null) {
    resultsListElement.firstChild.remove();
  }
}

// Adds a result item to the page
// The parameter i is the index of the item in the snippets.json file
void _addResult(i) {
  var data = fullSnippets[1][i];
  var resultToAdd = '<div id="result-index-' +
      i +
      '" class="result-item panel" style="position: relative"><img src="' +
      data.imageUrl +
      '" alt="' +
      data.imageAlt +
      '" style="height: 80px; width: 80px; margin-right: 20px; float: left"><div class="snippet-details" style="margin-right: 40px"><a href="' +
      data.linkToFull +
      '" target="_blank"><h3>' +
      data.title +
      '</h3></a><p>' +
      data.categories +
      '</p></div><div class="snippet-buttons" style="width: 30px; height: 80px; position: absolute; top: 0; right: 0"><a><img src="img/fav-button.png" alt="favorite button" class="favorite-button ' +
      data.favorite +
      '" style="height: 20px; margin: 10px 0"></a><a><img src="img/clipboard.png" alt="clipboard" class="copy-button ' +
      data.copyable +
      '" style="height: 20px; margin: 10px 0"></a></div></div>';
  resultsListElement.appendHtml(resultToAdd);
//  onclick="clickFavorite(this.parentElement.parentElement.id)"
//
//  onclick="clickCopy(\'' +
//  data.copyText +
//      '\')"
}

bool _compare(List<int> a, List<int> b) {
  if (a.length != b.length) {
    return false;
  }

  for (int i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}

void _loadJSON() {
  String url = "snippets.json";

  // call the web server asynchronously
  HttpRequest.getString(url).then((String responseText) {
    fullSnippets = JSON.decode(responseText);
    print(responseText);
    print(fullSnippets);
    print("*** JsonObject test ***");
    var snippetsJson = new JsonObject.fromJsonString(responseText);
    print(snippetsJson.snippets[0].title);
  });
}

void _startTextFieldPlaceholderTimer() {
  new Timer.periodic(new Duration(milliseconds: 1500), (Timer t) {
    if (tfpi == tfp.length - 1) {
      tfpi = 0;
    } else {
      tfpi++;
    }
    searchBarElement.setAttribute('placeholder', tfp[tfpi]);
  });
}
