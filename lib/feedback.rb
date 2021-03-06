class Feedback
  
  # Return a friendly feedback message
  # based on the grade sheet.
  def self.on(grade_sheet)

    if grade_sheet.errors.any?
      return grade_sheet.errors.full_messages.first 
    end

    if grade_sheet.unit_tests_failed?
      Rails.logger.error "An invalid grade sheet was produced:"
      grade_sheet.errors.full_messages.each {|msg| Rails.logger.error(msg)}
      return "I'm embarrased! An internal error occurred, sorry about that. Try again a bit later."
    end

    grade_sheet.unit_tests.each_pair do |test_name, result|
      if nil == result[:output]
        return "Wouldn't your solution crash at run time? Double check it!" 
      elsif result[:output].strip.chomp != result[:expected].strip.chomp
        return to_friendly_msg(result)
      end
    end
    "This looks like it could work!"
  end

  # The unit test failed, give some feedback
  def self.to_friendly_msg(result)
    input  = result[:input].strip.chomp
    output = result[:output].strip.chomp

    case input
      when "" then "Are you sure this would work for the empty string?"
      when input.length > 25 then "I'm not sure this is right, double check it"
      else "Are you sure this would work for the input '#{input}'?"
    end
  end
end
