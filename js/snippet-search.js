// JavaScript Document

function setupPage() {
	// Get the JSON file
	loadJSON(function(response) {
		// Parse JSON string into object
		fullSnippets = JSON.parse(response);
		// Condense the full JSON into a shorter array to speed up the search
		shortSnippets = [];
		$.each(fullSnippets.snippets, function(i, v) {
			shortSnippets.push(v.title + "; " + v.categories);
		});
	});
	
	// Initialize an empy array of the items currently displayed in the list
	currentIndexList = [];
	resultsListElement = document.getElementById("results-list");
	
	// Create function to compare arrays (http://stackoverflow.com/questions/7837456/how-to-compare-arrays-in-javascript)
	setupArrayEqualsFunction();
}

function updateSearchResults() {
	// TODO: Wait for timeout before updating
	
	// Get the text from the search bar
	var val = document.getElementById("search-bar").value;
	
	// Remove all items if there is no value in the search bar
	if (val === "") {
		currentIndexList = [];
		clearResults();
		document.getElementById("no-items-in-list").style.display = "none";
		return;
	}

	var newIndexList = [];

	// Search the JSON for the value from the search bar
	// Add matching items from the JSON to a new list
	$.each(shortSnippets, function(i, v) {
		if (v.search(new RegExp(val, "i")) != -1) {
			newIndexList.push(i);
		}
	});
	
	// Compare the list that was generated to the current list and update the list if necessary
	if (!currentIndexList.equals(newIndexList)) {
		currentIndexList = newIndexList;
		clearResults();
		if (newIndexList.length == 0) {
			document.getElementById("no-items-in-list").style.display = "";
			return;
		}
		document.getElementById("no-items-in-list").style.display = "none";
		$.each(newIndexList, function(i, v) {
			addResult(v);
		});
	}
}

// Removes all result items from the page
function clearResults() {
	while (resultsListElement.firstChild) {
		resultsListElement.removeChild(resultsListElement.firstChild);
	}
}

// Adds a result item to the page
// The parameter i is the index of the item in the snippets.json file
function addResult(i) {
	// var data = jQuery.parseJSON(json);
	var data = fullSnippets.snippets[i];
	var resultToAdd = '<div id="result-index-' + i + '" class="result-item panel" style="position: relative">' +
        	'<img src="' + data.imageUrl + '" alt="' + data.imageAlt + '" style="height: 80px; width: 80px; margin-right: 20px; float: left">' + 
            '<div class="snippet-details" style="margin-right: 40px">' + 
            	'<a href="' + data.linkToFull + '" target="_blank"><h3>' + data.title + '</h3></a>' +
            	'<p>' + data.categories + '</p>' +
            '</div>' + 
            '<div class="snippet-buttons" style="width: 30px; height: 80px; position: absolute; top: 0; right: 0">' + 
            	'<a><img src="img/fav-button.png" alt="favorite button" class="favorite-button ' + data.favorite + '" onclick="clickFavorite(this.parentElement.parentElement.id)" style="height: 20px; margin: 10px 0"></a>' +
            	'<a><img src="img/clipboard.png" alt="clipboard" class="copy-button ' + data.copyable + '" onclick="clickCopy(\'' + data.copyText + '\')" style="height: 20px; margin: 10px 0"></a>' +
            '</div>' + 
        '</div>';
	$(resultToAdd).appendTo('#results-list');
}

function clickFavorite(el) {
    console.log(el);
}

function clickCopy(v) {
    console.log(v);
}

function setupArrayEqualsFunction() {
	// Warn if overriding existing method
	if(Array.prototype.equals)
    console.warn("Overriding existing Array.prototype.equals. Possible causes: New API defines the method, there's a framework conflict or you've got double inclusions in your code.");
	// attach the .equals method to Array's prototype to call it on any array
	Array.prototype.equals = function (array) {
    	// if the other array is a falsy value, return
	    if (!array)
	        return false;

    	// compare lengths - can save a lot of time 
	    if (this.length != array.length)
	        return false;

    	for (var i = 0, l=this.length; i < l; i++) {
	        // Check if we have nested arrays
	        if (this[i] instanceof Array && array[i] instanceof Array) {
	            // recurse into the nested arrays
	            if (!this[i].equals(array[i]))
	                return false;       
	        }           
	        else if (this[i] != array[i]) { 
	            // Warning - two different object instances will never be equal: {x:20} != {x:20}
	            return false;   
	        }           
	    }       
    return true;
}
// Hide method from for-in loops
Object.defineProperty(Array.prototype, "equals", {enumerable: false});
}

// http://codepen.io/KryptoniteDove/post/load-json-file-locally-using-pure-javascript
function loadJSON(callback) {

	var xobj = new XMLHttpRequest();
	xobj.overrideMimeType("application/json");
	xobj.open('GET', 'snippets.json', true);
	xobj.onreadystatechange = function () {
		if (xobj.readyState == 4 && xobj.status == "200") {
			// Required use of an anonymous callback as .open will NOT return a value but simply returns undefined in asynchronous mode
			callback(xobj.responseText);
		}
	};
	xobj.send(null);
}
