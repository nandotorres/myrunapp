class Run < ActiveRecord::Base
  belongs_to :user
  after_save :update_total_distance
  
  def user_distance_unit
    return "Km" if user.distance_in_km? or return "Mi"
  end

  def user_run_equipment
    return equipmentType if equipmentType.present? or return "ipod"
  end

  def regionalized_date
    zoned_time = start_time.in_time_zone(user.timezone)
    if I18n.locale.to_s == "pt_BR"	  
      "#{I18n.t(:day_names)[zoned_time.wday]}, #{zoned_time.day} de #{I18n.t(:month_names)[zoned_time.mon]} as #{zoned_time.hour}h#{zoned_time.sec}"
    else
      zoned_time.strftime("%B, %d at %Hh%M")
    end
  end

  def regionalized_duration
    if (duration / 60000) > 60
      "#{(duration / 3600000).to_i}h#{(duration % 3600000).to_s[0..1]}"
    else
      "#{(duration/60000).round(2)}min"
    end
  end

  def regionalized_speed
    if user.speed_in_km?
      "#{(distance / (duration / 3600000.0)).round(2)}Km/h"
    else
      "#{((duration / 60000.0)/distance).round(2)}Min/Km".gsub(".", ":")
    end
  end
  
  def update_total_distance
    user.total_distance = user.total_distance + distance
    user.save    
  end

end
