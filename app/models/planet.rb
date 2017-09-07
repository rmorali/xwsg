class Planet < ApplicationRecord

 serialize :domination, Hash
 
 def image
   "planets/#{name.downcase}.png"
 end
 
end
