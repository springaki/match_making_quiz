require './match_making.rb'

describe MatchMaking do

  let(:question_str) do
    <<-EOS.strip
A:c,a,b
B:c,f,a
C:f,c,b
D:d,d,d
E:
F:e,c,a
a:A,D,F
b:C,B,A
c:D,A,C
d:A,A,B
e:C,A,E
f:D,B,A
EOS
  end

  let(:expect_str) do
    <<-EOS
A=c
B=f
C=b
F=a
EOS
  end

  describe '#match' do
    subject{ MatchMaking.new(question_str) }
    it 'success pattern' do
      expect(subject.match).to eq expect_str
    end
  end
end


describe 'Person#request' do
  let(:person_a) {MatchMaking::Person.new "A:c,b,a"}
  let(:person_c) {MatchMaking::Person.new "c:B,A,C"}

  before do
    MatchMaking::Person.reset
    person_a
    person_c
  end

  it 'not mathing' do
    MatchMaking::Person.done(["c"])
    expect(person_c.request_list(1).include?(person_a.name)).to be_false
  end

  it '#request_list with 1' do
    expect(person_a.request_list(1)).to eq ["c"]
  end

  it '#request_list with 2' do
    expect(person_a.request_list(2)).to eq ["c","b"]
  end

  it '#include?' do
    expect(person_c.request_list(2).include?(person_a.name)).to be_true
  end

  it 'MatchMaking::Person#size' do
    expect(MatchMaking::Person.size).to eq 2
  end

  it 'PeMatchMaking::Personrson#done' do
    MatchMaking::Person.done(["c"])
    expect(MatchMaking::Person.size).to eq 1
  end
end
