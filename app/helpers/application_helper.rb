module ApplicationHelper
  def formatted_name(user)
    # Format: An B. C. Dao Thi Ha
    fname_array = user.first_name.split
    lname_array = user.last_name.split
    fname = fname_array.shift.capitalize

    fname_array = fname_array.map { |word|
      word[0].upcase + "."
    }

    lname_array = lname_array.map { |word| word.capitalize }

    "#{fname} #{fname_array.join(' ')} #{lname_array.join(' ')}"
  end
end
