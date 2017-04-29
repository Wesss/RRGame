# RRGame
Develop branch: [![Build Status](https://travis-ci.org/Awfa/RRGame.svg?branch=develop)](https://travis-ci.org/Awfa/RRGame)

Master (production) branch: [![Build Status](https://travis-ci.org/Awfa/RRGame.svg?branch=master)](https://travis-ci.org/Awfa/RRGame)

A rhythm reaction game for the UW Games Capstone course.

Here is our Trello: https://trello.com/b/iIid3sMX

# Unit Testing
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

# Manual Testing
The directory manual_test/ is for tests that cannot be verified programmatically (ie. painting)

Each folder in this directory is its own haxe flixel game that interfaces with the component under test.

Create new test:
1. Copy the new-test-template directory and change its CHANGEME hex class to a new test.

Run Test:
1. Cd into the test directory (eg. manual_test/controls/)
2. Run the game as normal ($ lime test html5).

