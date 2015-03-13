require_relative '../lib/microevent'
require 'minitest/autorun'

describe MicroEvent do
  let :object do
    object = Object.new
    object.extend(MicroEvent)
    object
  end

  it "works" do
    result = []

    fn = proc{ result << 42 }
    object.bind :slot, &fn
    object.trigger :slot

    assert_equal [42], result
  end

  it "works with blocks" do
    result = []

    object.bind(:slot){ result << 42 }
    object.trigger :slot

    assert_equal [42], result
  end

  it "supports multiple callbacks" do
    result = []

    fn  = proc{ result << 42 }
    fn2 = proc{ result << 23 }
    object.bind :slot, &fn
    object.bind :slot, &fn2
    object.trigger :slot

    assert_equal [42, 23], result
  end

  it "supports multiple of the same callback" do
    result = []

    fn  = proc{ result << 21 }
    object.bind :slot, &fn
    object.bind :slot, &fn
    object.trigger :slot

    assert_equal [21, 21], result
  end

  it "only calls the triggered slot" do
    result = []

    fn  = proc{ result << 42 }
    object.bind :slot, &fn
    object.trigger :another_slot

    assert_equal [], result
  end

  it "works with arguments" do
    result = []

    fn  = proc{ |add| result << add }
    object.bind :slot, &fn
    object.trigger :slot, 42

    assert_equal [42], result
  end

  it "has access to object's instance variables" do
    result = []
    object.instance_variable_set :@var, 42

    fn = proc{ result << @var }
    object.bind :slot, &fn
    object.trigger :slot

    assert_equal [42], result
  end

  it "has access to object's methods" do
    result = []
    def object.m() 42 end

    fn = proc{ result << m }
    object.bind :slot, &fn
    object.trigger :slot

    assert_equal [42], result
  end

  describe '#bind details' do
    it "returns array of callbacks" do
      fn = proc{}
      object.bind :slot, &fn
      result = object.bind :slot, &fn

      assert_equal [fn, fn], result
    end

    it "willl raise an ArgumentError if no block given" do
      result = nil

      begin
        object.bind :slot
      rescue ArgumentError => result
      end

      assert_equal ArgumentError, result.class
    end
  end

  describe '#unbind details' do
    it "removes an callback" do
      result = []

      fn = proc{ result << 42 }
      object.bind :slot, &fn
      object.unbind :slot, &fn
      object.trigger :slot

      assert_equal [], result
    end

    it "willl removes all instances of this callback" do
      result = []

      fn = proc{ result << 42 }
      fn2 = proc{ result << 23 }
      object.bind :slot, &fn
      object.bind :slot, &fn2
      object.bind :slot, &fn
      object.unbind :slot, &fn
      object.trigger :slot

      assert_equal [23], result
    end

    it "will do nothing if there is nothing to remove" do
      result = []

      object.unbind :slot

      assert_equal [], result
    end

    it "returns deleted callbacks" do
      fn = proc{}
      object.bind :slot, &fn
      result = object.unbind :slot, &fn

      assert_equal fn, result
    end

    it "will return nil if nothing is removed" do
      fn = proc{}
      result = object.unbind :slot, &fn

      assert_equal nil, result
    end

    it 'will delete all callbacks if no block is given' do
      result = []

      fn = proc{ result << 42 }
      fn2 = proc{ result << 23 }
      object.bind :slot, &fn
      object.bind :slot, &fn2
      object.unbind :slot
      object.trigger :slot

      assert_equal [], result
    end

    it 'will return array of deleted callbacks if no block is given' do
      fn = proc{ result << 42 }
      fn2 = proc{ result << 23 }
      object.bind :slot, &fn
      object.bind :slot, &fn2
      result = object.unbind :slot

      assert_equal [fn, fn2], result
    end

    it 'will return emtpy array if no block is given and no callback deleted' do
      result = object.unbind :slot

      assert_equal [], result
    end
  end

  describe '#trigger details' do
    it "will do nothing if no callback is registered" do
      result = []

      object.trigger :slot

      assert_equal [], result
    end

    it "will return true if there is a callback listening" do
      fn = proc{}
      object.bind :slot, &fn
      result = object.trigger :slot

      assert_equal true, result
    end

    it "will return false if there is no callback listening" do
      result = object.trigger :slot

      assert_equal false, result
    end
  end

  describe "thread safety" do
    it "is thread safe when unbinding while triggering" do
      mutex = Mutex.new
      result = []

      procs = (0...5000).map {
        proc{ mutex.synchronize{ result << 42 } }
      }
      procs.each{ |proc|
        object.bind :slot, &proc
      }
      thread = Thread.new do
        procs.each{ |proc|
          object.unbind :slot, &proc
        }
      end
      object.trigger :slot
      thread.join

      assert_equal 5000, result.size
    end
  end
end
