namespace :backup do
  desc "Dumps the database to backups"
    task :dump => :environment do
        cmd = "PGPASSWORD=#{ENV['JPTPASSWORD']} pg_dump -F c -v -h localhost -U jpt -d #{ENV['JPTDB']} -f ../Backups/tricom_jpt.psql"
        puts cmd
        exec cmd
    end

  desc "Restores the database from backups"
    task :restore, [:date] => :environment do |task,args|
        if args.date.present?
            cmd = "pg_restore -F c -v -c -C ../Backups/#{args.date}_jpt.psql"

            Rake::Task["db:drop"].invoke
            Rake::Task["db:create"].invoke
            puts cmd
            exec cmd
        else
            puts 'Please pass a date to the task'
        end
    end

  desc "Push to Github"
    task :gitadd => :environment do |task,args|
      exec "echo 'Save at #{Time.now.strftime("%Y/%m/%d %Hh %Mm %Ss")} ...' && git -C ../Backups add -A"        
    end
    task :gitcommit => :environment do |task,args|
      exec "git -C ../Backups commit -m '#{Time.now}'"        
    end
    task :gitpush => :environment do |task,args|
      exec "git -C ../Backups push"        
    end
  
end
