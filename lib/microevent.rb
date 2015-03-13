module MicroEvent
  VERSION = "1.0.1".freeze

  def bind(event, &fn)
    fn ? _[event] << fn : raise(ArgumentError, "no block given")
  end

  def unbind(event, &fn)
    fn ? _[event].delete(fn) : events.delete(event) || []
  end

  def trigger(event, *args)
    !_[event].each{ |fn| instance_exec(*args, &fn) }.empty?
  end
  
  private 
  def _
    @_ ||= Hash.new{ |h,k| h[k] = [] }
  end
end
