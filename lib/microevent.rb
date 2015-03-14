module MicroEvent
  VERSION = "1.0.2".freeze

  def bind(event, &fn)
    @_ ||= Hash.new{ |h,k| h[k] = [] }
    fn ? @_[event] << fn : raise(ArgumentError, "no block given")
  end

  def unbind(event, &fn)
    fn ? @_ && @_[event].delete(fn) : @_ && @_.delete(event) || []
  end

  def trigger(event, *args)
    !!@_ && !@_[event].dup.each{ |fn| instance_exec(*args, &fn) }.empty?
  end
end
