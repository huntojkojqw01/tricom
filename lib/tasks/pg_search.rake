namespace :pg_search do
  desc "Pg Search rebuild all"
  task rebuild_all: :environment do
  	table_list = [Bashokubunmst, Bashomaster, Bunrui, Dengon, Dengonkaitou, Dengonyouken, Eki, Event, Jobmaster, Joutaimaster, JptHolidayMst, Kairan, Kairanyokenmst, Kaishamaster, Keihihead, Kikanmst, Kintai, Kouteimaster, Rorumaster, Rorumenba, Setsubi, Shainmaster, Shoninshamst, Shozai, Shozokumaster, Tsushinseigyou, User, Yakushokumaster, Yuusen, YuukyuuKyuukaRireki]
  	table_list.each do |table_name|
  		PgSearch::Multisearch.rebuild(table_name)
  	end
  end

end
