This directory is for tests that must be run manually.

Each folder here is its own haxe flixel game that interfaces with the component under test.
As such, they each must contain a sym link to the original Project.xml in the root directory, the assets/ directory,
and the source/AssetPaths.hx haxe class. Its Main can then be edited to run a Test as a flixel game.

To create a new Test, copy the new-test-template directory and change its CHANGEME hex class to a new test.

To run a test, cd into the test directory (eg. test/manual_test/controls/) and run the game as normal
($ lime test html5).
