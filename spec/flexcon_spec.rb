require 'spec_helper'

describe Flexcon do
  it 'has a version number' do
    expect(Flexcon::VERSION).not_to be nil
  end

  describe Flexcon do
    context 'when the scope is an array' do
      let (:scope) { ['A', 'B', 'C'] }

      let (:none)    { lambda { 'None' }}
      let (:single)  { lambda { |x|       [x] }}
      let (:double)  { lambda { |x, y|    [y, x] }}
      let (:tripple) { lambda { |x, y, z| [z, y, x] }}
      
      it { expect(Flexcon.dispatch(scope, none)).to    eq('None') }
      it { expect(Flexcon.dispatch(scope, single)).to  eq(['A']) }
      it { expect(Flexcon.dispatch(scope, double)).to  eq(['B', 'A']) }
      it { expect(Flexcon.dispatch(scope, tripple)).to eq(['C', 'B', 'A']) }
    end

    context 'when the scope is a hash' do
      let (:scope) do 
        { 
          models: [:user, :student, :university], 
          props: [{ student: { user: nil, university: nil }}],
          transactions: [:save]
        }
      end

      let (:none)         { lambda { 'None' }}
      let (:models)       { lambda { |models| models }}
      let (:props)        { lambda { |props| props }}
      let (:transactions) { lambda { |transactions| transactions }}
      let (:all)          { lambda { |props, models, transactions| [props, models, transactions] }}

      it { expect(Flexcon.dispatch(scope, none)).to            eq('None') }
      it { expect(Flexcon.dispatch(scope, models)).to          eq([:user, :student, :university]) }
      it { expect(Flexcon.dispatch(scope, props)).to           eq([{ student: { user: nil, university: nil }}]) }
      it { expect(Flexcon.dispatch(scope, transactions)).to    eq([:save]) }
      it { expect(Flexcon.dispatch(scope, all)).to             eq([
                                                                [{ student: { user: nil, university: nil }}],
                                                                [:user, :student, :university],
                                                                [:save]
                                                              ]) }
    end

    context 'when the scope is an object' do
      let (:scope) do
        Struct.new(:name, :email, :addresses).new('John', 'jdoe@company.com', ['Mars', 'Earth'])
      end

      let (:none)      { lambda { 'None' }}
      let (:name)      { lambda { |name| name }}
      let (:email)     { lambda { |email| email }}
      let (:addresses) { lambda { |addresses| addresses }}
      let (:all)       { lambda { |name, email, addresses| [name, email, addresses] }}

      it { expect(Flexcon.dispatch(scope, none)).to      eq('None') }
      it { expect(Flexcon.dispatch(scope, name)).to      eq('John') }
      it { expect(Flexcon.dispatch(scope, email)).to     eq('jdoe@company.com') }
      it { expect(Flexcon.dispatch(scope, addresses)).to eq(['Mars', 'Earth']) }
      it { expect(Flexcon.dispatch(scope, all)).to       eq(['John', 'jdoe@company.com', ['Mars', 'Earth']]) }
    end
  end
end
