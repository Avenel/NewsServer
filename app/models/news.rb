class News < ActiveRecord::Base
  attr_accessible :content, :date, :organisation, :title
end
