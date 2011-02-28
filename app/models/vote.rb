# A vote or flag. Should have a direction, item id, userid and date
# direction will probably be an enum { 0 => flag, 1 => promote }
class Vote < ActiveRecord::Base
end
