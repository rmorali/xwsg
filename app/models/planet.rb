class Planet < ApplicationRecord

 serialize :domination, Hash
 has_many :fleets
  
 def image
   "planets/#{name.downcase}.png"
 end
 
end
