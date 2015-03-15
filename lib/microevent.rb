require_relative 'microevent/version'

require 'thread_safe'
require 'added'

module MicroEvent
  def self.added(instance)
    instance.instance_variable_set :@_, ThreadSafe::Hash.new{ |h,k| h[k] = ThreadSafe::Array.new }
  end

  def bind(event, &fn)
    fn ? @_[event] << fn : raise(ArgumentError, "no block given")
  end

  def unbind(event, &fn)
    fn ? @_[event].delete(fn) : @_.delete(event) || []
  end

  def trigger(event, *args)
    !@_[event].dup.each{ |fn| instance_exec(*args, &fn) }.empty?
  end
end
