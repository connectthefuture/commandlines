## commandlines  [![Build Status](https://travis-ci.org/chrissimpkins/commandlines.svg?branch=master)](https://travis-ci.org/chrissimpkins/commandlines) [![Build status](https://ci.appveyor.com/api/projects/status/nabadxorf9s8n0h5/branch/master?svg=true)](https://ci.appveyor.com/project/chrissimpkins/commandlines/branch/master)  [![codecov.io](https://codecov.io/github/chrissimpkins/commandlines/coverage.svg?branch=master)](https://codecov.io/github/chrissimpkins/commandlines?branch=master) [![Code Health](https://landscape.io/github/chrissimpkins/commandlines/master/landscape.svg?style=flat)](https://landscape.io/github/chrissimpkins/commandlines/master)


<img src="https://raw.githubusercontent.com/chrissimpkins/commandlines/images/images/commandlines.png" width="740" alt="commandlines">


## What is Commandlines?

Commandlines is a Python library for command line application development that supports command line argument parsing, command string validation testing, & application logic.  It has no external dependencies and provides broad Python interpreter support for Python 2.6+, Python 3.3+, pypy, and pypy3 across OS X, Linux, and Windows platforms.


## How Do I Use It?

The command line string to your executable script is parsed to multiple objects that are derived from builtin Python types.


### The Command Object

Instantiate a `commandlines` Command object:

```python
from commandlines import Command

c = Command()
```

and you have access to:

#### Arguments

| Command Line Arguments  | Command Example  | Accessed/Tested With |
| :------------: |:---------------:| :---------------:|
| Length of arg list | `$ spam eggs -t --out file` | `c.argc == 4` |
| Command suite sub-commands | `$ spam eggs` | `c.subcmd == "eggs"` |
| Command suite sub-sub-commands | `$ spam eggs overeasy` | `c.subsubcmd == "overeasy"` |
| Short switch syntax | `$ spam -e` | `c.contains_switches('e')` |
| Long switch syntax | `$ spam --eggs` | `c.contains_switches('eggs')` | 
| Multiple switches | `$ spam -e --eggs --bacon`| `c.contains_switches('e', 'eggs', 'bacon')`|
| Short opt-arg definition syntax | `$ spam -o eggs` | `c.get_definition('o')`|
| Long opt-arg definition syntax | `$ spam --out eggs` | `c.get_definition('out')`|
| Alt long opt-arg definition syntax | `$ spam --out=eggs` | `c.get_definition('out')`|
| Multiple same option definitions | `$ spam -o eggs -o omelets` | `c.get_multiple_definitions('o')` |
| Multi-option short syntax switches | `$ spam -mpns eggs` | `c.contains_mops('m')` |
| Next positional argument | `$ spam eggs test/path` | `c.get_arg_after('eggs')`|

#### Positional Arguments

Positional arguments use a 0 based index starting at the first argument to the executable (i.e. `sys.argv[1:]`) and are maintained as attributes in the Command object.  Individual attribute support is provided for the first five positional arguments and the last positional argument.  An ordered list of all positional arguments is available in the `arguments` attribute.

| Positional Argument  | Command Example  | Accessed/Tested With |
| :------------: |:---------------:| :---------------:|
| Positional argument at index 0 | `$ spam eggs` | `c.arg0` |
| Positional argument at index 1 | `$ spam eggs bacon` | `c.arg1` |
| Positional argument at index 2 | `$ spam eggs bacon toast` | `c.arg2` |
| Positional argument at index 3 | `$ spam eggs bacon toast cereal` | `c.arg3` |
| Positional argument at index 4 | `$ spam eggs bacon toast cereal coffee` | `c.arg4` |
| Last positional argument | `$ spam eggs -b --toast filepath` | `c.arglp` |
| All positional arguments |  `$ spam eggs -b --toast filepath` | `c.arguments` |

#### Special Command Line Idioms

| Command Line Idioms  | Command Example  | Accessed/Tested With |
| :------------: |:---------------:| :---------------:|
| Double dash idiom | `$ spam eggs -- -badfile` | `c.has_double_dash()` |
| Double dash arguments| `$ spam eggs -- -badfile -badfile2` | `c.get_double_dash_args()` |

#### Application Logic Testing Methods

| Test Type  | Command Example  | Tested With |
| :------------: |:---------------:| :---------------:|
| Positional command sequence | `$ spam eggs doit` | `c.has_command_sequence('eggs', 'doit')`|
| Single switch | `$ spam -s` | `c.contains_switches('s')` |
| Multiple switch | `$ spam -s --eggs` | `c.contains_switches('s', 'eggs')` |
| Single definition | `$ spam -o eggs` | `c.contains_definitions('o')` |
| Multiple different definitions | `$ spam -o eggs --with bacon` | `c.contains_definitions('o', 'with')` |
| Multiple same definitions | `$ spam -o eggs -o bacon` | `c.contains_multi_definitions('o')`|
| Positional argument | `$ spam eggs --coffee` | `c.has_args_after('eggs')`|
| Acceptable positional arg | `$ spam eggs toaster` | `c.next_arg_is_in('eggs', ['toaster', 'coffeepot'])` |

#### Command String Validation Methods

| Test Type  | Failure Example  | Tested With |
| :------------: |:---------------:| :---------------:|
| Missing arguments | `$ spam` | `c.does_not_validate_missing_args()`|
| Expected argument number | `$ spam eggs` | `c.does_not_validate_n_args(2)` |
| Missing opt-arg definitions | `$ spam -o --eggs` | `c.does_not_validate_missing_defs()` |
| Missing switches | `$ spam eggs` | `c.does_not_validate_missing_switches()` |
| Missing multi-option short syntax switches | `$ spam -o eggs` | `c.does_not_validate_missing_mops()` |

#### Help, Usage, and Version Request Testing Methods

| Test Type  | Command Example  | Tested With |
| :------------: |:---------------:| :---------------:|
| Help request, short | `$ spam -h` | `c.is_help_request()`|
| Help request, long | `$ spam --help` | `c.is_help_request()`|
| Usage request | `$ spam --usage` | `c.is_usage_request()` |
| Version request, short | `$ spam -v` | `c.is_version_request()`|
| Version request, long| `$ spam --version` | `c.is_version_request()`|


### Development with Commandlines

To facilitate development with Commandlines, you can print the string returned by the Command `obj_string()` method to view a list of the parsed arguments from example commands:

```python
from commandlines import Command

c = Command()

print(c.obj_string())
sys.exit(0)
```

If you execute your script with the command `spam eggs --toast -b --drink=milk filepath` and include the above print statement in your source, you will see the following in your terminal emulator:

```shell
$ spam eggs --toast -b --drink=milk filepath
obj.argc = 5
obj.arguments = ['eggs', '--toast', '-b', '--drink=milk', 'filepath']
obj.switches = {'toast', 'b'}
obj.defs = {'drink': 'milk'}
obj.mdefs = {}
obj.mops = {}
obj.arg0 = 'eggs'
obj.arg1 = '--toast'
obj.arg2 = '-b'
obj.arg3 = '--drink=milk'
obj.arg4 = 'filepath'
obj.arglp = 'filepath'
obj.subcmd = 'eggs'
obj.subsubcmd = '--toast'
```


### API Documentation

The Command class is designed to be the public facing library object.  You can view full documentation of this class [here](https://commandlines.github.io/commandlines.library.html#commandlines.library.Command).

If you would like to dig into lower level objects in the commandlines package, you can view the [library API documentation](https://commandlines.github.io/commandlines.library.html).

Exceptions that are used in the commandlines package are documented [here](https://commandlines.github.io/commandlines.exceptions.html).

## How to Include Commandlines in Your Project

### For Projects That Will Be Distributed to Others

Add the `commandlines` package dependency to your project `setup.py` file in the `install_requires` field like so:

```python
setup(
    ...
    install_requires=["commandlines"],
	...
)
```

Then, enter the following command to test your project locally:

```
$ python setup.py develop
```

Import the `commandlines` package in your project and instantiate a Command object by adding the following lines to your Python script:

```python
from commandlines import Command

c = Command()
```

And away you go...

The Commandlines package will be installed automatically for users who install your releases via `pip` or your project `setup.py` file (i.e. with the command `$ python setup.py install`).


### For Local Projects That Are Not Intended for Redistribution

Install the Commandlines package with the command:

```
$ pip install commandlines
```

Import the `commandlines` package in your project and instantiate a Command object by adding the following lines to your Python script:

```python
from commandlines import Command

c = Command()
```

## License

Commandlines is licensed under the [MIT license](docs/LICENSE).



















