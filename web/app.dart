import 'dart:html';
import 'dart:async';
import 'package:json_object/json_object.dart';

// The list of index numbers from the snippets list of which snippets are being
// displayed in the results
List<int> currentIndexList = [];
// Frequently used html elements
HtmlElement resultsListElement = querySelector('#results-list');
HtmlElement noItemsElement = querySelector('#no-items-in-list');
InputElement searchBarElement = querySelector('#search-bar');
// Used for fast typing search pause
int timeoutCounter = 0;

// From the JSON file snippets.json
var fullSnippets;
List<String> shortSnippets = [];

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
    String val = searchBarElement.value;

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
  var data = fullSnippets[i];

  // TODO: Move all CSS into styles file

  DivElement resultItem = new DivElement()
  ..id="result-index-"+i.toString()
  ..className="result-item panel"
  ..style.position="relative";

  ImageElement resultImage = new ImageElement(src: data.imageUrl, width: 80, height: 80)
  ..alt=data.imageAlt
  ..style.marginRight="20px"
  ..style.float="left";
  resultItem.children.add(resultImage);

  DivElement snippetDetails = new DivElement()
  ..className="snippet-details"
  ..style.marginRight="40px";
  resultItem.children.add(snippetDetails);

  AnchorElement linkToFull = new AnchorElement(href: data.linkToFull)
  ..target="_blank";
  snippetDetails.children.add(linkToFull);

  HeadingElement h3 = new HeadingElement.h3()
  ..setInnerHtml(data.title);
  linkToFull.children.add(h3);

  ParagraphElement categories = new ParagraphElement()
  ..setInnerHtml(data.categories);
  snippetDetails.children.add(categories);

  DivElement snippetButtons = new DivElement()
  ..style.width="30px"
  ..style.height="80px"
  ..style.position="absolute"
  ..style.top="0"
  ..style.right="0";
  resultItem.children.add(snippetButtons);

  AnchorElement anchorFav = new AnchorElement();
  snippetButtons.children.add(anchorFav);

  ImageElement imageFav = new ImageElement(src: "img/fav-button.png")
  ..alt="favorite button"
  ..className="favorite-button " + data.favorite
  ..onClick.listen((e) {
    print("clicked favorite");
  })
  ..style.height="20px"
  ..style.margin="10px 0";
  anchorFav.children.add(imageFav);

  AnchorElement anchorCopy = new AnchorElement();
  snippetButtons.children.add(anchorCopy);

  ImageElement imageCopy = new ImageElement(src: "img/clipboard.png")
    ..alt="clipboard"
    ..className="copy-button " + data.favorite
    ..onClick.listen((e) {
      print("clicked copy");
    })
    ..style.height="20px"
    ..style.margin="10px 0";
  anchorCopy.children.add(imageCopy);

  resultsListElement.children.add(resultItem);
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
    fullSnippets = (new JsonObject.fromJsonString(responseText)).snippets;
    for (int i = 0; i < fullSnippets.length; i++) {
      shortSnippets.add(fullSnippets[i].title + '; ' + fullSnippets[i].categories);
    }
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
