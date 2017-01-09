module VerificationAssociations
  extend ActiveSupport::Concern


  def check_associations
    errors.clear
    # str_error = self.class.model_name.human.capitalize
    str_error = ''
    self.class.reflect_on_all_associations().each do |association|
      if send(association.name).any?

          str_error = str_error  +self.class.human_attribute_name(association.name).downcase+ ", "
      end
    end
    return '' if errors.any? || str_error == ''
    return (I18n.t 'errors.messages.delete_association')
  end

end