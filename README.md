# RRGame
Develop branch: [![Build Status](https://travis-ci.org/Awfa/RRGame.svg?branch=develop)](https://travis-ci.org/Awfa/RRGame)

Master (production) branch: [![Build Status](https://travis-ci.org/Awfa/RRGame.svg?branch=master)](https://travis-ci.org/Awfa/RRGame)

A rhythm reaction game for the UW Games Capstone course.

Here is our Trello: https://trello.com/b/iIid3sMX

# Testing
We are testing using munit, configured to support flixel
https://ashes999.github.io/learnhaxe/integration-testing-in-munit-with-haxeflixel.html

Basically, we use munit to manage our test suite (generate main and suite classes), but we run the tests through lime.

Installation:
1. Install munit
2. Install hamcrest

Run Tests:
1. Navigate to test/
2. Run command 'lime test neko' (html5 throws errors?)

Everything else:
1. Run command 'haxelib run munit <command>'
