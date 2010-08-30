# The model has already been created by the framework, and extends Rhom::RhomObject
# You can add more methods here
# allow set :sync_priority,1
# allow set :source_id,1
# allow set :partition,"user"
# allow enable :sync
class Searchs
  include Rhom::PropertyBag
  set :source_id, 1

  #add model specifc code here
end
