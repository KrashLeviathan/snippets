# Snippets
A Collection of Useful Things

## About
This project's short term goal is to make a "useful things" repository that can be quickly searched and copied from. Sort of like a queryable magic clipboard that holds all the things you might want to use again. It's also my first attempt at writing a web app -- it ain't pretty, but it's a start.

## Creating your own snippets collection
*Not complete yet, but when it is, the following information will be useful:*

If you want to use the design and everything, be my guest. Just fork the repo and update the JSON file to suit your needs. If you'd rather just use the search API, you'll want to do the following:

#### Structure the directory as such:

```
/root_directory_for_page_using_snippets/
|-- your_page.html
|-- snippets.json
|-- img
|   |-- fav-button.png
|   |-- copy-button.png
```

#### Setup your page with the following elements

```html
<div id="search-bar-container" class="row">
        <div class="large-12 columns">
            <form>
                <div class="row">
                    <div class="medium-8 large-9 columns">
                        <label id="search-label">Search</label>
                        <br>
                        <input type="text" id="search-bar" placeholder="Splay Trees">
                    </div>
                    <div class="medium-4 large-3 columns" style="padding-top: 10px">
                        <input type="submit" class="small radius button" value="Search deeper...">
                    </div>
                </div>
            </form>
        </div>
    </div>
    <div id="results-container" class="row">
        <div class="large-12 columns">
            <div id="results-list">
            </div>
            <div id="no-items-in-list" class="panel" style="position: relative; display: none">
                <img src="img/empty-pocket.jpg" alt="empty pockets">

                <div class="snippet-details">
                    <h3>No luck...</h3>

                    <p>Try <a href="#">searching deeper</a> to get more results.</p>
                </div>
            </div>
        </div>
    </div>
```

#### For styling purposes, the search results have the following form

```html
<div id="result-index-1" class="result-item panel">
    <img class="snippet-icon">
    <div class="snippet-details">
        <a>
            <h3>Result Title</h3>
        </a>
        <p>Categories</p>
    </div>
    <div class="snippet-buttons">
        <a>
            <img class="favorite-button">
        </a>
        <a>
            <img class="copy-button">
        </a>
    </div>
</div>
```
