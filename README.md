# RRGame
A rhythm reaction game for the UW Games Capstone course.

# Unit Testing
We are testing using munit, configured to support flixel
https://ashes999.github.io/learnhaxe/integration-testing-in-munit-with-haxeflixel.html

Basically, we use munit to manage our test suite (generate main and suite classes), but we run the tests through lime.

Installation:
1. install munit

Run Tests:
1. Navigate to test/
2. run command 'lime test neko' (html5 throws errors?)

Everything else:
1. run command 'haxelib run munit <command>'

# Manual Testing
The directory manual_test/ is for tests that cannot be verified programmatically (ie. painting)

Each folder in this directory is its own haxe flixel game that interfaces with the component under test.
Each manual test has a symlink to a Project.xml that lives in manual_test/ . This Project.xml is a copy of the original
Project.xml but with its Main class rerouted to TestMain. As such, **_ALL CHANGES MADE TO THE ORIGINAL Project.xml FILE
MUST BE MADE TO manual_test/Project.xml_**. Sym links have also been made to assets/, source/, and AssetPaths to ensure
compilation is identical to the original game.

Create new test:
1. copy the new-test-template directory and change its CHANGEME hex class to a new test.

Run Test:
1. cd into the test directory (eg. manual_test/controls/)
2. run the game as normal ($ lime test html5).
