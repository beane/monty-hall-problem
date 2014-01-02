#!/usr/bin/env ruby

def setup_doors
  Array.new(3, "goat")
end

def randomly_place_car(doors)
  doors[rand(3)] = "car"
end

def reveal_random_goat(doors, first_guess)
  goat_index = doors.index("goat")
  
  while [first_guess, doors.index("car")].include?(goat_index)
    goat_index = (goat_index + 1) % 3
  end
  
  doors[goat_index] = "uncovered goat"
end

def pick_new_door(doors, first_guess)
  loop do
    choice = rand(3)
    next if doors[choice] == "uncovered goat"
    next if choice == first_guess
    
    return choice
  end
end

def prompt_for_num_tries
  system('clear')
  begin
    puts "This is a simulation of the Monty Hall problem."
    puts
    puts "Enter the number of times you want to run the simulation."
    puts "Only works for numbers between one and a million."
    puts "Add '-show' after your number to show each individual simulation."
    puts "Enter anything invalid to quit."
    puts
    printf "Number of runs: "
    
    num_times, show = gets.chomp.split('-')
  end
  
  [num_times.to_i, to_boolean(show)]
end

def to_boolean(str)
  return false if str.nil?
  str.downcase == "show"
end

no_change_wins = 0
wins           = 0
losses         = 0

num_tries, show = prompt_for_num_tries

# runs the test

(num_tries).times do |i|
  doors = setup_doors
  randomly_place_car(doors)
  
  first_guess = rand(3)
  no_change_wins += 1 if doors[first_guess] == "car"
  
  reveal_random_goat(doors, first_guess) # changes the array
  second_guess = pick_new_door(doors, first_guess)
  
  doors[second_guess] == "car" ? wins += 1 : losses += 1
  
  if show
    puts "Trial #{i+1}:"
    puts "\tDoor 1: #{doors[0]}"
    puts "\tDoor 2: #{doors[1]}"
    puts "\tDoor 3: #{doors[2]}"
    puts "\tfirst pick: #{doors[first_guess]}"
    puts "\tsecond pick: #{doors[second_guess]}"
  end
end

puts
puts "Results for not switching doors:"
puts "wins w/o change:    #{no_change_wins}"
puts "losses:             #{num_tries - no_change_wins}"
puts "percent wins:       #{100 * no_change_wins.to_f / num_tries}%"
puts "good stratgey?      #{no_change_wins > wins}"
puts
puts "Results for switching doors;"
puts "wins:               #{wins}"
puts "losses:             #{losses}"
puts "percent wins:       #{100 * wins.to_f / num_tries}%"
puts "good stratgey?      #{wins > no_change_wins}"
