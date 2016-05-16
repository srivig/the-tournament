namespace :tasks do
  task :check_finished_tournaments => :environment do
    Tournament.all.each do |tnmt|
      tnmt.update(finished: true) if tnmt.is_finished?
    end
  end

  task :delete_unfinished_tournaments => :environment do
    Tournament.where(finished: false).where("created_at < ?", 1.month.ago).destroy_all
  end

  task :delete_nonactive_users => :environment do
    User.where("last_sign_in_at < ?", 2.year.ago).destroy_all
  end
end
