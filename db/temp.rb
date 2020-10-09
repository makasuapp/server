# typed: strict

kitchen = Kitchen.find_or_create_by(name: "Test")
date = DateTime.now.in_time_zone("America/Toronto")
op_day = OpDay.find_or_create_by!(date: date, kitchen_id: kitchen.id)
