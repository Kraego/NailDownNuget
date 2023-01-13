import argparse
import subprocess
import json

parser = argparse.ArgumentParser()
parser.add_argument('slnpath')
parser.add_argument('nugetName')
parser.add_argument('nugetVersion')

args = parser.parse_args()


def find_nuget(path, currentElementName, currentElementVersion, nugetName, nugetVersion, dependencies):
    resultPath = "{} > {}".format(path, currentElementName)

    if currentElementName == nugetName and currentElementVersion == nugetVersion:
        print('\n* Found: {}\n'.format(resultPath))
        return
        
    if len(dependencies) == 0:
        return
    else:
        for dependency in dependencies:
            find_nuget(resultPath, dependency['id'], dependency['version'], nugetName, nugetVersion, dependency['dependencies'])


def main(args):
    print('Executing nuget-deps-tree for path: "{}"'.format(args.slnpath))
    dependenciesString = subprocess.run(
        ['nuget-deps-tree', args.slnpath], 
        shell=True, 
        stdout=subprocess.PIPE, 
        stderr=subprocess.DEVNULL).stdout
    
    dependencyTree = json.loads(dependenciesString)
    
    for project in dependencyTree['projects']:
        print('Checking {}'.format(project['name']))
        find_nuget("", project['name'], "", args.nugetName, args.nugetVersion, project['dependencies'])


if __name__ == '__main__':
    main(args)    
    