describe "Refinery status responder" do
  it "should instruct a user how to post a gist" do
    @bot.message :channel => "!status refinery"
    @bot.channel_messages.should include "MoreTea asked about the refinery stats:"
    ['Forks', 'Watchers', 'Open issues', 'Average time open'].each do |term|
      @bot.channel_messages.should include term
    end

    @bot.clear!

    @bot.message :private => "!status refinery"
    ['Forks', 'Watchers', 'Open issues', 'Average time open'].each do |term|
      @bot.notices("MoreTea").should include term
    end
  end
end
