require_relative 'microevent/version'

require 'thread_safe'

module MicroEvent
  @mutex = Mutex.new

  class << self
    attr_reader :mutex
  end

  def bind(event, &fn)
    MicroEvent.mutex.synchronize{
      @_ ||= ThreadSafe::Hash.new{ |h,k| h[k] = ThreadSafe::Array.new }
    } unless @_
    fn ? @_[event] << fn : raise(ArgumentError, "no block given")
  end

  def unbind(event, &fn)
    fn ? @_ && @_[event].delete(fn) : @_ && @_.delete(event) || []
  end

  def trigger(event, *args)
    !!@_ && !@_[event].dup.each{ |fn| instance_exec(*args, &fn) }.empty?
  end
end
