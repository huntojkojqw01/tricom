# coding: utf-8
require 'spec_helper'

describe EventDecorator do
  let(:event) { Event.new.extend EventDecorator }
  subject { event }
  it { should be_a Event }
end
