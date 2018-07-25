module Import
  def import_from_csv(table_name, csv_file, headers = nil, primary_keys = nil)
    if table_name.instance_of? String
      table = table_name.constantize
    elsif table_name.instance_of? Class
      table = table_name
    else
      return "テーブル名が見つかりません"
    end

    headers = table::HEADERS unless headers
    primary_keys = table::PRIMARY_KEYS unless primary_keys
    
    CSV.foreach(csv_file.path, headers: true) do |row|
      hash = row.to_hash
      #check header cua file hop le
      missing_columns = headers - hash.keys
      if missing_columns.empty?
        hash.slice!(*headers)
      else
        return "行#{$.} カラム: #{missing_columns.join("、")} 必要"
      end
      
      #check khoa chinh hop le
      return "行#{$.} キー: #{primary_keys.join("、")} 必要" unless (primary_keys - hash.keys).empty?

      record = table.find_by(hash.slice(*primary_keys))
      if record
        return "行#{$.} #{record.errors.full_messages.join("、")}" unless record.update(hash)
      else
        record = table.new(hash)
        return "行#{$.} #{record.errors.full_messages.join("、")}" unless record.save
      end
    end
    return nil
  rescue => err
    return err
  end
end