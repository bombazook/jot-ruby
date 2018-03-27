module Jot
  module Ruby
    module Utils
      module Snippets
        def not_implemented *method_names
          method_names.flatten.each do |method_name|
            define_method method_name do |*args|
              unless Jot::Ruby.impl
                Jot::Ruby.init
                return self.send method_name, *args
              end
              raise NotImplementedError, method_name
            end
          end
        end

        def gem_root
          root = File.dirname(File.expand_path(caller_locations(1,1)[0].path))
          while(root != '/')
            return root unless Dir[File.join(root, "*.gemspec")].empty?
            root = File.dirname(root)
          end
          nil
        end
      end
    end
  end
end
