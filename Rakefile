require "rake/testtask"
require "rake/clean"

desc "Default: run all tests"
task :default => :test

desc "Run tests"
task :test => %w[test:unit test:acceptance]
namespace :test do
  desc "Run unit tests"
  Rake::TestTask.new(:unit) do |t|
    t.libs << "test"
    t.test_files = FileList["test/unit/*_test.rb"]
  end

  desc "Run acceptance tests"
  Rake::TestTask.new(:acceptance) do |t|
    t.libs << "test"
    t.test_files = FileList["test/acceptance/*_test.rb"]
  end
end

desc "Create the database"
task :db do
  require "init"
  DataMapper.auto_upgrade!
end
CLOBBER.include("integrity.db")

desc "Clean-up build directory"
task :cleanup do
  require "init"
  Integrity::Build.all(:completed_at.not => nil).each { |build|
    dir = Integrity.directory.join(build.id.to_s)
    dir.rmtree if dir.directory?
  }
end

namespace :jobs do
  desc "Clear the delayed_job queue."
  task :clear do
    require "init"
    require "integrity/builder/delayed"
    Delayed::Job.delete_all
  end

  desc "Start a delayed_job worker."
  task :work do
    require "init"
    require "integrity/builder/delayed"
    Delayed::Worker.new.start
  end
end

begin
  namespace :resque do
    require "resque/tasks"

    desc "Start a Resque worker for Integrity"
    task :work do
      require "init"
      ENV["QUEUE"] = "integrity"
      Rake::Task["resque:resque:work"].invoke
    end
  end
rescue LoadError
end

desc "Generate HTML documentation."
file "doc/integrity.html" => ["doc/htmlize",
  "doc/integrity.txt",
  "doc/integrity.css"] do |f|
  sh "cat doc/integrity.txt | doc/htmlize > #{f.name}"
end

desc "Re-generate stylesheet"
file "public/integrity.css" => "views/integrity.sass" do |f|
  sh "sass views/integrity.sass > #{f.name}"
end

CLOBBER.include("doc/integrity.html")

namespace :bundle do
  task :install do
    sh 'bundle install'
  end
  CLOBBER.include(".bundle")
  task :lock => :install do
    sh 'bundle lock'
  end
  CLOBBER.include("Gemfile.lock")
end

desc 'create a place for builds'
directory 'builds' do
  mkdir 'builds'
end
CLOBBER.include("builds")

desc "setup everything to run integrity"
task :bootstrap => ['bundle:lock', :db, 'builds']

CLOBBER.include("integrity.log")
