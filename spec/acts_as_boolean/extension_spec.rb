require 'spec_helper'

describe ActsAsBoolean do
  context 'defaults' do
    let(:klass) { Post.new }
    it 'responds to published?' do
      expect(klass).to respond_to(:published?)
      expect(klass).to respond_to(:published)
      expect(klass).to respond_to(:really_deleted?)
      expect(klass).to respond_to(:really_deleted)
    end
    it 'sets the time with true' do
      expect(klass.published_at).to be_nil
      klass.published = true
      expect(klass.published?).to be_truthy
      expect(klass.published).to be_truthy
      expect(klass.published_at).to be_present
      expect(klass.published_at).to be_a(Time)
      klass.published = false
      expect(klass.published_at).to be_nil
    end
    it 'nils the time if false' do
      ActiveModel::Type::Boolean::FALSE_VALUES.each do |value|
        expect(klass.published_at).to be_nil
        klass.published = true
        expect(klass.published_at).to be_present
        klass.published = value
        expect(klass.published_at).to be_nil
      end
    end
  end
  context 'scopes' do
    it 'has published scope' do
      posts = Post.published
      expect(posts.size).to eq(1)
      expect(posts.first.title).to eq("This is a published_at post")
    end
    it 'has really_deleted scope' do
      posts = Post.really_deleted
      expect(posts.size).to eq(1)
      expect(posts.first.title).to eq("This is a really_deleted post")
    end
  end
end