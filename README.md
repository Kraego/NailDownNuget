# About

**If you need to find a transitive nuget dependency in .net project by name and version you can use this approach.**

If you are using `DependencyTrack` or a similar tool to find nugets with critical CVE in a `.net C#` application, there is no automatic way (in VS or nuget) to track down the inclusion path of the nuget introducing the vulnerability.

After several hours of internet research without success I decided to write this. A powershell script + the same implementation in `python` as platform agnostic approach.

# Prerequisite

* `node.js` - Installguide see https://nodejs.org/en/download/package-manager/
* `nuget-deps-tree` - npm see https://www.npmjs.com/package/nuget-deps-tree
	* `npm install -g nuget-deps-tree`

# How does it work

It calls `nuget-deps-tree` stores the resulting dependency tree. Then it tries to find the given nuget in the tree. To do so it traverses the dependencies and logs the path to shell, when the desired nuget was found.

# Runit

* (There must be a `dotnet build` or at least a `dotnet restore` to update the local nuget caches)

## powershell

* Don't forget to unblock the `nailDownNuget.ps1`
* Run it in powershell `nailDownNuget.ps1 [path to sln] [name of the nuget] [version of the nuget]`

## python

* `py .\nailDownNuget.py [path to sln], [name of the nuget], [version of the nuget]`