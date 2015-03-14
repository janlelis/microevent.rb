module MicroEvent;VERSION="1.1.0".freeze
def bind(e,&f)@_||=Hash.new{|h,k|h[k]=[]}
f ?@_[e]<<f :raise(ArgumentError,"no block given")end
def unbind(e,&f)f ?@_&&@_[e].delete(f):@_&&@_.delete(e)||[]end
def trigger(e,*f)!!@_&&!@_[e].dup.map{|g|instance_exec *f,&g}.empty?end
end