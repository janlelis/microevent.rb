module MicroEvent
  VERSION = "1.0.2".freeze

  def bind(event, &fn)
    @_ ||= Hash.new{ |h,k| h[k] = [] }
    fn ? @_[event] << fn : raise(ArgumentError, "no block given")
  end

  def unbind(event, &fn)
    @_ ||= Hash.new{ |h,k| h[k] = [] }
    fn ? @_[event].delete(fn) : @_.delete(event) || []
  end

  def trigger(event, *args)
    @_ ||= Hash.new{ |h,k| h[k] = [] }
    !@_[event].dup.each{ |fn| instance_exec(*args, &fn) }.empty?
  end
end
