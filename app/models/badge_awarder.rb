# Observes the user stats_sheet and awards badges
# when the badge's award critiria are met. 

class BadgeAwarder < ActiveRecord::Observer

  observe StatsSheet

  # Award unearned badges to the user associated with
  # the stats sheet if the badge criteria is met.
  def after_save(stats_sheet)
    if stats_sheet.xp.instance_of? User 
      user = stats_sheet.xp
      newly_earned = select_earned_from(Badge.unearned_badges_for(user), stats_sheet)
      user.earned_badges << newly_earned
      user.save!
    end
  end

  def select_earned_from(unearned, stats_sheet)
    unearned.select{|b| b.award?(stats_sheet)}
  end
end