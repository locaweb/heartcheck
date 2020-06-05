module Heartcheck
  module Services
    module Formatters    
      class HashResponse 
        def format(checks)  
          checks.map do |check|
            edit_hash(check)
          end.reduce({}, :merge)
        end
  
        private
  
        def edit_hash(check)
          check.tap do |obj|
            value = obj.values.first.merge(Hash[:time => obj[:time]])
            obj.delete(:time)
            obj.merge!(Hash[obj.keys.first => value])
          end
        end 
      end
    end
  end
end
  