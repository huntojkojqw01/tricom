Temp.delete_all
Temp.reset_pk_sequence
Temp.create!([
                         {date: Date.today, checked: false}
                     ])