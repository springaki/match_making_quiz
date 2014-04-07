class MatchMaking

  def initialize(order)
    order.each_line do |line|
      Person.new(line.chomp)
    end
  end

	def match
    "".tap do |result|
      (1..Person.max_order_size).each do |order_index|
        Person.all.each do |key,person|
          v = person.request_list(order_index).map{|m| Person.all[m]}
          v.each do |e|
            if e && e.request_list(order_index).include?(key)
              result << "#{key}=#{e.name}\n"
              Person.done([key, e.name])
              break
            end
          end
        end
      end
    end
  end

  class Person
    attr_reader :name, :order
    @@people = {}
    @@max_order_size = 0

    def initialize(request)
      @name, @order = request.split(":",2)
      @order = @order.split(",")
      @@max_order_size = @order.size if @@max_order_size < @order.size
      @@people[@name] = self
    end

    def request_list(range_to=1)
      order[0,range_to]
    end

    class << self
      def done(names)
        names.each {|name| @@people.reject!{|key| key == name}}
      end

      def include?(name)
        @@people[name]
      end

      def size
        @@people.size
      end

      def reset
        @@people = {}
      end

      def all
        @@people
      end

      def max_order_size
        @@max_order_size
      end
    end
  end

end