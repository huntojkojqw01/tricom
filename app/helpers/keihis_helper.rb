module KeihisHelper
  def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for( association, new_object, child_index: id) do |child_for_form|
      render(association.to_s.singularize + "_fields", f: child_for_form)
    end
    link_to(name, '', class: "add_fields", data: { id: id, fields: fields.gsub("\n", "")})
  end
  
  def link_to_add_row(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for( association, new_object, child_index: id) do |child_for_form|
      render(association.to_s.singularize + "_row", f: child_for_form)
    end
    link_to(name, '', class: "add_row", data: { id: id, fields: fields.gsub("\n", "")})
  end
end