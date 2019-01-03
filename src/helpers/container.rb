require 'docker'

# Things
module Container
  def self.get_container(name)
    Docker.url = 'tcp://192.168.1.130:2376'
    my_container = ''
    containers = Docker::Container.all
    containers.each do |container|
      container_name = container.info['Names'].first[1..-1]
      my_container = container unless container_name != name
    end
    my_container
  end
end
