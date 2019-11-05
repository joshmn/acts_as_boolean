require 'spec_helper'

describe ActsAsBoolean do
  context 'config' do
    it 'is configurable sorry' do
      expect(ActsAsBoolean.timeish.call).to be_a(Time)
      expect(ActsAsBoolean.normalize_column.call("published_at")).to eq("published")
      original_normalize_column = ActsAsBoolean.normalize_column
      ActsAsBoolean.normalize_column = -> (str) { str.to_sym }
      expect(ActsAsBoolean.normalize_column.call("bob")).to eq(:bob)
      ActsAsBoolean.normalize_column = original_normalize_column
    end
  end
end