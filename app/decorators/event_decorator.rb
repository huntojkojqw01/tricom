# coding: utf-8
module EventDecorator
  def created_at
    self.created_at.strftime("%m/%d/%y - %H:%M")
  end
  
  def my_name
    'Hoang Minh Duc'
  end
end
