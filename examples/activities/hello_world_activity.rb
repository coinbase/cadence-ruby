class HelloWorldActivity < Cadence::Activity
  def execute(name)
    raise 'Test error' if name == 'Failure'

    p "Hello World, #{name}"

    return
  end
end
