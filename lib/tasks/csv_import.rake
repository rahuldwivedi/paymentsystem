require 'csv'

namespace :csv_import do
  desc "Upload user with csv filename"
  task :user, [:filename] => [:environment] do |t, args|
    CSV.foreach(args[:filename], headers: true) do |row|
      User.create(row.to_h)
    end
  end
end
