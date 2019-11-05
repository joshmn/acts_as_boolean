require "bundler/setup"
require "rails/all"
require "acts_as_boolean"

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

class TestApplication < Rails::Application
end

module Rails
  def self.root
    Pathname.new(File.expand_path("../", __FILE__))
  end

  def self.cache
    @cache ||= ActiveSupport::Cache::MemoryStore.new
  end

  def self.env
    "test"
  end
end

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Schema.verbose = false
ActiveRecord::Schema.define(version: 1) do
  create_table :posts do |t|
    t.string :title
    t.datetime :published_at
    t.datetime :user_wanted_to_delete_this_time
  end
  add_index :posts, :published_at
  add_index :posts, :user_wanted_to_delete_this_time
end

Rails.application.instance_variable_set("@initialized", true)

class Post < ActiveRecord::Base
  extend ActsAsBoolean::Extension
  acts_as_boolean :published_at
  acts_as_boolean :user_wanted_to_delete_this_time, as: :really_deleted
end

RSpec.configure do |config|
  config.before(:suite) do
    Post.create(title: "This is a good post")
    Post.create(title: "This is a published_at post", published_at: 1.second.ago)
    Post.create(title: "This is a really_deleted post", user_wanted_to_delete_this_time: 1.second.ago, published_at: 5.years.from_now)
  end
end

