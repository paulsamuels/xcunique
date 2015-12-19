# `xcunique`

A tool to reduce merge conflicts with Xcode projects by creating deterministic UUIDs for every element within the `project.pbxproj` file.

This is initially a fun yak shaving task as existing tools, such as [xUnique](https://github.com/truebit/xUnique), already exist. There is a vague idea that this would be a part of a very small suite of tools to help reduce the pain of managing Xcode projects.

###Warning

If you are not using source control then you should not be using this tool.

---

## Installation

Add this line to your application's Gemfile:

    gem 'xcunique'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install xcunique

## Usage

```
Usage: xcunique PROJECT.PBXPROJ [options]
    -f, --format=<ascii|json|xml>    ascii|json|xml
    -v, --verbose
```

###`--format`
The format switch has 3 options

* `ascii` requires [`xcproj`](https://github.com/0xced/xcproj) to be installed. It writes the project to a plist and then touches it with [`xcproj`](https://github.com/0xced/xcproj)
* `json` outputs to stdout - useful for debugging or using with other tools
* `xml` writes over the project file with an XML formatted plist

###`--verbose`

* It's always nice to now what is happening so show some logs

---

## What does it even do?

Good question - there is not a lot of source code to look at but I'll call out the general process.

[cli.rb](https://github.com/paulsamuels/xcunique/blob/master/lib/xcunique/cli.rb) is where all the fun begins:
https://github.com/paulsamuels/xcunique/blob/master/lib/xcunique/cli.rb
* It uses [options.rb](https://github.com/paulsamuels/xcunique/blob/master/lib/xcunique/options.rb) to extract the command line arguments and do some basic checking to ensure you have provided valid paths etc.
* Then it uses [uniquifier.rb](https://github.com/paulsamuels/xcunique/blob/master/lib/xcunique/uniquifier.rb) to generate the deterministic UUIDs
* Then it uses [sorter.rb](https://github.com/paulsamuels/xcunique/blob/master/lib/xcunique/sorter.rb) to sort the groups/files alphabetically
* The uniqued/sorted files is then written out to a JSON file
* This JSON file is converted to an XML plist using the bundled swift script
* This plist is then optionally converted to ascii using [`xcproj`](https://github.com/0xced/xcproj)

[uniquifier.rb](https://github.com/paulsamuels/xcunique/blob/master/lib/xcunique/uniquifier.rb) coordinates the majority of the process:

* It creates a [parser.rb](https://github.com/paulsamuels/xcunique/blob/master/lib/xcunique/parser.rb) that first enumerates the groups/files section of the Xcode project and then traverses from the root object in the project. The parser keeps track of UUIDs that it has already visited, which prevents getting into cycles and generating different paths if files are included in multiple targets.
* The result of this parsing is a hash of substitutions going from old UUID to new deterministic UUID - the transforming from old UUID to new UUID is performed during a deep clone of the project object

To see the format of the normalised paths before they are MD5'd check out the tests in [parser_spec.rb](https://github.com/paulsamuels/xcunique/blob/master/spec/xcunique/sorter.rb)
## Contributing

1. Fork it ( https://github.com/[my-github-username]/xcunique/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
