module Jot
  module Ruby
    module Utils
      module Snippets
        def not_implemented *method_names
          method_names.flatten.each do |method_name|
            define_method method_name do |*args|
              raise NotImplementedError, method_name
            end
          end
        end

        def gem_root
          Gem::Specification.find_by_name('jot-ruby').gem_dir
        end
      end
    end
  end
end
