# MicroEvent.rb [![[version]](https://badge.fury.io/rb/microevent.svg)](https://badge.fury.io/rb/microevent)  [![[CI]](https://github.com/janlelis/microevent.rb/workflows/Test/badge.svg)](https://github.com/janlelis/microevent.rb/actions?query=workflow%3ATest)

MicroEvent.rb is a event emitter library which provides the observer pattern to Ruby objects. It is inspired by [MicroEvent.js](https://github.com/jeromeetienne/microevent.js), implemented in less than [20 lines of Ruby](https://github.com/janlelis/microevent.rb/blob/master/lib/microevent.rb).


## Setup

Add to your `Gemfile`

```ruby
gem 'microevent'
```

or copy the [source file](https://github.com/janlelis/microevent.rb/blob/master/lib/microevent.rb) into your project.

## How to Use It

Suppose you got a class `Klass`, and you wish it to support the observer partern, do

```ruby
class Klass
  include MicroEvent
end
```

That's it. Now all instances of this class can `#bind`, `#unbind` and `trigger`:

```ruby
fn = proc{ puts "Go" }
object = Klass.new
object.bind :slot, &fn
object.trigger :slot # => Go
```

You could also use it on class/singleton level:

```ruby
class Klass
  extend MicroEvent
end

Klass.bind :slot do
  puts "Go"
end

Klass.trigger :slot # => Go
```

You will find more examples in the [tests](https://github.com/janlelis/microevent.rb/blob/master/spec/microevent_spec.rb).

## Alternative Variants

* [threadsafe](https://github.com/janlelis/microevent.rb/tree/threadsafe) - Thread safe version
* [added](https://github.com/janlelis/microevent.rb/tree/added) - Thread safe version based on [added](https://github.com/janlelis/added) hook
* [min](https://github.com/janlelis/microevent.rb/tree/min) - 275 bytes version


## Projects Using MicroEvent.rb

* [micrologger](https://github.com/janlelis/micrologger)


## MIT License

Ruby version by [Jan Lelis](https://janlelis.com). Inspired by [MicroEvent.js](https://github.com/jeromeetienne/microevent.js) by Jerome Etienne.
