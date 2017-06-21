table=ARGV[0]
filename=ARGV[1]
if table!=nil && filename!=nil && filename!=""
    filename+=".yml" unless filename[-4..-1]==".yml"
    table=table.capitalize
        f=File.open("spec/fixtures/#{filename}","w")
        table.constantize.all.each.with_index do |element,i|
            f.write "#{table.downcase}_#{i}:\n"
            table.constantize.column_names.each.with_index do |name,i|
                if table.constantize.column_for_attribute(name).type== "string".to_sym
                    f.write " #{name}: \"#{element.send(name)}\"\n"
                else
                    f.write " #{name}: #{element.send(name)}\n"
                end
            end
        end
        f.close
else
    print "Wrong number argument( syntax: rails r make_yml.rb TABLENAME FILENAME)\n"
end